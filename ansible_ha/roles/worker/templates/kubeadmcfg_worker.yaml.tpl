apiVersion: kubeadm.k8s.io/v1alpha3
kind: JoinConfiguration
caCertPath: /etc/kubernetes/pki/ca.crt
clusterName: kubernetes
discoveryFile: ""
discoveryTimeout: 5m0s
discoveryTokenAPIServers:
- {{ kube_controlplane_ip }}:{{ kube_controlplane_port }}
discoveryTokenUnsafeSkipCAVerification: true
nodeRegistration:
  criSocket: /var/run/dockershim.sock
  name: {{ ansible_hostname }}
  kubeletExtraArgs:
    runtime-cgroups: /systemd/system.slice
token: {{ kube_kubeadm_bootstrap_token }}