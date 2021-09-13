# rt-white-ip
Небольшой скрипт для переподключения при получении серого IP у Ростелекома.

##Использование (на OpenWRT)

1. Скопируйте файлы 10-white_ip и white_ip.sh в директорию /opt на роутере
2. Сделайте их исполняемыми
	```chmod +x /opt/10-white_ip /opt/white_ip.sh```
3. Создайте ссылку на 10-white_ip в /etc/hotplug.d/iface/
	```ln -s /opt/10-white_ip /etc/hotplug.d/iface/```
