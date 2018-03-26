#!/bin/bash

yum install httpd -y
yum install curl -y
yum install php -y
yum install php-mysql -y

cat > /var/www/html/index.php << "EOL"
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
EOL

# File Permision
chmod 644 /var/www/html/index.php

# HTTPD Start
/sbin/service httpd start
/sbin/chkconfig --add httpd
/sbin/chkconfig httpd on
