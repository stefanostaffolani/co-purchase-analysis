import org.apache.spark
import org.apache.spark.HashPartitioner
import org.apache.spark.sql.SparkSession
// sparkSession has a saprkContex inside

object CoPurchaseAnalysis {

  def main(args: Array[String]): Unit = {
    if (args.length != 3) {
      println("The arguments must be 3")
      return
    }
    val spark = SparkSession.builder
      .appName("CoPurchase analysis")
      .getOrCreate()
    val numCores = 4;
    val numWorkers = args(2).toInt
    if (numWorkers > 4 || numWorkers < 1) {
      println("the number of workers must be between 1 and 4")
      return
    }
    val partitions = 2 * numCores * numWorkers;
    println(s"Partitions: ${partitions}")
    // since we want to use an RDD we have to call the sparkContext
    // spark.read.text("path/to/file.txt") return a DF
    // https://spark.apache.org/docs/latest/api/java/org/apache/spark/SparkContext.html#defaultParallelism()
    val startTime = System.nanoTime()

    val input = spark.sparkContext
      .textFile(args(0))
      .map((line) => line.split(","))
      .map(w => (w(0).toInt, w(1).toInt))

    val partitioned = input.partitionBy(
      new HashPartitioner(partitions)
    )
    try {
      val prodPair = partitioned
        .groupByKey()
        .flatMap {
          case (_, products) => {
            val prodlist = products.toSeq
            for {
              x <- prodlist
              y <- prodlist
              if (x < y)
            } yield ((x, y), 1)
          }
        }
      val result = prodPair.reduceByKey(_ + _)
      val prettified = result.map { case (prods, numbers) =>
        s"${prods._1},${prods._2},$numbers"
      }
      val toOne = prettified.repartition(1)
      toOne.saveAsTextFile(args(1))
      val endTime = System.nanoTime()
      val runTime = (endTime - startTime) / 1e9 
      println(s"T : ${runTime} s")

    } catch {
      case e: Throwable => println(e)
    } finally {
      spark.stop()
    }
    // https://stackoverflow.com/questions/31610971/spark-repartition-vs-coalesce
  }
}
