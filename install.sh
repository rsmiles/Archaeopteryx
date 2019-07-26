#!/bin/sh

dir='/etc/profile.d/'

echo 'Ensuring installation directories exist...'

if [ ! -d $dir ]
then
	mkdir $dir
fi

echo 'Installing archaeolib...'
install -o 'root' -g 'root' -m 755 -t $dir

echo 'Archaeopteryx installation complete'

