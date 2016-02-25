#!/bin/bash
#pending | failed | available | deleting | deleted 
export AWS_CONFIG_FILE=/etc/zabbix/.aws/config
AWS_CLI=/usr/local/bin/aws
NAT_INSTANCE_ID=$1
DEBUG_LOG=/var/log/zabbix-external-debug.log
#DEBUG=true
DEBUG=false
function get_nat_instance_status {
	NAT_INSTANCE_ID=$1
	$AWS_CLI --profile zabbix_check_nat ec2 describe-nat-gateways --nat-gateway-ids $NAT_INSTANCE_ID |awk 'BEGIN { FS = "\"" }; /State/ {print $4}'
}
NAT_GATEWAY_STATUS=$(get_nat_instance_status $NAT_INSTANCE_ID 2>/dev/null)
case $NAT_GATEWAY_STATUS in
	available)
		echo "0"
		;;
	pending)
		echo "1"
		;;
	failed)
		echo "2"
		;;
	deleting)
		echo "3"
		;;
	deleted)
		echo "4"
		;;
	*)
		echo "177"
		;;
esac

if [ $DEBUG == true ]; then 
	date >> $DEBUG_LOG
	id >> $DEBUG_LOG
	set >> $DEBUG_LOG
	echo "NAT INSTANCE ID IS [$NAT_INSTANCE_ID] and $NAT_GATEWAY_STATUS" >> $DEBUG_LOG
	echo >> $DEBUG_LOG
fi 

