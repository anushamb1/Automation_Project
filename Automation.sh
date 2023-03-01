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
#cron job 
cronfile="automation"
if [ ! -f "$cronfile" ]
then
        echo "0 0 * * * root /root/Automation_Project/automation.sh" >> $cronfile
fi
#script for Task3
cd /tmp
timestamp=$(find . -name '*.tar' -printf "%TY%Tm%Td-%TH%TM%TS" | grep -o '^[^\.]*')
filesize=$((($(stat -c %s *.tar ) + 1023) / 1024 ))K
cd /var/www/html/
File="inventory.html"
if test -f "$File"; then
    echo "<p>httpd-logs<span class="space"></span>$timestamp<span class="space"></span>tar<span class="space"></span>$filesize</p>" >> $File
else
    cat > $File <<EOF
<!DOCTYPE html>
<html>
<head>
<style>
  .space {
    display: inline-block;
    margin-left: 70px;
  }
</style>
</head>
<body>
<p><strong>Log Type<span class="space"></span>Time Created<span class="space"></span>Type<span class="space"></span>Size</strong></p>
<p>httpd-logs<span class="space"></span>$timestamp<span class="space"></span>tar<span class="space"></span>$filesize</p>
</body>
</html>
EOF
fi