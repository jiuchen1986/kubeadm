apiVersion: kubeadm.k8s.io/v1alpha3
caCertPath: /etc/kubernetes/pki/ca.crt
clusterName: kubernetes
discoveryFile: ""
discoveryTimeout: 5m0s
discoveryToken: abcdef.0123456789abcdef
discoveryTokenAPIServers:
- {{ master_ip }}:6443
discoveryTokenUnsafeSkipCAVerification: true
kind: JoinConfiguration
nodeRegistration:
  criSocket: /var/run/dockershim.sock
  name: {{ ansible_hostname }}
tlsBootstrapToken: abcdef.0123456789abcdef
token: abcdef.0123456789abcdef
