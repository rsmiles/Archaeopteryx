if [ -f ~/.Archaeopteryx/config.sh ]
then
	. ~/.Archaeopteryx/config.sh
fi

# A library of useful shell functions

# assert [mesg]
# Assert that the last command ran successfully. If not, print mesg and exit with status 1.
assert(){
	if [ $? -ne 0 ]
	then
		if [ ! -z "$1" ]
		then
			echo $1 >&2
		fi
		exit 1
	fi
}

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
# rm all files in the trash directory.
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

	echo -n "WARNING: This will erase all data on $dev. Enter 'yes' to continue, enter any other value to exit"

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

# readpass variable [prompt1] [prompt2] [retry_prompt]
# Prompt user for a password and read it into variable.
readpass(){
	if [ -z "$1" ]
	then
		echo 'readpass: usage: readpass variable [prompt1] [prompt2] [retry_prompt]' >&2
		return 1
	fi

	stty -echo
	while [ true ]
	do
		if [ ! -z "$2" ]
		then
			echo -n "$2 "
		else
			echo -n 'Enter password: '
		fi
		read _password
		echo
		
		if [ ! -z "$3" ]
		then
			echo -n "$3 "
		else
			echo -n 'Re-enter password: '

		fi
		read _password2
		echo

		if [ $_password = $_password2 ]
		then
			eval "$1=$_password"
			unset _password
			unset _password2
			break
		fi

		if [ ! -z "$4" ]
		then
			echo $4
		else
			echo -n 'Passwords do not match. Try Again.'
		fi
	done
	stty echo
}

# notify subject message
# Send email to archaeopteryx email account with specified subject and message
notify(){
	if [ -z "$NOTIFY_EMAIL" ]
	then
		echo 'notify not set up for this user' >&2
	fi

	if [ $# -ne 2 ]
	then
		echo 'notify: usage: notify subject message' >&2
	fi

	echo "subject: $1
$2" | msmtp $NOTIFY_EMAIL
}

# ips
# If there is a network connection, print the internal and external ip addresses of this machine and set $? to 0.
# If there is no network connection, print nothing and set $? to 1.
ips(){
	echo "Internal_IP:	$(hostname -I | cut -d ' ' -f 1)" | grep -E '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+'
	echo "External_IP:	$(curl -s http://whatismyip.akamai.com/)" | grep -E '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+'
}

