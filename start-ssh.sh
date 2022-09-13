#!/bin/bash
echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
echo 'root:blockpi' | chpasswd
service ssh restart
