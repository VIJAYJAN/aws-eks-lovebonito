apiVersion: apps/v1
kind: DaemonSet
metadata:
  labels:
    app: LoveBonito-ingress-controller
  name: LoveBonito-ingress-controller
  namespace: dev
spec:
  selector:
    matchLabels:
      app: LoveBonito-ingress-controller
  template:
    metadata:
      labels:
        app: LoveBonito-ingress-controller
    spec:
      serviceAccountName: LoveBonito-ingress-controller
      terminationGracePeriodSeconds: 60
      affinity:
        nodeAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
            nodeSelectorTerms:
            - matchExpressions:
              - key: <env>  
                operator: In
                values:
                - dev
      containers:
      - image: traefik:v2.3
        name: LoveBonito-ingress-controller
        imagePullPolicy: Always
        resources:
          limits:
            cpu: 500m
            memory: 1Gi
          requests:
            cpu: 500m
            memory: 1Gi
        volumeMounts:
          - mountPath: "/config"
            name: LoveBonito-ingress-controller        
        ports:
        - name: http
          containerPort: 80
          hostPort: 80
        - name: traefik
          containerPort: 9080
          hostPort: 9080
        args:
        - --loglevel=DEBUG
        - --configfile=/config/traefik.toml

      dnsPolicy: ClusterFirst
      hostNetwork: true
      volumes:
      - configMap:
          defaultMode: 420
          name: LoveBonito-ingress-controller
        name: LoveBonito-ingress-controller
  updateStrategy:
    rollingUpdate:
      maxUnavailable: 1
    type: RollingUpdate