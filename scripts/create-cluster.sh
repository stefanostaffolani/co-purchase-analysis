#!/usr/bin/bash

usage() {
    echo "Usage: $0 --cluster-name NAME --num-workers N --master-boot-disk-size SIZE --worker-boot-disk-size SIZE --machine-type TYPE --image-version VERSION"
    echo
    echo "  --cluster-name            Nome del cluster"
    echo "  --num-workers             Numero di worker nodes"
    echo "  --master-boot-disk-size   Dimensione disco master (default: 240)"
    echo "  --worker-boot-disk-size   Dimensione disco worker (default: 240)"
    echo "  --machine-type            Tipo macchina (default: n1-standard-4)"
    echo "  --image-version         Versione macchina (default: 2.0-debian10)"
    echo
    exit 1
}

CLUSTER_NAME=""
NUM_WORKERS="${NUM_WORKERS:-}"
MASTER_BOOT_DISK_SIZE="240"
WORKER_BOOT_DISK_SIZE="240"
MACHINE_TYPE="n1-standard-4"
IMAGE_VERSION="2.0-debian10"

while [[ "$#" -gt 0 ]]; do
    case $1 in
        --cluster-name) CLUSTER_NAME="$2"; shift ;;
        --num-workers) NUM_WORKERS="$2"; shift ;;
        --master-boot-disk-size) MASTER_BOOT_DISK_SIZE="$2"; shift ;;
        --worker-boot-disk-size) WORKER_BOOT_DISK_SIZE="$2"; shift ;;
        --machine-type) MACHINE_TYPE="$2"; shift ;;
        --image-version) IMAGE_VERSION="$2"; shift ;;
        -h|--help) usage ;;
        *) echo "Parametro sconosciuto: $1"; usage ;;
    esac
    shift
done

if [[ -z "$CLUSTER_NAME" || -z "$NUM_WORKERS" || -z "$MASTER_BOOT_DISK_SIZE" || -z "$WORKER_BOOT_DISK_SIZE" || -z "$MACHINE_TYPE" || -z "$IMAGE_VERSION" ]]; then
    echo "Errore: tutti i parametri sono obbligatori."
    usage
fi

if [ "$NUM_WORKERS" -eq 1 ]; then
    echo "single node"
    gcloud dataproc clusters create ${CLUSTER_NAME} --region ${REGION} --single-node --master-boot-disk-size ${MASTER_BOOT_DISK_SIZE} --worker-boot-disk-size ${WORKER_BOOT_DISK_SIZE} --master-machine-type ${MACHINE_TYPE} --worker-machine-type ${MACHINE_TYPE} --image-version ${IMAGE_VERSION}
else
    gcloud dataproc clusters create ${CLUSTER_NAME} --region ${REGION} --num-workers ${NUM_WORKERS} --master-boot-disk-size ${MASTER_BOOT_DISK_SIZE} --worker-boot-disk-size ${WORKER_BOOT_DISK_SIZE} --master-machine-type ${MACHINE_TYPE} --worker-machine-type ${MACHINE_TYPE} --image-version ${IMAGE_VERSION}
fi
