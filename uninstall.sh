#!/bin/sh

deluser archaeopteryx
rm -rf /home/archaeopteryx
grep -v 'archaeopteryx' < /etc/cron.allow > /etc/cron.allow
rm -rf /root/.Archaeopteryx
rm -rf /root/.Trash

