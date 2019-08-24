#!/bin/sh

. ~/.profile

while [ true ]
do
	ADDRESSES=$(ips)
	if [ ! -z "$ADDRESSES" ]
	then
		break
	fi
	sleep 60
done

notify 'System Reboot' "Reboot completed at $(tstmp).
$(ADDRESSES)"
