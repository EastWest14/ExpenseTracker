set -e
cd /home/ec2-user
. ./db_var.sh
mysql -h $DBHost -P 3306 -u $DBUser -p$DBPasswd -e 'DROP DATABASE IF EXISTS ET_DB'
mysql -h $DBHost -P 3306 -u $DBUser -p$DBPasswd -e 'CREATE DATABASE ET_DB'
mysql -h $DBHost -P 3306 -u $DBUser -p$DBPasswd ET_DB < db_data.sql
set +e