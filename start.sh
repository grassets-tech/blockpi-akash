#!/bin/bash

# my_name=davaymne
# my_beacon=1.1.1.1
# my_erc_20=0x000
# my_hypernode_password=test1
# my_root_password=test1

echo ${my_root_password}
echo ${my_name}
echo ${my_beacon}
echo ${my_hypernode_password}
echo ${my_root_password}

# (echo ${my_root_password}; echo ${my_root_password}) | passwd root
# service ssh restart

mkdir ~/HyperNode
cd ~/HyperNode
version=`wget -qO- -t1 -T2 "https://api.github.com/repos/BlockPILabs/testnets/releases/latest" | grep "tag_name" | head -n 1 | awk -F ":" '{print $2}' | sed 's/\"//g;s/,//g;s/ //g'`
wget https://github.com/BlockPILabs/testnets/releases/download/${version}/HyperNode
wget https://github.com/BlockPILabs/testnets/releases/download/${version}/config.yml
chmod +x ./HyperNode
mv ./HyperNode /usr/local/bin/

(echo ${my_hypernode_password}; echo ${my_hypernode_password}) | HyperNode init
echo ${hypernode_password} > ~/HyperNode/passwd.txt

key_file=$(ls ~/HyperNode/keystore/ -t -U | grep -m 1 "UTC")

echo ${key_file}

sed -i 's/erc20 address/${my_erc_20}/' ~/HyperNode/config.yml
sed -i 's/{beacon}/${my_beacon}/' ~/HyperNode/config.yml
sed -i 's/unknown/${my_name}/' ~/HyperNode/config.yml

echo "[Unit]
Description=Hyper Node
After=network.target

[Service]
User=$USER
Type=simple
WorkingDirectory=/root/HyperNode
ExecStart=/usr/local/bin/HyperNode --datadir /root/HyperNode --keystore_path keystore/${key_file} --password_path passwd.txt
Restart=on-failure
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target" > $HOME/hypernode.service

sudo mv $HOME/hypernode.service /etc/systemd/system

sudo tee <<EOF >/dev/null /etc/systemd/journald.conf
Storage=persistent
EOF

sudo systemctl restart systemd-journald
sudo systemctl daemon-reload

#sudo systemctl enable umeed
#sudo systemctl restart umeed
