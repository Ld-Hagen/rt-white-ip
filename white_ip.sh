#!/bin/bash
net_addr="100.64.0.0"
net_mask="10"

ip2int ()
{
    local IFS=. ip num e
    ip=($1)
    for e in 3 2 1 0
    do
        (( num += ip[3-e] * 256 ** e ))
    done
    echo $num
}

start_int=`ip2int $net_addr`
(( end_int = start_int + 2 ** ( 32 - net_mask ) ))

#echo IP range is $start_int - $end_int

ip=$(ip -f inet -o addr show pppoe-wan|cut -d\  -f 7 | cut -d/ -f 1)

ip_int=`ip2int $ip`
echo `date` Current IP is $ip "("$ip_int")"

if [[ $ip_int -ge $start_int && $ip_int -le $end_int ]];
then
	echo `date` Grey IP received, restarting wan...
        sleep 30
	ifdown wan
	sleep 30
	ifup wan
fi

