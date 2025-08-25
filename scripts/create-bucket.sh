set -e

# Variables
PROJECT_ID="${PROJECT_ID:-}"
BUCKET_NAME="${BUCKET_NAME:-}"
# LOCATION="${LOCATION:-europe-west1}"

# Set project
gcloud config set project $PROJECT_ID

# Create bucket
gcloud storage buckets create $BUCKET_NAME \
  --project=$PROJECT_ID \
  --location=$REGION \

echo "Bucket $BUCKET_NAME created in $REGION."
