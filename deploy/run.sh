#!/bin/bash
#######################################################
# canhweb.com
# curl -Lso- canhweb.com | bash
#######################################################

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
PLAIN='\033[0m'

# check root
[[ $EUID -ne 0 ]] && echo -e "${RED}Error:${PLAIN} This script must be run as root!" && exit 1


sendRequest() {
	curl --header "Content-Type: application/json" \
  --request POST \
  --data '{"email":"xyz","ip":""}' \
  https://canhweb.com/api/login
}

getIP() {
	servers='('`hostname -I`')'
	for server in "${servers[@]}"; do
	echo "$server"
	done
}

canhweb_expoter(){
	mkdir /opt/canhweb && cd /opt/canhweb
	curl https://canhweb.com/xxx --output canhweb_exporter
	chmod +x canhweb_exporter && mv canhweb_exporter /usr/bin/

cat <<EOF> /etc/systemd/system/canhweb_exporter.service
[Unit]
Description=Canhweb exporter service
After=network.target
StartLimitIntervalSec=0

[Service]
Type=simple
Restart=always
RestartSec=1
User=root
ExecStart=/usr/bin/canhweb_exporter

[Install]
WantedBy=multi-user.target
EOF

	systemctl start canhweb_exporter.service 
}

getIP
IFS=' '
ips="$(getIP)"
echo "${ips[1]}";