#!/bin/bash

# Get the current directory
dir=$(pwd)

# Create kind cluster
# kind create cluster --config ./cluster.yaml

# install knative serving
kubectl apply -f https://github.com/knative/serving/releases/download/knative-v1.18.0/serving-crds.yaml
kubectl apply -f https://github.com/knative/serving/releases/download/knative-v1.18.0/serving-core.yaml

kubectl apply -f https://github.com/knative/net-kourier/releases/download/knative-v1.18.0/kourier.yaml

kubectl patch configmap/config-network \
  --namespace knative-serving \
  --type merge \
  --patch '{"data":{"ingress-class":"kourier.ingress.networking.knative.dev"}}'

# install knative eventing
kubectl apply -f https://github.com/knative/eventing/releases/download/knative-v1.18.1/eventing-crds.yaml
kubectl apply -f https://github.com/knative/eventing/releases/download/knative-v1.18.1/eventing-core.yaml

# install nats server
curl -sL https://raw.githubusercontent.com/knative-extensions/eventing-natss/refs/heads/release-1.18/config/broker/natsjsm.yaml | kubectl apply -f -
curl -sL https://raw.githubusercontent.com/knative-extensions/eventing-natss/refs/heads/release-1.18/config/broker/config-nats.yaml | kubectl apply -f -
curl -sL https://raw.githubusercontent.com/knative-extensions/eventing-natss/refs/heads/release-1.18/config/broker/config-br-default-channel-jsm.yaml | kubectl apply -f -

kubectl apply -f https://github.com/knative-extensions/eventing-natss/releases/download/knative-v1.18.0/eventing-jsm.yaml

kubectl patch configmap/config-domain \
      --namespace knative-serving \
      --type merge \
      --patch '{"data":{"eventhub.developer.zeiss.com":""}}'

