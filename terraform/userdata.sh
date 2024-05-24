#!/bin/sh

# install required packages
yum install -y git docker
# allow ec2-user to access docker daemon
usermod -a -G docker ec2-user
# start docker and make it start on boot
systemctl enable docker
systemctl start docker
# clone repo into ec2-user's home
su - ec2-user -c "git clone https://github.com/dboesswetter/iiw-cpc-container-lab.git"
