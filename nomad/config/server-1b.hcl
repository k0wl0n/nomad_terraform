datacenter = "ap-southeast-1b"
name       = "i-0fb221624103abca7"
region     = "ap-southeast-1"
bind_addr  = "0.0.0.0"

advertise {
  http = "172.31.25.240"
  rpc  = "172.31.25.240"
  serf = "172.31.25.240"
}



server {
  enabled = true
  bootstrap_expect = 3
}

consul {
  address = "127.0.0.1:8500"
}
