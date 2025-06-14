
## Compilazione
Per compilare eseguire:
```
sbt compile
``` 
dopodichè è possibile ottenere in file .jar come segue:
```
cd target/scala-2.12/classes/
jar cvfe CoPurchaseAnalysis.jar CoPurchaseAnalysis CoPurchaseAnalysis*.class
cd -
```
## Run in locale
Per eseguire in locale è necessario esportare la variabile di ambiente `$SPARK_HOME` con il rispettivo path all'installazione di spark.
```
$SPARK_HOME/bin/spark-submit --class CoPurchaseAnalysis --master local[*] target/scala-2.12/classes/CoPurchaseAnalysis.jar src/dataset/test_dataset output
```