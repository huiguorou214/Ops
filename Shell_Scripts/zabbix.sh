#!/bin/bash

mkdir -p /opt/tmp && cd /opt/tmp
useradd zabbix
wget https://cdn.zabbix.com/zabbix/sources/stable/5.0/zabbix-5.0.26.tar.gz
tar zxf zabbix-5.0.26.tar.gz
cd zabbix-5.0.26/
./configure --prefix=/usr/local/zabbix --enable-agent
make -j2 && make install
Hostname="`curl -s http://icanhazip.com`"

cat > /usr/local/zabbix/etc/zabbix_agentd.conf << EOF
LogFile=/tmp/zabbix_agentd.log
Server=175.178.246.229
ServerActive=175.178.246.229
HostMetadata=boomgames
Hostname=${Hostname}
RefreshActiveChecks=60
BufferSize=10000
MaxLinesPerSecond=200
Timeout=30
UserParameter=TCPonline,/bin/netstat -tunla | grep ESTABLISHED | awk '{print $4}'| grep -v '127.0.0.1' | wc -l
EOF
/usr/local/zabbix/sbin/zabbix_agentd
echo "/usr/local/zabbix/sbin/zabbix_agentd" >> /etc/rc.d/rc.local
