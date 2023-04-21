#!/usr/bin/bash

host=
region=
#set hostname if host var is set
if [ ! -z "$host" ]; then
  hostnamectl set-hostname $host
fi

#yum update
yum update -y

#install splunk
#default admin password is "helloWorld" remember to change it.
#hash='$6$8Col5Rup5yZngDMQ$NkanFwDqNPUkUiqLUGR17DekyTkBsJQEBPfva6oXv61v6gEUz2azZIP0fOV0.HVYXiz6ZKvx9s3o8feqbUGZi.'

splunk_url="https://download.splunk.com/products/splunk/releases/9.0.4.1/linux/splunk-9.0.4.1-419ad9369127-linux-2.6-x86_64.rpm"
splunk_rpm=$(echo ${splunk_url} | awk -F'/' '{print $NF}')
SPLUNK_HOME=/opt/splunk
cd /tmp
yum install wget -y
echo splunk_url=${splunk_url}
wget -O ${splunk_rpm} ${splunk_url}
rpm -ivh ${splunk_rpm}

#if splunk-passwd is set use it, else initial password is "changeme"
if [ -z "${splunk_passwd}" ]; then
  splunk_passwd="changeme"
fi
$SPLUNK_HOME/bin/splunk start --answer-yes --no-prompt --accept-license --seed-passwd ${splunk_passwd}
$SPLUNK_HOME/bin/splunk enable boot-start
