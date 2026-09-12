# Phase 1 : Builder
FROM quay.io/keycloak/keycloak:26.0 AS builder

ENV KC_HEALTH_ENABLED=true
ENV KC_METRICS_ENABLED=true
ENV KC_DB=postgres
ENV KC_TRANSACTION_XA_ENABLED=false

WORKDIR /opt/keycloak
RUN /opt/keycloak/bin/kc.sh build

# Phase 2 : Runner
FROM quay.io/keycloak/keycloak:26.0
COPY --from=builder /opt/keycloak/ /opt/keycloak/
COPY glmproject-realm.json /opt/keycloak/data/import/

ENTRYPOINT ["/opt/keycloak/bin/kc.sh"]
CMD ["start", "--optimized", "--import-realm", "--http-enabled=true", "--http-port=8080"]
