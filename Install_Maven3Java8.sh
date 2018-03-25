#!/bin/bash
# Owner: Devesh Kumar Rai
# Email: devesh.rai04@gmail.com
# Date: 25-03-2018
# Version: V1.0 - Maven 3 and Java 8

yum remove java -y
yum install java-1.8.*-openjdk-headless.x86_64 -y
yum install java-1.8.*-openjdk-devel.x86_64 -y
yum install -y wget
yum install -y curl

# Remove current apache & php 
yum remove httpd* php* -y

# Install Apache 2.4
yum install httpd24 -y

# Install PHP 7.0 
# automatically includes php70-cli php70-common php70-json php70-process php70-xml
yum install php70 -y

# Install additional commonly used php packages
yum install php70-gd -y
yum install php70-imap -y
yum install php70-mbstring -y
yum install php70-mysqlnd -y
yum install php70-opcache -y
yum install php70-pdo -y
yum install php70-pecl-apcu -y

# Remove download apache-maven file from directory
rm -f /usr/local/apache-maven-3.5.2-bin.tar.gz

# Creating PHP file for Project - Relay24
cat > /var/www/html/index.php << "EOFF"
<html>
  <body>
    <h1>
    <?php
      // Setup a handle for CURL
      $curl_handle=curl_init();
      curl_setopt($curl_handle,CURLOPT_CONNECTTIMEOUT,2);
      curl_setopt($curl_handle,CURLOPT_RETURNTRANSFER,1);
      // Get the EC2_AVAIL_ZONE of the intance from the instance metadata
      curl_setopt($curl_handle,CURLOPT_URL,'http://169.254.169.254/latest/meta-data/placement/availability-zone');
      $ec2_avail_zone = curl_exec($curl_handle);
      if (empty($ec2_avail_zone))
      {
        print "NOTE: Error - No Avaiable Zone <br />";
      }
      else
      {
        print "EC2_AVAIL_ZONE = " . $ec2_avail_zone . "<br />";
      }
    ?>
    <h1>
  </body>
</html>
EOFF
echo ""
chmod +x /var/www/html/index.php

# Adding in config file to start after server reboot
/sbin/chkconfig --add httpd
/sbin/chkconfig httpd on

# HTTPD Services Start
service httpd start
