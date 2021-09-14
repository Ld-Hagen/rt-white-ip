#!/bin/bash
#Подсеть и маска
net_addr="100.64.0.0"
net_mask="10"
wan_iface="pppoe-wan"

#Преобразование IP адреса в число
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
(( end_int = start_int + 2 ** ( 32 - net_mask ) - 1 ))

#Получение адреса wan интерфейса, при необходимости замените на свой вариант
ip=$(ip -f inet -o addr show $wan_iface | cut -d\  -f 7 | cut -d/ -f 1)

ip_int=`ip2int $ip`
echo `date` Current IP is $ip "("$ip_int")"

if [[ $ip_int -ge $start_int && $ip_int -le $end_int ]];
then
	#Таймауты между попытками необходимы чтобы не словить кратковременную блокировку от РТ
	echo `date` Grey IP received, restarting wan...
        #30 секунд таймаут перед отключением, после чего гасим wan шинтерфейс
	sleep 30
	ifdown wan
	#Еще 30 секунд таймаут и повторная попытка подключения
	sleep 30
	ifup wan
fi

