#!/bin/sh

. ./archaeolib.sh

ARCHAEOPTERYX_USER='archaeopteryx'
ARCHAEOPTERYX_HOME="/home/$ARCHAEOPTERYX_USER"
ARCHAEOPTERYX_BIN="$ARCHAEOPTERYX_HOME/.Archaeopteryx"

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
	echo "Creating $ARCHAEOPTERYX_BIN..."
	mkdir $ARCHAEOPTERYX_BIN
	chown $ARCHAEOPTERYX_USER:$ARCHAEOPTERYX_USER $ARCHAEOPTERYX_BIN
	echo "$ARCHAEOPTERYX_BIN created"

	echo 'Installing archaeolib...'
	install -o $ARCHAEOPTERYX_USER -g $ARCHAEOPTERYX_USER -m 644 archaeolib.sh $ARCHAEOPTERYX_BIN
	install -o $ARCHAEOPTERYX_USER -g $ARCHAEOPTERYX_USER -m 644 profile $ARCHAEOPTERYX_BIN
	echo 'Archaeolib installed'
	echo "Updating $ARCHAEOPTERYX_USER .profile"
	echo ". $ARCHAEOPTERYX_BIN/profile" >> $ARCHAEOPTERYX_HOME/.profile
	echo 'Done'
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
	echo "export NOTIFY_EMAIL=$email" >> $ARCHAEOPTERYX_BIN/profile
	echo 'Notify email saved'
}

setup_crontab(){
	echo 'Setting up crontab...'
	install -o $ARCHAEOPTERYX_USER -g $ARCHAEOPTERYX_USER -m 500 on_reboot.sh $ARCHAEOPTERYX_BIN
	echo $ARCHAEOPTERYX_USER >> /etc/cron.allow
	crontab -u $ARCHAEOPTERYX_USER schedule.crt
	echo 'Crontab set'
}

setup_root(){
	apt -y install clamav
	cp $ARCHAEOPTERYX_BIN /root
	chown root /root/.Archaeopteryx
	echo ". /root/.Archaeopteryx/profile" >> /root/.profile
	install -o root -g root -m 500 maintenance.sh /root/.Archaeopteryx
	crontab -u root schedule_root.crt
}

echo 'Starting Archaeopteryx installation...'
setup_user
install_archaeolib
install_msmtp
setup_crontab
setup_root
echo 'Archaeopteryx installation complete'

