apiVersion: traefik.containo.us/v1alpha1
kind: IngressRoute
metadata:
  name: lovebonito-pass-manager-ingressroute
spec:
  entryPoints:
    - http
  routes:
  - match: PathPrefix(`/`)
    kind: Rule
    services:
    - name: lovebonito-pass-manager-traefik-svc
      kind: TraefikService
