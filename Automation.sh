#!bin/bash
time=$(date '+%Y%m%d-%H%M%S')
myname='anusha'
s3_bucket='upgrad-anusha'
cp /var/log/apache2/*.log /tmp
tarfile=${myname}'-httpd-logs-'${time}
cd /tmp; rm -rf *.tar; tar -zcvf $tarfile.tar *.log
aws s3 \
cp /tmp/${tarfile}.tar \
s3://${s3_bucket}/${tarfile}.tar
