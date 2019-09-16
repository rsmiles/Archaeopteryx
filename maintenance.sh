#!/bin/sh

. ~/.profile

WARNING_MESG='System maintenance will begin in'
LOG_DIR='/var/Archaeopteryx/'

wall "$WARNING_MESG 1 hour"

sleep 30m

wall "$WARNING_MESG 30 minutes"

sleep 20m

wall "$WARNING_MESG 10 minutes"

sleep 5m

wall "$WARNING_MESG 5 minutes"

sleep 4m

wall "$WARNING_MESG 1 minute"

sleep 1m

wall 'Starting system maintenance. System restart will occur at the end.'

TIME=$(tstmp)
LOG_FILE="$LOG_DIR"/"$TIME".log

touch $LOG_FILE


