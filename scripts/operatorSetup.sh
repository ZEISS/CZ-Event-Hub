#!/bin/bash

# Get the current directory
dir=$(pwd)

# Create kind cluster
kind create cluster --config ./cluster.yaml

helm repo add knative-operator https://knative.github.io/operator
helm install knative-operator --create-namespace --namespace knative-operator knative-operator/knative-operator

# set context to knative-operator
kubectl config set-context --current --namespace=knative-operator

# install knative serving
kubectl apply -f ../operator/serving.yaml

# ingress
kubectl apply -f ../operator/ingress.yaml

# install knative eventing
kubectl apply -f ../operator/eventing.yaml

# instal nats
curl -sL https://raw.githubusercontent.com/knative-extensions/eventing-natss/refs/heads/release-1.18/config/broker/natsjsm.yaml | kubectl apply -f -
curl -sL https://raw.githubusercontent.com/knative-extensions/eventing-natss/refs/heads/release-1.18/config/broker/config-nats.yaml | kubectl apply -f -
curl -sL https://raw.githubusercontent.com/knative-extensions/eventing-natss/refs/heads/release-1.18/config/broker/config-br-default-channel-jsm.yaml | kubectl apply -f -

kubectl apply -f https://github.com/knative-extensions/eventing-natss/releases/download/knative-v1.18.0/eventing-jsm.yaml

# set context to knative-eventing
kubectl config set-context --current --namespace=knative-eventing