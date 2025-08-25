set -e

# Variables
JAR="${JAR:-../target/scala-2.12/classes/CoPurchaseAnalysis.jar}"
DATASET="${DATASET:-../src/dataset/order_products.csv}"
BUCKET_NAME="${BUCKET_NAME:-co-purchase-stefano1}"

gsutil cp $JAR $DATASET $BUCKET_NAME