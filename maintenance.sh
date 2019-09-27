#!/bin/sh

. ~/.Archaeopteryx/lib.sh

#KEEP_TRASH=100
#WARNING_MESG='System maintenance will begin in'
LOG_DIR='/var/log/Archaeopteryx/'
#KEEP_LOGS=30

#count_files(){
#	ls $1 | wc -l
#}

#wall "$WARNING_MESG 1 hour"

#sleep 30m

#wall "$WARNING_MESG 30 minutes"

#sleep 20m

#wall "$WARNING_MESG 10 minutes"

#sleep 5m

#wall "$WARNING_MESG 5 minutes"

#sleep 4m

#wall "$WARNING_MESG 1 minute"

#sleep 1m

#wall 'Starting system maintenance. System restart will occur at the end.'

# Empty trash if it has more than KEEP_TRASH items in it
#if [ $(count_files $TRASH) -ge $KEEP_TRASH ]
#then
#	rmtrash
#fi

maintenance(){
	#apt-get -qq update
	#apt-get -qq upgrade

	shutdown -r +5
}

if [ ! -d $LOG_DIR ]
then
	mkdir $LOG_DIR
	chown archaeopteryx: $LOG_DIR
	chmod 750 $LOG_DIR
fi

# If our number of log files is over KEEP_LOGS, then trash the oldest one
#if [ $(count_files $LOG_DIR) -gt $KEEP_LOGS ]
#then
#	trash $(ls $LOG_DIR | sort | head -n 1)
#fi

TIME=$(tstmp)
LOG_FILE="$LOG_DIR"/"$TIME".log
touch $LOG_FILE
chown archaeopteryx $LOG_FILE
chmod 750 $LOG_FILE

maintenance >>$LOG_FILE  2>>$LOG_FILE

