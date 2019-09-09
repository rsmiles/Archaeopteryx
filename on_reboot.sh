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
	sleep 60
done

notify "$(hostname) Reboot" "$(hostname) reboot completed at $TIME.
$ADDRESSES"
