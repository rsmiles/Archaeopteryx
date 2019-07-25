# A library of useful shell functions for inclusion in .bashrc files

export TRASH="/home/$(whoami)/Trash"

if [ ! -d $TRASH ]
then
	mkdir $TRASH
fi

timestamp(){
	stamp=$(date +'%Y-%m-%d-%H-%M-%S-%N')
	if [ $# -eq 0 ]
	then
		echo $stamp
	else
		for arg in $@
		do
			echo "$arg"-"$stamp"
		done
	fi
}

trash(){
	if [ -z "$TRASH" ]
	then
		echo "$0"': Error: TRASH environment variable not set' >&2
		exit 1
	fi

	if [ $# -eq 0 ]
	then
		echo "$0"': Missing target files' >&2
	fi

	for file in "$@"
	do
		if [ -e "$TRASH"/"$file" ]
		then
			mv $file "$TRASH"/"$(timestamp $file)"
		else
			mv $file $TRASH/
		fi
	done
}

emptytrash(){
	if [ -z $TRASH ]
	then
	    echo "$0"': Error: TRASH environment variable not set' >&2
	    exit 1
	fi

	rm $TRASH/*
}

simpleformat(){
	dev=$1
	name=$2
	parted $dev mklabel msdos
	parted -a opt $dev mkpart primary fat32 0% 100%

	mkfs.fat -L $name -F 32 $dev
}
