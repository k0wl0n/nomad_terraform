datacenter = "ap-southeast-1a"
name       = "i-0ffa5bc7b27701708"
region     = "ap-southeast-1"
bind_addr  = "0.0.0.0"

advertise {
  http = "172.31.15.194"
  rpc  = "172.31.15.194"
  serf = "172.31.15.194"
}

client {
  enabled = true
}



consul {
  address = "127.0.0.1:8500"
}
