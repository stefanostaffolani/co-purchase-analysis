import org.apache.spark
import org.apache.spark.HashPartitioner
import org.apache.spark.sql.SparkSession
// sparkSession has a saprkContex inside

object CoPurchaseAnalysis {

  def main(args: Array[String]): Unit = {
    if (args.length != 2) {
      println("The arguments must be 2")
      return
    }
    val spark = SparkSession.builder
      .appName("CoPurchase analysis")
      // .config(conf)
      .getOrCreate()
    // since we want to use an RDD we have to call the sparkContext
    // spark.read.text("path/to/file.txt") return a DF
    // https://spark.apache.org/docs/latest/api/java/org/apache/spark/SparkContext.html#defaultParallelism()
    val input = spark.sparkContext
      .textFile(args(0))
      .map((line) => line.split(","))
      .map(w => (w(0).toInt, w(1).toInt))
    val partitioned = input.partitionBy(
      new HashPartitioner(2 * spark.sparkContext.defaultParallelism)
    )
    try {
      val result = partitioned
        .groupByKey()
        .flatMap {
          case (_, products) => {
            val prodlist = products.toList
            for {
              x <- prodlist
              y <- prodlist
              if (x < y)
            } yield ((x, y), 1)
          }
        }
        .reduceByKey(_ + _)
        .map { case (prods, numbers) =>
          s"prod1: ${prods._1}, prod2: ${prods._2} => $numbers"
        }
        .coalesce(1)
        .saveAsTextFile(args(1))
    } catch {
      case e: Throwable => println(e)
    } finally {
      spark.stop()
    }
    // https://stackoverflow.com/questions/31610971/spark-repartition-vs-coalesce
    // We use coalesce because we want to decrease the total number of partition so it is more efficient
  }
}
