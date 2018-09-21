#!/usr/bin/bash

host=
region=
topic=

#set hostname if host var is set
if [ ! -z "$host" ]; then
  hostnamectl set-hostname $host
fi

# install aws cli if region exists
if [ ! -z "$region" ]; then
  curl -O https://bootstrap.pypa.io/get-pip.py
  python get-pip.py 
  pip install awscli 
  aws sns publish --topic-arn $topic --region $region  --message "$HOSTNAME is up"
fi

#yum update
yum update -y

#install splunk
#default admin password is "helloWorld" remember to change it.
hash='$6$8Col5Rup5yZngDMQ$NkanFwDqNPUkUiqLUGR17DekyTkBsJQEBPfva6oXv61v6gEUz2azZIP0fOV0.HVYXiz6ZKvx9s3o8feqbUGZi.'
splunk_url='https://www.splunk.com/bin/splunk/DownloadActivityServlet?architecture=x86_64&platform=linux&version=7.1.3&product=splunk&filename=splunk-7.1.3-51d9cac7b837-linux-2.6-x86_64.rpm&wget=true'
splunk_rpm=`echo $splunk_url | awk -F'[=&]' '{print $10}'`
SPLUNK_HOME=/opt/splunk
cd
yum install wget -y
wget -O $splunk_rpm $splunk_url
rpm -ivh $splunk_rpm

cat > $SPLUNK_HOME/etc/system/local/user-seed.conf << EOF 
[user_info]
USERNAME = admin
HASHED_PASSWORD = $hash
EOF
$SPLUNK_HOME/bin/splunk start --answer-yes --no-prompt --accept-license
$SPLUNK_HOME/bin/splunk enable boot-start 

