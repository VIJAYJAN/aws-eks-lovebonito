apiVersion: v1
kind: ConfigMap
metadata:
  name: LoveBonito-ingress-controller
  namespace: dev
data:
  traefik.toml: |
    debug = true	
    logLevel = "DEBUG"
    [accessLog]
    [api]
      insecure=true
      dashboard=true      
    [entryPoints]
      [entryPoints.http]
        address = ":80"
      [entryPoints.traefik]
        address = ":9080"      
    [providers]
      [providers.kubernetesCRD] 
        namespaces = dev