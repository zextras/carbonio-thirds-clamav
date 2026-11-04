FROM registry.dev.zextras.com/dev/carbonio-sidecar:main

RUN useradd -r -U carbonio-clamav

COPY clamav/carbonio-clamav.hcl /consul/config/

COPY clamav/service-protocol.json /etc/carbonio/clamav/service-discover/service-protocol.json
COPY clamav/intentions.json /etc/carbonio/clamav/service-discover/intentions.json
COPY clamav/policies.json /etc/carbonio/clamav/service-discover/policies.json

COPY --chmod=755 clamav/carbonio-clamav /usr/local/bin/carbonio-clamav

ENV SERVICE_NAME=carbonio-clamav
ENV SETUP_SCRIPT="carbonio-clamav setup"
ENV TOKEN_FILE=/etc/carbonio/clamav/service-discover/token
