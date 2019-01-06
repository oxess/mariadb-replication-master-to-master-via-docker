#!/bin/bash

MYHOST=$1
MASTER_HOST=$2
MY_ROOT_PASS=$3

if [ -x $MYHOST ] || [ -x $MASTER_HOST ] || [ -x $MY_ROOT_PASS ] ; then
	echo "Usage: ./setup.sh <my-host> <master-host> <mysql-root-password>"
	echo
	exit
fi

mysql -u root -p$MY_ROOT_PASS -e "GRANT REPLICATION SLAVE ON *.* TO replicant@'%' IDENTIFIED BY '$MY_ROOT_PASS';"

MASTER_FILE=`mysql -h $MASTER_HOST -u root -p$MY_ROOT_PASS -e "show master status\G;" | grep 'File'     | awk '{print $2}'`
MASTER_POSI=`mysql -h $MASTER_HOST -u root -p$MY_ROOT_PASS -e "show master status\G;" | grep 'Position' | awk '{print $2}'`

mysql -u root -p$MY_ROOT_PASS -e "CHANGE MASTER TO master_host=\"$MASTER_HOST\",master_user=\"replicant\",master_password=\"$MY_ROOT_PASS\",master_log_file=\"$MASTER_FILE\",master_log_pos=$MASTER_POSI,master_connect_retry=10;"
# mysql -u root -p$MY_ROOT_PASS  -e "START SLAVE;"

