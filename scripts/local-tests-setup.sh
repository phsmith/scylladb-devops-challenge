#!/bin/bash

set -eo pipefail

KIND_CLUSTER_NAME=test
KIND_ARGO_NAMESPACE_NAME=argo
KIND_APP_NAMESPACE_NAME=test-app

# Create kind cluster changing the hostPath to the current folder absolute path
echo "> Creating kind cluster..."
if [ "$(kind get clusters | grep -E ^${KIND_CLUSTER_NAME})" ]; then
    echo "Kind cluster already exists."
else
    kind create cluster --name $KIND_CLUSTER_NAME --config <(sed -r 's@(.*hostPath:) (.*)@\1 '"$PWD"'@' kind/cluster-config.yaml)
fi

# Create namespaces for test-app and argo workflows
echo -e "\n> Creating k8s namespaces..."
# Create namespace for test-app and argo workflows, if not already exis
kubectl create namespace $KIND_ARGO_NAMESPACE_NAME
kubectl create namespace $KIND_APP_NAMESPACE_NAME

# Install Argo Workflows
echo -e "\n> Installing Argo Workflows..."
kubectl apply -n $KIND_ARGO_NAMESPACE_NAME -f https://github.com/argoproj/argo-workflows/releases/download/v3.7.0/install.yaml
kubectl wait deployment/workflow-controller -n $KIND_ARGO_NAMESPACE_NAME --for=condition=Available --timeout=120s
