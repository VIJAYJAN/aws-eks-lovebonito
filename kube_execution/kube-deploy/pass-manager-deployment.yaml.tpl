apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    name: lovebonito-pass-manager
  name: lovebonito-pass-manager
spec:
  progressDeadlineSeconds: 600
  replicas: 1
  revisionHistoryLimit: 10
  selector:
    matchLabels:
      name: lovebonito-pass-manager
  strategy:
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 0
    type: RollingUpdate
  template:
    metadata:
      labels:
        name: lovebonito-pass-manager
    spec:
      affinity:
        nodeAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
            nodeSelectorTerms:
            - matchExpressions:
              - key: env
                operator: In
                values:
                - dev
      containers:
      - image: lovebonito/pass-manager:latest
        imagePullPolicy: Never
        livenessProbe:
          failureThreshold: 3
          httpGet:
            path: /_ping
            port: 7777
            scheme: HTTP
          initialDelaySeconds: 300
          periodSeconds: 2
          successThreshold: 1
          timeoutSeconds: 2
        name: lovebonito-pass-manager
        ports:
        - containerPort: 80
          name: lovebonito-pass-manager
          protocol: TCP
        readinessProbe:
          failureThreshold: 3
          httpGet:
            path: /_ping
            port: 7777
            scheme: HTTP
          initialDelaySeconds: 20
          periodSeconds: 2
          successThreshold: 2
          timeoutSeconds: 2
        resources: {}
        securityContext:
          allowPrivilegeEscalation: false
          capabilities: {}
          privileged: false
          readOnlyRootFilesystem: false
          runAsNonRoot: false
        stdin: true
        terminationMessagePath: /dev/termination-log
        terminationMessagePolicy: File
        tty: true
      dnsPolicy: ClusterFirst
      imagePullSecrets:
      - name: nexus
      restartPolicy: Always
      schedulerName: default-scheduler
      securityContext: {}
      terminationGracePeriodSeconds: 120
status: {}
---  
apiVersion: v1
kind: Service
metadata:
  labels:
    name: lovebonito-pass-manager
  name: lovebonito-pass-manager
  
spec:
  ports:
  - name: service-port
    port: 80
    protocol: TCP
    targetPort: 80
  selector:
    name: lovebonito-pass-manager
  sessionAffinity: None
  type: ClusterIP
status:
  loadBalancer: {}
