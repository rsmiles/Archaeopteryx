#!/bin/sh

. ~/.profile

WARNING_MESG='System maintenance will begin in'
LOG_DIR='/var/log/Archaeopteryx/'

wall "$WARNING_MESG 1 hour"

#sleep 30m

wall "$WARNING_MESG 30 minutes"

#sleep 20m

wall "$WARNING_MESG 10 minutes"

#sleep 5m

wall "$WARNING_MESG 5 minutes"

#sleep 4m

wall "$WARNING_MESG 1 minute"

#sleep 1m

wall 'Starting system maintenance. System restart will occur at the end.'

if [ ! -d $LOG_DIR ]
then
	mkdir $LOG_DIR
	chown $LOG_DIR archaeopteryx
	chmod 440 $LOG_DIR
fi

TIME=$(tstmp)
LOG_FILE="$LOG_DIR"/"$TIME".log
touch $LOG_FILE
chown archaeopteryx $LOG_FILE
chmod 440 $LOG_FILE

freshclam >> $LOG_FILE 2>> $LOG_FILE
clamscan -r -i / >> $LOG_FILE 2>> $LOG_FILE

apt-get -qq update >> $LOG_FILE 2>> $LOG_FILE
apt-get -qq upgrade >> $LOG_FILE 2>> $LOG_FILE

shutdown -r +30

