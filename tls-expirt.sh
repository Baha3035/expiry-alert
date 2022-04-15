#!/bin/bash

for namespace in $(kubectl get ns --no-headers | awk '{print $1}'); do
    for secret in $(kubectl get secrets --namespace "$namespace" --field-selector type=kubernetes.io/tls -o name); do
        EXPIRY=$(kubectl get "$secret" --namespace "$namespace" -o "jsonpath={.data['tls\.crt']}" | \
            base64 -d | \
            openssl x509 -enddate -noout)
        echo "Secret $secret expiry is $EXPIRY"
    done
done