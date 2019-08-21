#!/bin/sh

. ./archaeolib.sh

ARCHAEOPTERYX_USER='archaeopteryx'
ARCHAEOPTERYX_HOME="/home/$ARCHAEOPTERYX_USER/"

setup_user(){
	echo 'creating archaeopteryx user...'
	adduser archaeopteryx
}

install_archaeolib(){
	echo 'Setting up trash directory...'
	if [ ! -d $ARCHAEOPTERYX_HOME/.Trash ]
	then
		mkdir $ARCHAEOPTERYX_HOME/.Trash
		chown $ARCHAEOPTERYX_USER:$ARCHAEOPTERYX_USER $ARCHAEOPTERYX_HOME/.Trash
	fi
	echo "export TRASH=~/.Trash" >> $ARCHAEOPTERYX_HOME/.profile
	echo 'Trash directory set'

	echo 'Installing archaeolib...'

	install -o $ARCHAEOPTERYX_USER -g $ARCHAEOPTERYX_USER -m 644 archaeolib.sh "$ARCHAEOPTERYX_HOME/.archaeolib.sh"
	echo '. ~/.archaeolib.sh' >> $ARCHAEOPTERYX_HOME/.profile
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
	readpass password 'Enter email password:'

	echo "writing /home/$ARCHAEOPTERYX_USER/.msmtprx"
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

	echo 'Saving notify email variable...'
	echo "export NOTIFY_EMAIL=$email" >> $ARCHAEOPTERYX_HOME/.profile
	echo 'Notify email saved'
}

echo 'Starting Archaeopteryx installation...'
setup_user
install_archaeolib
install_msmtp
echo 'Archaeopteryx installation complete'

