set -e

BUCKET_NAME="${BUCKET_NAME:-co-purchase-stefano1}"

gcloud storage rm --recursive gs://$BUCKET_NAME