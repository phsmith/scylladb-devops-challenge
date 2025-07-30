#!/bin/bash

set -eo pipefail

KIND_APP_NAMESPACE_NAME=test-app

# Deploy blue app version
echo "> Deploying Blue App..."
kubectl apply -n $KIND_APP_NAMESPACE_NAME -f k8s/

# Run argo workflow
echo -e "\n> Running Argo Workflow..."
argo submit argo/workflow.yaml \
    --log \
    --namespace $KIND_APP_NAMESPACE_NAME \
    --parameter image_tag=0.4-plain-text
