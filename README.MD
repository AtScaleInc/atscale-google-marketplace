### *How to run atscale from google marketplace*

---
## Prerequisites
You'll need the following tools in your development environment. If you are
using Cloud Shell, `gcloud`, `kubectl`, Docker, and Git are installed in your
environment by default.

- [gcloud](https://cloud.google.com/sdk/gcloud/)
- [kubectl](https://kubernetes.io/docs/reference/kubectl/overview/)
- [docker](https://docs.docker.com/install/)
- [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
- [helm](https://helm.sh/)


You will also need the following resources.
- Domain name and access to DNS
- TLS Certificate
- TLS Key

## Installation
---
After selecting our chart from google marketplace and clicking on the deploy button.
You should be greeted with 2 options: <br> <br>
- [CLICK TO DEPLOY ON GKE](/docs/google-marketplace/click-to-deploy-on-gke)
- [DEPLOY VIA COMMAND LINE](#deploy-via-command-line)
### Deploy via command line

You can use [Google Cloud Shell](https://cloud.google.com/shell/) or a local
workstation to complete the following steps.

[![Open in Cloud Shell](http://gstatic.com/cloudssh/images/open-btn.svg)](https://console.cloud.google.com/cloudshell/editor?cloudshell_git_repo=https://github.com/AtScaleInc/atscale-googlemarketplace-stack&cloudshell_working_dir=/)

- Configure `gcloud` as a Docker credential helper:
```shell
gcloud auth configure-docker
```
#### Create a Google Kubernetes Engine cluster

- Create a new cluster from the command line:
```shell
gcloud container clusters create cluster-1 --location=us-central1 --num-nodes=4
```

- Configure `kubectl` to connect to the new cluster.
```shell
gcloud auth login
gcloud container clusters get-credentials cluster-1 --region us-central1
```

- Clone the Atscale Google Marketplace Repo
```shell
git clone https://github.com/AtScaleInc/atscale-googlemarketplace-stack
```

### Installation
- Install Google's kubernetes application crd
```shell
kubectl apply -f "https://raw.githubusercontent.com/GoogleCloudPlatform/marketplace-k8s-app-tools/master/crd/app-crd.yaml"
```
You need to run this command once.

The Application resource is defined by the
[Kubernetes SIG-apps](https://github.com/kubernetes/community/tree/master/sig-apps)
community. The source code can be found on
[github.com/kubernetes-sigs/application](https://github.com/kubernetes-sigs/application).

### Install Atscale
- Set image values
```shell
export REGISTRY="marketplace.gcr.io"
export REPOSITORY="atscale-public/atscale"
export TAG="2024.1.1"
```

- Set your environment details
```shell
export DOMAIN="your.domain.name.com"
export TLSCRT="$(base64 -w 0 -i /tmp/tls.crt)"
export TLSKEY="$(base64 -w 0 -i /tmp/tls.key)"
```

{{< alert context="info" text="Instead of TLSCRT and TLSKEY you can use global.atscale.tls.existingSecret" />}}

- Generate the manifest
```shell
helm template atscale chart/atscale-gcp \
--set global.ingressDomain="${DOMAIN}" \
--set global.atscale.tls.tlsCRT="${TLSCRT}" \
--set global.atscale.tls.tlsKEY="${TLSKEY}" \
--set atscale.atscale-engine.image.repository="${REGISTRY}/${REPOSITORY}/atscale-engine" \
--set atscale.atscale-engine.image.tag="${TAG}" \
--set atscale.atscale-sml.image.repository="${REGISTRY}/${REPOSITORY}/atscale-sml" \
--set atscale.atscale-sml.image.tag="${TAG}" \
--set atscale.atscale-api.image.repository="${REGISTRY}/${REPOSITORY}/atscale-api" \
--set atscale.atscale-api.image.tag="${TAG}" \
--set atscale.atscale-entitlement.image.repository="${REGISTRY}/${REPOSITORY}/atscale-entitlement" \
--set atscale.atscale-entitlement.image.tag="${TAG}" \
--set atscale.kongproxy.image.repository="${REGISTRY}/${REPOSITORY}/kong" \
--set atscale.kongproxy.image.tag="${TAG}" \
--set atscale.kongproxy.ingressController.image.repository="${REGISTRY}/${REPOSITORY}/kong-ingress-controller" \
--set atscale.kongproxy.ingressController.image.tag="${TAG}" \
--set atscale.postgres.postgresql.image.registry="${REGISTRY}" \
--set atscale.postgres.postgresql.image.repository="${REPOSITORY}/postgres" \
--set atscale.postgres.postgresql.image.tag="${TAG}" \
--set atscale.postgres.pgpool.image.registry="${REGISTRY}" \
--set atscale.postgres.pgpool.image.repository="${REPOSITORY}/pgpool" \
--set atscale.postgres.pgpool.image.tag="${TAG}" \
--set atscale.postgres.metrics.image.registry="${REGISTRY}" \
--set atscale.postgres.metrics.image.repository="${REPOSITORY}/postgres-exporter" \
--set atscale.postgres.metrics.image.tag="${TAG}" \
--set atscale.redis.image.registry="${REGISTRY}" \
--set atscale.redis.image.repository="${REPOSITORY}/redis" \
--set atscale.redis.image.tag="${TAG}" \
--set atscale.keycloak.image.registry="${REGISTRY}" \
--set atscale.keycloak.image.repository="${REPOSITORY}/keycloak" \
--set atscale.keycloak.image.tag="${TAG}" \
--set atscale.git.image.registry="${REGISTRY}" \
--set atscale.git.image.repository="${REPOSITORY}/keycloak" \
--set atscale.git.image.tag="${TAG}" \
--set atscale.objectstorage.image.registry="${REGISTRY}" \
--set atscale.objectstorage.image.repository="${REPOSITORY}/objectstorage" \
--set atscale.objectstorage.image.tag="${TAG}" \
--set atscale.objectstorage.clientImage.registry="${REGISTRY}" \
--set atscale.objectstorage.clientImage.repository="${REPOSITORY}/objectstorageclient" \
--set atscale.objectstorage.clientImage.tag="${TAG}" \
--set objectstoragejob.image.registry="${REGISTRY}" \
--set objectstoragejob.image.repository="${REPOSITORY}/objectstoragejob" \
--set objectstoragejob.image.tag="${TAG}" \
--set atscale.grafana.image.registry="${REGISTRY}" \
--set atscale.grafana.image.repository="${REPOSITORY}/grafana" \
--set atscale.grafana.image.tag="${TAG}" \
--set atscale.promtail.image.registry="${REGISTRY}" \
--set atscale.promtail.image.repository="${REPOSITORY}/promtail" \
--set atscale.promtail.image.tag="${TAG}" \
--set atscale.telemetry.image.repository="${REGISTRY}/${REPOSITORY}/telemetry" \
--set atscale.telemetry.image.tag="${TAG}" \
--set atscale.tempo.tempo.image.registry="${REGISTRY}" \
--set atscale.tempo.tempo.image.repository="${REPOSITORY}/tempo" \
--set atscale.tempo.tempo.image.tag="${TAG}" \
--set atscale.tempo.queryFrontend.query.image.registry="${REGISTRY}" \
--set atscale.tempo.queryFrontend.query.image.repository="${REPOSITORY}/tempo-query" \
--set atscale.tempo.queryFrontend.query.image.tag="${TAG}" \
--set atscale.loki.loki.image.registry="${REGISTRY}" \
--set atscale.loki.loki.image.repository="${REPOSITORY}/loki" \
--set atscale.loki.loki.image.tag="${TAG}" \
--set atscale.loki.gateway.image.registry="${REGISTRY}" \
--set atscale.loki.gateway.image.repository="${REPOSITORY}/loki-gateway" \
--set atscale.loki.gateway.image.tag="${TAG}" \
--set atscale.loki.memcachedindexwrites.image.registry="${REGISTRY}" \
--set atscale.loki.memcachedindexwrites.image.repository="${REPOSITORY}/memcached" \
--set atscale.loki.memcachedindexwrites.image.tag="${TAG}" \
--set atscale.mimir.mimir.image.registry="${REGISTRY}" \
--set atscale.mimir.mimir.image.repository="${REPOSITORY}/mimir" \
--set atscale.mimir.mimir.image.tag="${TAG}" \
--set atscale.mimir.gateway.image.registry="${REGISTRY}" \
--set atscale.mimir.gateway.image.repository="${REPOSITORY}/mimir-gateway" \
--set atscale.mimir.gateway.image.tag="${TAG}" \
> atscale_manifest.yaml
```
- Create the namespace
```shell
kubectl create namespace atscale
```
- Apply the manifest to your Kubernetes cluster
```shell
kubectl apply -f "atscale_manifest.yaml" --namespace atscale
```
### Get the service from the cluster
```shell
kubectl get service -n atscale kong-proxy
```
### Generate an DNS A record
In your DNS provider setup an A record with TTL set to 300
The application should be accessible on your domain name after the DNS propagates

---
##### NEED HELP WITH ATSCALE?
For further help with atscale go to [help.atscale.com](https://help.atscale.com)

