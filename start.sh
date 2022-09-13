apk add --update --no-cache openssh 
echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config
adduser -h /home/blockpi -s /bin/sh -D blockpi
echo -n 'blockpi:blockpi' | chpasswd
ssh-keygen -A
exec /usr/sbin/sshd -D -e "$@"
