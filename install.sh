#!/bin/sh

. ./archaeolib.sh

ARCHAEOPTERYX_USER='archaeopteryx'

install_archaeolib(){
	dir='/etc/profile.d/'

	echo 'Installing archaeolib...'
	echo "Ensuring $dir exists..."

	if [ ! -d $dir ]
	then
		echo "Creating $dir..."
		mkdir $dir
	fi

	echo "moving archaeolib to $dir"
	install -o 'root' -g 'root' -m 755 archaeolib.sh  $dir
	echo 'Archaeolib installed'
}

setup_user(){
	adduser --system --group archaeopteryx
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
	readpass password 'Enter email password:'

	echo "defaults
port 587
tls on
tls_trust_file /etc/ssl/certs/ca-certificates.crt
account gmail
host smtp@gmail.com
from $email
auth on
user $ARCHAEOPTERYX_USER
passwordeval gpg --no-tty -q -d /etc/msmtp-gmail.gpg
account default : gmail" > /home/$ARCHAEOPTERYX_USER/msmtprc
	chmod 600 /home/$ARCHAEOPTERYX_USER/msmtprc
}

echo 'Starting Archaeopteryx installation...'
install_archaeolib
setup_user
install_msmtp
echo 'Archaeopteryx installation complete'

