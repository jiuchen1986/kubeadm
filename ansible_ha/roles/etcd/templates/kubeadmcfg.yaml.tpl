apiVersion: "kubeadm.k8s.io/v1alpha3"
kind: ClusterConfiguration
etcd:
  local:
    serverCertSANs:
    - "{{ inventory_hostname }}"
    - "{{ ansible_hostname }}"
    - "127.0.0.1"
    peerCertSANs:
    - "{{ inventory_hostname }}"
    - "{{ ansible_hostname }}"
    - "127.0.0.1"
    extraArgs:
      initial-cluster: {{ hostvars[groups['etcd'][0]]['ansible_hostname'] }}=https://{{ groups['etcd'][0] }}:2380,{{ hostvars[groups['etcd'][1]]['ansible_hostname'] }}=https://{{ groups['etcd'][1] }}:2380,{{ hostvars[groups['etcd'][2]]['ansible_hostname'] }}=https://{{ groups['etcd'][2] }}:2380
      initial-cluster-state: new
      name: {{ ansible_hostname }}
      listen-peer-urls: https://{{ inventory_hostname }}:2380
      listen-client-urls: https://{{ inventory_hostname }}:2379
      advertise-client-urls: https://{{ inventory_hostname }}:2379
      initial-advertise-peer-urls: https://{{ inventory_hostname }}:2380
