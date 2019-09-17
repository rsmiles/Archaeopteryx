#!/bin/sh

. lib.sh

dependencies(){
	apt-get -y install msmtp clamav
}

install_file(){
	install -o $2 -g $2 -m 644 $1 /home/$2/.Archaeopteryx/
}

install_file_root(){
	install -o root -g root -m 644 $1 /root/.Archaeopteryx/
}

install_system(){
	if [ ! id $1 ]
	then
		adduser $1
	fi
	mkdir /home/$1/.Archaeopteryx
	chown $1 /home/$1/.Archaeopteryx

	mkdir /home/$1/.Trash
	chown $1 /home/$1/.Trash

	install_file lib.sh $1
	install_file config.sh $1
	echo 'TRASH=~/.Trash' >> /home/$1/.Archaeopteryx/config.sh
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
account default : gmail" > $ARCHAEOPTERYX_HOME/.msmtprc
	chown $ARCHAEOPTERYX_USER $ARCHAEOPTERYX_HOME/.msmtprc
	chmod 600 $ARCHAEOPTERYX_HOME/.msmtprc

	echo "export NOTIFY_EMAIL=$email" >> /home/$1/.Archaeopteryx/config.sh

	crontab -u $1 schedule.crt
}

install_root(){
	mkdir /root/.Archaeopteryx
	chown $1 /root/.Archaeopteryx

	mkdir /root/.Trash
	chown $1 /root/.Trash
	install_file_root lib.sh
	install_file_root config.sh
	echo 'TRASH=~/.Trash' >> /root/.Archaeopteryx/config.sh
}

setup_maintenance(){
	crontab -u root schedule_root.crt
}

dependencies
install_system archaeopteryx
setup_notify archaeopteryx
install_root
setup_maintenance

