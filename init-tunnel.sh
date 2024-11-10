# ZONE MIGHT CHANGE!!!!
export PROJECT=big-data-2024-09-fk
export HOSTNAME=pbd-cluster-m
export ZONE=europe-central2-b

PORT1=8080
PORT2=8080

gcloud compute ssh ${HOSTNAME} \
    --project=${PROJECT} --zone=${ZONE}  -- \
    -4 -N -L ${PORT1}:${HOSTNAME}:${PORT2}

