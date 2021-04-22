apiVersion: traefik.containo.us/v1alpha1
kind: TraefikService
metadata:
  name: lovebonito-pass-manager-traefik-svc
spec:
  weighted:
    services:
      - name: lovebonito-pass-manager-list #In case of blue-green deployment required in lovebonito organisation, then we can point blue kubernetes service name here
        port: 80
        weight: 1
      - name: lovebonito-pass-manager-list #In case of blue-green deployment required in lovebonito organisation, then we can point green kubernetes service name here
        port: 80
        weight: 1
