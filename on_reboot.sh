#!/bin/sh

. ~/.Archaeopteryx/lib.sh

TIME=$(tstmp)

while [ true ]
do
	ADDRESSES=$(ips)
	if [ ! -z "$ADDRESSES" ]
	then
		break
	fi
	sleep 60
done

LOG_DIR='/var/log/Archaeopteryx'
LOG_FILE=$(ls $LOG_DIR | sort -r | head -n 1)

if [ -z "$LOG_FILE" ]
then
	LOG_MESG='No maintenance logs available'
else
	LOG_MESG="Last maintenance log:
$(cat $LOG_DIR/$LOG_FILE)"
fi

notify "$(hostname) Reboot" "$(hostname) reboot completed at $TIME.
$ADDRESSES

$LOG_MESG"

