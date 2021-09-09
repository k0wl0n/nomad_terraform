#!/bin/sh
set -e
sudo amazon-linux-extras install docker -y
sudo service docker start
sudo usermod -a -G docker ec2-user
sudo chkconfig docker on
