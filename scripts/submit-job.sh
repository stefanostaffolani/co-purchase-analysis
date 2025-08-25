
usage() {
    echo "Usage: $0  --region REGION "
    echo
    echo "  --cluster-name    Nome del cluster "
    echo "  --region          Regione del cluster (default: europe-west1)"
    echo
    exit 1
}

while [[ "$#" -gt 0 ]]; do
    case $1 in
        --cluster-name) CLUSTER_NAME="$2"; shift ;;
        --region) REGION="$2"; shift ;;
        -h|--help) usage ;;
        *) echo "Parametro sconosciuto: $1"; usage ;;
    esac
    shift
done

CLUSTER_NAME="${CLUSTER_NAME:-}"
REGION="${REGION:-europe-west1}"
BUCKET_NAME="${BUCKET_NAME:-gs://co-purchase-stefano1}"
#https://spark.apache.org/docs/latest/configuration.html#memory-management
SPARK_PROPERTIES="spark.executor.memory=6g,spark.driver.memory=4g,spark.executor.cores=4"

gcloud dataproc jobs submit spark --cluster=${CLUSTER_NAME} --region=${REGION} --properties=${SPARK_PROPERTIES} --jar=${BUCKET_NAME}/CoPurchaseAnalysis.jar -- ${BUCKET_NAME}/order_products.csv ${BUCKET_NAME}/output ${NUM_WORKERS}