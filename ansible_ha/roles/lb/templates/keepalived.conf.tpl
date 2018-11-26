global_defs {

  router_id {{ ansible_hostname }}
  vrrp_mcast_group4 {{ keepalived_vrrp_mcast_group4 }}

}

vrrp_instance tu101-lb {

  state {{ keepalived_role }}
  interface {{ keepalived_interface }}
  virtual_router_id {{ keepalived_virtual_router_id }}
  priority {{ keepalived_priority }}
  advert_int 1
  authentication {
    auth_type PASS
    auth_pass {{ keepalived_auth_pass }}
  }
  virtual_ipaddress {
    {{ keepalived_virtual_ipaddress }} dev {{ keepalived_interface }}
  }

}

