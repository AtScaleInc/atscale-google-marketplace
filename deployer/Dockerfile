FROM gcr.io/cloud-marketplace/google/c2d-debian11 AS build

RUN apt-get update \
    && apt-get install -y --no-install-recommends gettext


COPY chart/atscale-gcp /tmp/chart
RUN cd /tmp && tar -czvf /tmp/atscale-gcp.tar.gz chart

#COPY apptest/deployer/atscale-gcp /tmp/test/chart
#RUN cd /tmp/test \
#    && tar -czvf /tmp/test/atscale-gcp.tar.gz chart/

ARG REGISTRY
ARG TAG
ARG TLSCRT
ARG TLSKEY

COPY schema.yaml /tmp/schema.yaml
RUN cat /tmp/schema.yaml \
    | env -i "REGISTRY=$REGISTRY" "TAG=$TAG" envsubst \
    > /tmp/schema.yaml.new \
    && mv /tmp/schema.yaml.new /tmp/schema.yaml

COPY apptest/deployer/schema.yaml /tmp/apptest/schema.yaml
RUN cat /tmp/apptest/schema.yaml \
    | env -i "REGISTRY=$REGISTRY" "TAG=$TAG" "TLSCRT=$TLSCRT" "TLSKEY=$TLSKEY" envsubst \
    > /tmp/apptest/schema.yaml.new \
    && mv /tmp/apptest/schema.yaml.new /tmp/apptest/schema.yaml

FROM gcr.io/cloud-marketplace-tools/k8s/deployer_helm:0.12.2

RUN rm -rf /opt/kubectl/1.27 && rm -f /opt/kubectl/default
RUN cp /opt/kubectl/1.29/kubectl /usr/bin/kubectl && ln -s /opt/kubectl/1.29/ /opt/kubectl/default
COPY --from=build /tmp/schema.yaml /data/schema.yaml
COPY --from=build /tmp/atscale-gcp.tar.gz /data/chart/
#COPY --from=build /tmp/test/atscale-gcp.tar.gz /data-test/chart/
COPY --from=build /tmp/apptest/schema.yaml /data-test/

ENV WAIT_FOR_READY_TIMEOUT 1300
ENV TESTER_TIMEOUT 300

