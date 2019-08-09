#!/bin/sh

. ./archaeolib.sh

install_archaeolib(){
	dir='/etc/profile.d/'

	echo 'Installing archaeolib...'
	echo 'Ensuring installation directories exist...'

	if [ ! -d $dir ]
	then
		mkdir $dir
	fi

	install -o 'root' -g 'root' -m 755 archaeolib.sh  $dir
	echo 'Archaeolib installed'
}

install_msmtp(){

	echo 'checking for msmtp...'
	if [ -z "$(which msmtp)" ]
	then
		echo 'msmtp not found, installing now...'
		sudo apt-get -y install msmtp
	fi

	echo 'Configuring msmtp...'
	echo 'Enter email user name:'
	read email
	readpass password

	echo "defaults
port 587
tls on
tls_trust_file /etc/ssl/certs/ca-certificates.crt
account gmail
host smtp@gmail.com
from $email
auth on
user $email
passwordeval gpg --no-tty -q -d /etc/msmtp-gmail.gpg
account default : gmail" > /etc/msmtprc
chmod 444 /etc/msmtprc

echo $password | gpg --encrypt -o /etc/msmtp-gmail.gpg -r $(whoami) -
chmod 444 /etc/msmtp-gmail.gpg
}

echo 'Starting Archaeopteryx installation...'
install_archaeolib
install_msmtp
echo 'Archaeopteryx installation complete'

