apiEndpoint:
  advertiseAddress: {{ inventory_hostname }}
  bindPort: {{ kube_apiserver_port }}
apiVersion: kubeadm.k8s.io/v1alpha3
bootstrapTokens:
- groups:
  - system:bootstrappers:kubeadm:default-node-token
  token: {{ kube_kubeadm_bootstrap_token }}
  ttl: 24h0m0s
  usages:
  - signing
  - authentication
kind: InitConfiguration
nodeRegistration:
  criSocket: /var/run/dockershim.sock
  name: {{ ansible_hostname }}
  taints:
  - effect: NoSchedule
    key: node-role.kubernetes.io/master
  kubeletExtraArgs:
    runtime-cgroups: /systemd/system.slice
---
apiVersion: kubeadm.k8s.io/v1alpha3
kind: ClusterConfiguration
kubernetesVersion: stable
auditPolicy:
  logDir: /var/log/kubernetes/audit
  logMaxAge: 2
  path: ""
clusterName: kubernetes
imageRepository: k8s.gcr.io
apiServerCertSANs:
- "{{ kube_controlplane_ip }}"
- "{{ inventory_hostname }}"
- "{{ ansible_hostname }}"
controlPlaneEndpoint: "{{ kube_controlplane_ip }}:{{ kube_controlplane_port }}"
etcd:
  local:
    extraArgs:
      name: "{{ ansible_hostname }}"
      listen-client-urls: "https://127.0.0.1:2379,https://{{ inventory_hostname }}:2379"
      advertise-client-urls: "https://{{ inventory_hostname }}:2379"
      listen-peer-urls: "https://{{ inventory_hostname }}:2380"
      initial-advertise-peer-urls: "https://{{ inventory_hostname }}:2380"
      initial-cluster: "{{ hostvars[groups['master'][0]]['ansible_hostname'] }}=https://{{ groups['master'][0] }}:2380,{{ ansible_hostname }}=https://{{ inventory_hostname }}:2380"
      initial-cluster-state: existing
    serverCertSANs:
      - {{ ansible_hostname }}
      - {{ inventory_hostname }}
    peerCertSANs:
      - {{ ansible_hostname }}
      - {{ inventory_hostname }}
networking:
  podSubnet: "192.168.0.0/16"
  dnsDomain: cluster.local
  serviceSubnet: 10.96.0.0/12
controllerManagerExtraArgs:
  address: 0.0.0.0
  node-cidr-mask-size: "20"
schedulerExtraArgs:
  address: 0.0.0.0
---
apiVersion: kubeproxy.config.k8s.io/v1alpha1
bindAddress: 0.0.0.0
clientConnection:
  acceptContentTypes: ""
  burst: 10
  contentType: application/vnd.kubernetes.protobuf
  kubeconfig: /var/lib/kube-proxy/kubeconfig.conf
  qps: 5
clusterCIDR: "192.168.0.0/16"
configSyncPeriod: 15m0s
conntrack:
  max: null
  maxPerCore: 32768
  min: 131072
  tcpCloseWaitTimeout: 1h0m0s
  tcpEstablishedTimeout: 24h0m0s
enableProfiling: false
healthzBindAddress: 0.0.0.0:10256
hostnameOverride: ""
iptables:
  masqueradeAll: false
  masqueradeBit: 14
  minSyncPeriod: 0s
  syncPeriod: 30s
ipvs:
  excludeCIDRs: null
  minSyncPeriod: 0s
  scheduler: ""
  syncPeriod: 30s
kind: KubeProxyConfiguration
metricsBindAddress: 0.0.0.0:10249
mode: ""
nodePortAddresses: null
oomScoreAdj: -999
portRange: ""
resourceContainer: /kube-proxy
udpIdleTimeout: 250ms
---
address: 0.0.0.0
apiVersion: kubelet.config.k8s.io/v1beta1
authentication:
  anonymous:
    enabled: false
  webhook:
    cacheTTL: 2m0s
    enabled: true
  x509:
    clientCAFile: /etc/kubernetes/pki/ca.crt
authorization:
  mode: Webhook
  webhook:
    cacheAuthorizedTTL: 5m0s
    cacheUnauthorizedTTL: 30s
cgroupDriver: systemd
cgroupsPerQOS: true
clusterDNS:
- 10.96.0.10
clusterDomain: cluster.local
configMapAndSecretChangeDetectionStrategy: Watch
containerLogMaxFiles: 5
containerLogMaxSize: 10Mi
contentType: application/vnd.kubernetes.protobuf
cpuCFSQuota: true
cpuCFSQuotaPeriod: 100ms
cpuManagerPolicy: none
cpuManagerReconcilePeriod: 10s
enableControllerAttachDetach: true
enableDebuggingHandlers: true
enforceNodeAllocatable:
- pods
eventBurst: 10
eventRecordQPS: 5
evictionHard:
  imagefs.available: 15%
  memory.available: 100Mi
  nodefs.available: 10%
  nodefs.inodesFree: 5%
evictionPressureTransitionPeriod: 5m0s
failSwapOn: true
fileCheckFrequency: 20s
hairpinMode: promiscuous-bridge
healthzBindAddress: 127.0.0.1
healthzPort: 10248
httpCheckFrequency: 20s
imageGCHighThresholdPercent: 85
imageGCLowThresholdPercent: 80
imageMinimumGCAge: 2m0s
iptablesDropBit: 15
iptablesMasqueradeBit: 14
kind: KubeletConfiguration
kubeAPIBurst: 10
kubeAPIQPS: 5
makeIPTablesUtilChains: true
maxOpenFiles: 1000000
maxPods: 110
nodeLeaseDurationSeconds: 40
nodeStatusUpdateFrequency: 10s
oomScoreAdj: -999
podPidsLimit: -1
port: 10250
readOnlyPort: 10255
registryBurst: 10
registryPullQPS: 5
resolvConf: /etc/resolv.conf
rotateCertificates: true
runtimeRequestTimeout: 2m0s
serializeImagePulls: true
staticPodPath: /etc/kubernetes/manifests
streamingConnectionIdleTimeout: 4h0m0s
syncFrequency: 1m0s
volumeStatsAggPeriod: 1m0s
kubeletCgroups: /systemd/system.slice