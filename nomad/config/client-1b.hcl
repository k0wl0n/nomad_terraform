datacenter = "ap-southeast-1b"
name       = "i-03d5e52cb1535a002"
region     = "ap-southeast-1"
bind_addr  = "0.0.0.0"

advertise {
  http = "172.31.26.24"
  rpc  = "172.31.26.24"
  serf = "172.31.26.24"
}

client {
  enabled = true
}



consul {
  address = "127.0.0.1:8500"
}
