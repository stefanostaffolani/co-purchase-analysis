set -e

usage() {
    echo "Usage: $0 --cluster-name CLUSTER_NAME --region REGION "
    echo
    echo "  --cluster-name   nome del cluster"
    echo
    exit 1
}

CLUSTER_NAME="${CLUSTER_NAME:-}"
# REGION="${REGION:-europe-west1}"


while [[ "$#" -gt 0 ]]; do
    case $1 in
        --cluster-name) CLUSTER_NAME="$2"; shift ;;
        --cluster-region) REGION="$2"; shift ;;
        -h|--help) usage ;;
        *) echo "Parametro sconosciuto: $1"; usage ;;
    esac
    shift
done

if [[ -z "$CLUSTER_NAME" ]]; then
    echo "Errore: tutti i parametri sono obbligatori."
    usage
fi

gcloud dataproc clusters delete ${CLUSTER_NAME} --region ${REGION}