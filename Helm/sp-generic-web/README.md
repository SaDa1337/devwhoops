# Generic Helm template for some SP apps

## Pros

* generic
* expandable
* teams can focus on images being built properly instead of deployment related technical details and terms.
* 1 service per template approach (possible multiple pods and containers) - smaller portion, better understanding of architecture.
* no need to fork per team/deploy/case/client - one generic template should work with majority of deployments

## Cons

* with every change in template services based on older template version can have different behaviour (breaking changes in defaults or scheme)
* have to be adjusted to all possible Kubernetes/Operator version (templating) to expect unexpected

## Values

|Name|Description|Values|
|----|-----------|------|
|labels.app|Application name|string, default: unknown|
|labels.team|Team Name|string, default: unknown|
|labels.release|Release Name|string, default: unknown|
|labels.os|OS  Name|Values: linux,windows, default: linux|
|replicaCount|How many replicas you'll need|integer, default: 1|
|containers.ports.containerPort|Port of container to use|integer 1-65535, default: 80|
|image.repository|repository path/image name (in case of public repo)|string, default: none|
|image.tage|tag of image, preferably some substring of comit hash/number|string, default: latest|
|image.pullPolicy|Policy of pulling images|string, default: IfNotPresent|
|image.secretName|Name of secret on ckuster needed to access repository|string, default: none|
|resources.limits.cpu|||
|resources.limits.memory|||
|resources.requests.cpu|||
|resources.requests.memory|||
|ingress.enabled| Should we enable ingress| true|false, default |

### Labels example

```yaml
labels:
  app: unknown
  team: unknown
  release: alpha
  os: linux
```

### replicaCount example

```yaml
replicaCount: 1
```

### containers.ports.containerPort example

```yaml
containers:
  ports:
    containerPort: 80
```

### image example

```yaml
image:
  repository: proget.spcph.local/docker/library/orderservice
  tag: latest
  pullPolicy: IfNotPresent
  secretName: progetx
```

### resources example

```yaml
resources: {}
   limits:
     cpu: 100mm
     memory: 1Gi
   requests:
     cpu: 100mm
     memory: 1Gi
```

### env examples

```yaml
env:
- name: variable_name
  value: "value for variable_name"
```

nameOverride: ""
fullnameOverride: ""

env:
  aspnetcore_environment: "Development"

service:
  type: ClusterIP
  port: 80
  targetport: 80
  sessionAffinity: ClientIP

livenessProbe:
  httpGet:
    port: 80
    path: /
    scheme: HTTP
  initialDelaySeconds: 30
  periodSeconds: 10
  timeoutSeconds: 5
  failureThreshold: 3

readinessProbe:
  httpGet:
    port: 80
    path: /
    scheme: HTTP
  failureThreshold: 6
  initialDelaySeconds: 20
  timeoutSeconds: 3
  periodSeconds: 5

nodeSelector: {}

tolerations: []

affinity: {}

## ToDo

* ingress (80 without secrets and 443 with already predefined secrets)
* service monitoring
* pdb resource for better disruption handling
* generic _helpers.tpl