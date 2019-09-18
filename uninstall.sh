#!/bin/sh

deluser archaeopteryx
rm -rf /home/archaeopteryx
cat /etc/cron.allow | grep -v 'archaeopteryx' > /etc/cron.allow
rm -rf /root/.Archaeopteryx
rm -rf /root/.Trash

