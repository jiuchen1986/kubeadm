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
      initial-cluster: "{{ ansible_hostname }}=https://{{ inventory_hostname }}:2380"
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
