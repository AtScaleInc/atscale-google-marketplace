#!/bin/bash
set -xeo

IP=$(kubectl get service -n "${NAMESPACE}" kong-proxy | sed -e 3d | awk '{print $4}'| tr -d "\n")

echo "${IP} local.localhost" >> /etc/hosts

for test in /tests/*; do
  testrunner -logtostderr "--test_spec=${test}"
done
