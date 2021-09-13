datacenter = "ap-southeast-1a"
name       = "i-01a0a57b0dd375305"
region     = "ap-southeast-1"
bind_addr  = "0.0.0.0"

advertise {
  http = "172.31.9.36"
  rpc  = "172.31.9.36"
  serf = "172.31.9.36"
}



server {
  enabled = true
  bootstrap_expect = 3
}

consul {
  address = "127.0.0.1:8500"
}
