# CockroachDB Helm Chart

Improved Helm Charts for CockroachDB &amp; Backup CronJob and more

Forked from [stable/cockroachdb](https://github.com/helm/charts/tree/master/stable/cockroachdb)

## Changes I Made

### 1 add option to enable `hostNetwork`

This can be enabled to support cross-cluster deployment Solution #1 described here [Gotchas & Solutions Running a Distributed System Across Kubernetes Clusters](https://www.cockroachlabs.com/blog/experience-report-running-across-multiple-kubernetes-clusters/)

```yaml
{{- if .Values.HostNetwork.Enabled }}
      hostNetwork: true
      dnsPolicy: ClusterFirstWithHostNet
{{- end }}
```

#### Caveat

One big caveat with the above setup is that it depends on the host’s IP addresses are not changing. This can be done by node selection to fixed ip nodes. e.g. dedicated db nodes with fixed ip assigned:

```yaml
nodeSelector:
  node-role.kubernetes.io/db: ""
tolerations:
- key: node-role.kubernetes.io/db
  effect: NoSchedule
```

### 2 inject Locality information (region + availability zone) from the node labels

### 3 add [Bring-Your-Own-Certs Support](https://github.com/cockroachdb/cockroach/tree/master/cloud/kubernetes/bring-your-own-certs)

### 4 add Ingress for admin UI

### 5 add UI user creation and schema initialization support

```yaml
CreateUIUser:
  Enabled: true

InitSchema:
  Enabled: true
  ConfigMapName: cockroachdb.init.schema # put init.sql into this config map
```

### 6 add multi-network support 

[start-a-multi-node-cluster-across-private-networks](https://www.cockroachlabs.com/docs/stable/start-a-node.html#start-a-multi-node-cluster-across-private-networks)

```yaml
MultiNetwork:
  Enabled: false
  PublicDomain: ""
  LocalityTag: ""
```

### 7 add backup (to S3) cron job support

```yaml
BackUpCronJob:
  Enabled: true
  Schedule: 0 9 * * *
  S3Bucket: yourbucket
  Database: db
```
