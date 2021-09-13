datacenter = "ap-southeast-1c"
name       = "i-0dd838dbe7f36d083"
region     = "ap-southeast-1"
bind_addr  = "0.0.0.0"

advertise {
  http = "172.31.40.33"
  rpc  = "172.31.40.33"
  serf = "172.31.40.33"
}



server {
  enabled = true
  bootstrap_expect = 3
}

consul {
  address = "127.0.0.1:8500"
}
