# Phase 1 : Build et optimisation de Keycloak
FROM quay.io/keycloak/keycloak:26.0 AS builder

ENV KC_HEALTH_ENABLED=true
ENV KC_METRICS_ENABLED=true
ENV KC_DB=postgres

WORKDIR /opt/keycloak
RUN /opt/keycloak/bin/kc.sh build

# Phase 2 : Image finale d'exécution
FROM quay.io/keycloak/keycloak:26.0
COPY --from=builder /opt/keycloak/ /opt/keycloak/

# Forcer l'écoute sur 0.0.0.0 et le port 8080
ENTRYPOINT ["/opt/keycloak/bin/kc.sh"]
CMD ["start", "--optimized", "--http-enabled=true", "--http-port=8080", "--hostname-strict=false"]
