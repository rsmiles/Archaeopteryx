#!/bin/sh

. ~/.profile

TIME=$(tstmp)

while [ true ]
do
	ADDRESSES=$(ips)
	if [ ! -z "$ADDRESSES" ]
	then
		break
	fi
	sleep 30
done

notify 'System Reboot' "Reboot completed at $TIME.
$ADDRESSES"
