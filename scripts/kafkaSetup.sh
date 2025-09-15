#!/bin/bash

# Get the current directory
dir=$(pwd)

# Create kind cluster
kind create cluster --config ./cluster.yaml

# install knative serving
kubectl apply -f https://github.com/knative/serving/releases/download/knative-v1.18.0/serving-crds.yaml
kubectl apply -f https://github.com/knative/serving/releases/download/knative-v1.18.0/serving-core.yaml

# install istio
kubectl apply -l knative.dev/crd-install=true -f https://github.com/knative/net-istio/releases/download/knative-v1.19.0/istio.yaml
kubectl apply -f https://github.com/knative/net-istio/releases/download/knative-v1.19.0/istio.yaml
kubectl apply -f https://github.com/knative/net-istio/releases/download/knative-v1.19.0/net-istio.yaml

# conifgure domain
kubectl patch configmap/config-domain \
      --namespace knative-serving \
      --type merge \
      --patch '{"data":{"eventhub.cloud.zeiss.com":""}}'

# install knative eventing
kubectl apply -f https://github.com/knative/eventing/releases/download/knative-v1.18.1/eventing-crds.yaml
kubectl apply -f https://github.com/knative/eventing/releases/download/knative-v1.18.1/eventing-core.yaml

kubectl label namespace knative-serving istio-injection=enabled
kubectl label namespace knative-eventing istio-injection=enabled

# install kafka broker
kubectl apply -f https://github.com/knative-extensions/eventing-kafka-broker/releases/download/knative-v1.18.0/eventing-kafka-controller.yaml
kubectl apply -f https://github.com/knative-extensions/eventing-kafka-broker/releases/download/knative-v1.18.0/eventing-kafka-broker.yaml

# install keycloak
helm install keycloak bitnami/keycloak --create-namespace -n keycloak \
  --set auth.adminUser=admin \
  --set auth.adminPassword=admin123 \
  --set proxyHeaders=xforwarded \
  --set posstgresql.auth.username=sqluser \
  --set postgresql.auth.password=postgres123 \
  --set ingress.hostname=auth.eventhub.cloud.zeiss.com

# install kafka
kubectl create namespace kafka
kubectl create -f 'https://strimzi.io/install/latest?namespace=kafka' -n kafka
kubectl apply -f https://strimzi.io/examples/latest/kafka/kafka-single-node.yaml -n kafka
kubectl wait kafka/my-cluster --for=condition=Ready --timeout=300s -n kafka