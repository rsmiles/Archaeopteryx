# A library of useful shell functions for placement in /etc/profile.d

export TRASH="/home/$(whoami)/Trash" # trash environment variable

if [ ! -d "/home/$(whoami)" ]
then
	mkdir "/home/$(whoami)" # create home directory if it doesn't exist
fi

if [ ! -d $TRASH ]
then
	mkdir $TRASH # create trash directory if it doesn't exist
fi

# tstmp [str]
# Timestamp. Outputs a timestamp string. If str is specified, append the timestamp to str.
tstmp(){
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

# trash file ...
# move all files into the trash directory. Files with duplicate names have timestamps appended to them.
trash(){
	if [ -z "$TRASH" ]
	then
		echo "trash: Error: TRASH environment variable not set" >&2
		return 1
	fi

	if [ $# -eq 0 ]
	then
		echo "trash: Missing target files" >&2
	fi

	for file in "$@"
	do
		if [ -e "$TRASH"/"$file" ]
		then
			mv $file "$TRASH"/"$(tstmp $file)"
		else
			mv $file $TRASH/
		fi
	done
}

# rmtrash
# rm all files in the trash directory
rmtrash(){
	if [ -z $TRASH ]
	then
	    echo "rmtrash: Error: TRASH environment variable not set" >&2
	    return 1
	fi

	rm $TRASH/*
}

# lspart dev
# lists all partitions on device dev, with no other information.
lspart(){
	if [ $# -eq 0 ]
	then
		echo "lsdev: Missing target device" >&2
	fi
	lsblk -l $1 | tr ' \t' '\t' | cut -f 1 | tail -n +3
}

# sfmt dev name
# Simple device format. Creates a single partition, fat32 filesystem on dev, naming it name.
sdfmt(){
	if [ $# -ne 2 ]
	then
		echo "usage: sfmt device name" >&2
		return 1
	fi

	dev=$1
	name=$2

	echo "WARNING: This will erase all data on $dev. Enter 'yes' to continue, enter any other value to exit"

	read input
	if [ $input != 'yes' ]
	then
		return 1
	fi

	parted $dev mklabel msdos
	parted -a opt $dev mkpart primary fat32 0% 100%

	dir=$(dirname $dev)
	part=$(lspart $dev)

	mkfs.fat -n $name -F 32 "$dir"/"$part"
}

readpass(){
	stty -echo
	while [ true ]
	do
		echo 'Enter password:'
		read __archaeolib_password
		echo 'Re-enter password:'
		read __archaeolib_password2
		if [ $__archaeolib_password = $__archaeolib_password2 ]
		then
			eval "$1=$__archaeolib_password"
			unset __archaeolib_password
			unset __archaeolib_password2
			break
		fi
		echo 'Passwords do not match. Try Again.'
	done
	stty echo
}

