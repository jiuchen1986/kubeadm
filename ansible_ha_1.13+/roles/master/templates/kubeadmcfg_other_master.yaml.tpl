apiVersion: kubeadm.k8s.io/v1beta1
kind: JoinConfiguration
caCertPath: /etc/kubernetes/pki/ca.crt
discovery:
  bootstrapToken:
    apiServerEndpoint: {{ kube_controlplane_ip }}:{{ kube_controlplane_port }}
    token: {{ kube_kubeadm_bootstrap_token }}
    unsafeSkipCAVerification: true
  timeout: 5m0s
  tlsBootstrapToken: {{ kube_kubeadm_bootstrap_token }}
controlPlane:
  localAPIEndpoint:
    advertiseAddress: {{ inventory_hostname }}
    bindPort: {{ kube_apiserver_port }}
nodeRegistration:
  criSocket: /var/run/dockershim.sock
  name: {{ ansible_hostname }}
  kubeletExtraArgs:
    runtime-cgroups: /systemd/system.slice