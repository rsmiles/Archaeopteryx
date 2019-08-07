#!/bin/sh

archaeolib(){
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

postfix(){
	echo 'Installing postfix...'

	apt-get -y install postfix mailutils libsasl2-2 ca-certificates libsasl2-modules

	echo 'Postfix installed'
	echo 'Configuring postfix...'

	echo 'relayhost = [smtp.gmail.com]:587
smtp_sasl_auth_enable = yes
smtp_sasl_password_maps = hash:/etc/postfix/sasl_passwd
inet_interfaces = smtp_sasl_security_options = noanonymous
inet_protocols = smtp_tls_CAfile = /etc/cacert.pem
smtp_use_tls = yes' > /etc/postfix/main.cf

	echo 'Enter email address: '
	read email

	stty -echo
	while [ true ]
	do
		echo 'enter email password:'
		read password
		echo 're-enter password:'
		read password2
		if [ "$password" == "$password2" ]
		then
			break
		fi
		echo 'Passwords do not match. Try again.'
	done
	stty echo

	echo "[smtp.gmail.com]:587	""$email"":""$PASSWORD" > /etc/postfix/sasl_passwd
	chmod 400 /etc/postfix/sasl_passwd
	postmap /etc/postfix/sasl_passwd

	# Fix this later
	cat /etc/ssl/certs/Thawte_Premium_Server_CA.pem | sudo tee -a /etc/postfix/cacert.pem

	echo 'Postfix configured'
	echo 'Restarting postfix....'
	systemctl restart postfix
	echo 'Postfix restarted'
}


echo 'Starting Archaeopteryx installation...'
archaeolib
postfix
echo 'Archaeopteryx installation complete'

