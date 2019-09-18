#!/bin/sh

. ./lib.sh

dependencies(){
	apt-get -y install msmtp
}

install_file(){
	if [ -z "$3" ]
	then
		PERMS=644
	else
		PERMS=$3
	fi

	install -o $2 -g $2 -m $PERMS $1 /home/$2/.Archaeopteryx/
}

install_file_root(){
	if [ -z "$3" ]
	then
		PERMS=644
	else
		PERMS=$3
	fi
	install -o root -g root -m $PERMS $1 /root/.Archaeopteryx/
}

install_system(){
	id $1 >/dev/null 2>/dev/null
	if [ $? -ne 0 ]
	then
		adduser $1
	fi
	usermod -a -G syslog $1
	mkdir /home/$1/.Archaeopteryx
	chown $1 /home/$1/.Archaeopteryx

	mkdir /home/$1/.Trash
	chown $1 /home/$1/.Trash

	install_file lib.sh $1
	install_file config.sh $1
	echo 'export TRASH=~/.Trash' >> /home/$1/.Archaeopteryx/config.sh
	echo $1 >> /etc/cron.allow
}

setup_notify(){
	echo 'Enter email user name:'
	read email
	readpass password 'Enter email password:'
	echo "defaults
tls on
tls_trust_file /etc/ssl/certs/ca-certificates.crt
auth on
logfile ~/.msmtp.log

account gmail
host smtp.gmail.com
port 587
from $email
user $email
password $password
account default : gmail" > /home/$1/.msmtprc
	chown $1 /home/$1/.msmtprc
	chmod 600 /home/$1/.msmtprc

	echo "export NOTIFY_EMAIL=$email" >> /home/$1/.Archaeopteryx/config.sh

	crontab -u $1 schedule.crt
	install_file on_reboot.sh $1 500
}

install_root(){
	mkdir /root/.Archaeopteryx
	chown root /root/.Archaeopteryx

	mkdir /root/.Trash
	chown root /root/.Trash
	install_file_root lib.sh
	install_file_root config.sh
	echo 'export TRASH=~/.Trash' >> /root/.Archaeopteryx/config.sh
}

setup_maintenance(){
	crontab -u root schedule_root.crt
	install_file_root maintenance.sh 500
	chmod u+x /root/.Archaeopteryx/maintenance.sh
}

dependencies
install_system archaeopteryx
setup_notify archaeopteryx
install_root
setup_maintenance
echo 'Installation Complete'
