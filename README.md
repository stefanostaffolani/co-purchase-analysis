# Co-Purchase-Analysis

This is the project of Scalable and Cloud Programming (81942) course of Unibo a.y. 2024/2025.

The aim of the project was to develop a Scala/Spark application for computing the co-purchase analysis of products taken from CSV dataset.
The dataset should be moved in `src/dataset/order_products.csv`.

## Prerequisites
- Scala 2.12
- Spark 3.5
- SBT
- google-cloud-sdk


## Building

Run :

```
sbt compile
```

Then run the following command for creating a  `.jar`:

```
cd target/scala-2.12/classes/
jar cvfe CoPurchaseAnalysis.jar CoPurchaseAnalysis CoPurchaseAnalysis*.class
cd -
```

## Local Run

For running the application in local it's necessary to export the `$SPARK_HOME` env variable with the respective path of Spark installation and the run the following command.

```
$SPARK_HOME/bin/spark-submit --class CoPurchaseAnalysis --master local[*] target/scala-2.12/classes/CoPurchaseAnalysis.jar src/dataset/test_dataset output

```
## Run on DataProc
For running on Google Cloud Dataproc you need first to authenticate with:
```bash
gcloud init
```
Then move to directory `scripts` and export the following environment variable with your config:
```bash
export PROJECT_ID=""
export BUCKET_NAME=""
export REGION=""
export NUM_WORKERS=""
```
The you can create a project with `id` PROJECT_ID with:
```bash
gcloud projects create $PROJECT_ID
gcloud config set project $PROJECT_ID
```
If you encounter problems with billing check `[text](https://console.cloud.google.com/billing/projects)`
Then you can create a Bucket in GCP Storage using:
```
./create-bucket.sh
```
copy jar and dataset to Bucket with:
```
./copy-artifacts-to-bucket.sh
``` 
create a cluster with:
```
./create-cluster.sh --cluster-name NAME
```
submit a job with:
```
./submit-job.sh --cluster-name NAME
```
and finally delete the cluster and the bucket
```
./delete-cluster.sh --cluster-name NAME 
./delete-bucket.sh 
```
