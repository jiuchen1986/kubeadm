global
  daemon
  maxconn {{ haproxy_maxconn }}
  log  127.0.0.1  local6

defaults
  mode tcp
  timeout connect {{ haproxy_timeout_connect }}
  timeout client {{ haproxy_timeout_client }}
  timeout server {{ haproxy_timeout_server }}
  timeout check {{ haproxy_timeout_check }}
  option tcplog
  log global
  retries {{ haproxy_retries }}

frontend controlplane-endpoint
  bind *:{{ kube_controlplane_port }}
  default_backend apiservers
  log global

backend apiservers
  balance roundrobin
{% for host in groups['master'] %}
  server {{ hostvars[host]['ansible_hostname'] }} {{ host }}:{{ kube_apiserver_port }} check inter {{ haproxy_inter }}
{% endfor %}
