#!/bin/bash
echo "Setting up DNS"
sudo bash -c 'echo "DNS1=172.31.10.154" >> /etc/sysconfig/network-scripts/ifcfg-eth0'
sudo service network restart
echo "Installing Nomad..."
NOMAD_VERSION=1.0.0
cd /tmp/
curl -sSL https://releases.hashicorp.com/nomad/${NOMAD_VERSION}/nomad_${NOMAD_VERSION}_linux_amd64.zip -o nomad.zip
unzip nomad.zip
sudo install nomad /usr/bin/nomad
sudo mkdir -p /etc/nomad/config
sudo chmod -R a+w /etc/nomad
echo "Installing Consul..."
CONSUL_VERSION=1.9.0
curl -sSL https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_linux_amd64.zip > /tmp/consul.zip
unzip /tmp/consul.zip
sudo install consul /usr/bin/consul
sudo mkdir -p /etc/consul
sudo chmod a+w /etc/consul
sudo mkdir -p /etc/consul/data
sudo chmod a+w /etc/consul/data
sudo mkdir -p /etc/consul/config
sudo chmod a+w /etc/consul/config
HOSTNAME=`hostname`
LOCAL_IP=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
cat > /etc/nomad/config/server.hcl <<EOF
bind_addr = "0.0.0.0"
log_level = "DEBUG"
data_dir = "/etc/nomad"
name = "$HOSTNAME"
server {
  enabled = true
  bootstrap_expect = 2
}
advertise {
  http = "$LOCAL_IP"
  rpc = "$LOCAL_IP"
  serf = "$LOCAL_IP"
}
server_join {
  retry_join = ["provider=aws tag_key=tipeserver tag_value=nomad"]
}
EOF
sudo bash -c 'cat > /etc/systemd/system/nomad.service <<EOF
[Unit]
Description=Nomad
Requires=network-online.target
After=network-online.target

[Service]
Restart=on-failure
ExecStart=/usr/bin/nomad agent -config=/etc/nomad/config
ExecReload=/bin/kill -HUP $MAINPID
KillSignal=SIGTERM
StandardOutput=syslog
StandardError=syslog
SyslogIdentifier=nomad

[Install]
WantedBy=multi-user.target
EOF'
sudo yum -y install amazon-ecr-credential-helper
mkdir -p /home/ec2-user/.docker
cat > /home/ec2-user/.docker/config.json <<EOF
{
  "credsStore": "ecr-login"
}
EOF
sudo chown -R ec2-user:ec2-user /home/ec2-user/.docker
sudo systemctl enable nomad
sudo systemctl start nomad
cat > /etc/consul/config/client.json <<EOF
{
  "server": false,
  "ui": true,
  "data_dir": "/etc/consul/data",
  "client_addr": "0.0.0.0",
  "advertise_addr": "$LOCAL_IP",
  "retry_join": ["provider=aws tag_key=tipeserver tag_value=nomad"]
}
EOF
cat > /etc/consul/config/connect.hcl <<EOF
connect {
  enabled = true
}
ports {
  grpc = 8502
}
EOF
cat > /etc/consul/config/ports.json <<EOF
{
  "ports": {
    "dns": 53
  }
}
EOF
sudo bash -c 'cat > /etc/systemd/system/consul.service <<EOF
[Unit]
Description=Consul
Requires=network-online.target
After=network-online.target

[Service]
Restart=on-failure
ExecStart=/usr/bin/consul agent -config-dir=/etc/consul/config
ExecReload=/bin/kill -HUP $MAINPID
KillSignal=SIGTERM
RestartSec=30
StartLimitBurst=5

[Install]
WantedBy=multi-user.target
EOF'
sudo systemctl enable consul
sudo systemctl start consul
sudo /bin/dd if=/dev/zero of=/var/swap.1 bs=1M count=1024
sudo /sbin/mkswap /var/swap.1
sudo chmod 600 /var/swap.1
sudo /sbin/swapon /var/swap.1
echo '/var/swap.1   swap    swap    defaults        0   0' | sudo tee -a /etc/fstab
sudo bash -c 'cat > /etc/resolv.conf <<EOF
nameserver 172.31.10.154
EOF'