#!/bin/sh

. ~/.Archaeopteryx/lib.sh

KEEP_TRASH=100
WARNING_MESG='System maintenance will begin in'
LOG_DIR='/var/log/Archaeopteryx/'
KEEP_LOGS=30

count_files(){
	ls $1 | wc -l
}

maintenance(){
	echo ==== trash ====
	cleanup --remove $TRASH $KEEP_TRASH
	echo ==== apt-get update ====
	apt-get -qq update
	echo ==== apt-get upgrade ====
	apt-get -qq upgrade
	echo ==== Finished ====
	echo "Maintenance finished at $(tstmp)"
}



if [ ! -d $LOG_DIR ]
then
	mkdir $LOG_DIR
	chown archaeopteryx: $LOG_DIR
	chmod 750 $LOG_DIR
fi

# If our number of log files is over KEEP_LOGS, then trash the oldest one
if [ $(count_files $LOG_DIR) -gt $KEEP_LOGS ]
then
	trash $(ls $LOG_DIR | sort | head -n 1)
fi

TIME=$(tstmp)
LOG_FILE="$LOG_DIR"/"$TIME".log
touch $LOG_FILE
chown archaeopteryx $LOG_FILE
chmod 750 $LOG_FILE

maintenance >>$LOG_FILE  2>>$LOG_FILE

