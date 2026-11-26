FROM --platform=$BUILDPLATFORM docker.io/library/ubuntu:resolute AS installer

ARG TARGETARCH
ARG BUILDARCH=amd64

RUN apt-get update \
 && apt-get install -y --no-install-recommends ca-certificates \
 && if [ "${TARGETARCH}" != "${BUILDARCH}" ]; then \
      dpkg --add-architecture ${TARGETARCH} \
      && sed -i 's|^deb |deb [arch='"${BUILDARCH}"'] |' /etc/apt/sources.list \
      && printf 'Types: deb\nURIs: http://ports.ubuntu.com/ubuntu-ports/\nSuites: jammy jammy-updates jammy-security\nComponents: main restricted universe multiverse\nArchitectures: %s\nSigned-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg\n' "${TARGETARCH}" \
         > /etc/apt/sources.list.d/ports-${TARGETARCH}.sources; \
    fi \
 && printf 'deb [arch=%s trusted=yes] https://repo.area51-zextras.com/devel/ubuntu jammy main\n' "${TARGETARCH}" \
    > /etc/apt/sources.list.d/zextras.list \
 && apt-get update \
 && mkdir -p /staging /tmp/debs && cd /tmp/debs \
 && apt-get download \
      carbonio-clamav:${TARGETARCH} \
      carbonio-curl:${TARGETARCH} \
      carbonio-krb5:${TARGETARCH} \
      carbonio-openssl:${TARGETARCH} \
      carbonio-libxml2:${TARGETARCH} \
      carbonio-icu:${TARGETARCH} \
      libjson-c5:${TARGETARCH} \
      libbrotli1:${TARGETARCH} \
 && for deb in /tmp/debs/*.deb; do dpkg -x "$deb" /staging; done \
 && rm -rf /tmp/debs \
 && mkdir -p /staging/usr/local/lib \
 && find /staging/lib /staging/usr/lib -name '*.so*' -not -path '*/opt/*' \
    -exec cp -P {} /staging/usr/local/lib/ \; 2>/dev/null || true \
 && rm -rf /staging/etc /staging/lib /staging/usr/lib /staging/usr/share \
 && mkdir -p /staging/etc /staging/opt/zextras/conf /staging/opt/zextras/data/clamav/db \
 && cp /etc/passwd /etc/group /staging/etc/ \
 && printf 'zextras:x:999:999:Carbonio:/opt/zextras:/usr/sbin/nologin\n' >> /staging/etc/passwd \
 && printf 'zextras:x:999:\n' >> /staging/etc/group \
 && chown -R 999:999 /staging/opt/zextras/data/clamav \
 && rm -rf /var/lib/apt/lists/*

FROM --platform=$TARGETPLATFORM docker.io/library/ubuntu:resolute

ENV LD_LIBRARY_PATH=/opt/zextras/common/lib:/usr/local/lib

COPY --from=installer /staging/opt /opt
COPY --from=installer /staging/usr/local/lib /usr/local/lib/
COPY --from=installer /staging/etc/passwd /etc/passwd
COPY --from=installer /staging/etc/group /etc/group
COPY --from=installer /etc/ssl/certs /etc/ssl/certs
COPY docker/clamav/clamd.conf docker/clamav/freshclam.conf /opt/zextras/conf/

EXPOSE 3310
USER 999

ENTRYPOINT ["/opt/zextras/common/sbin/clamd", "--config-file=/opt/zextras/conf/clamd.conf"]
