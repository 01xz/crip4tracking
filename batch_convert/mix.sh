#! /bin/bash

start_time=`date +%s`

# max thread numbers
THREAD_NUM=32

# orig folder
ORIG_FOLDER=$1

# version folder
V_FOLDER=$2

# bypassed frames
BF=$3

# create a new folder
DEST_FOLDER="$V_FOLDER-BF$BF"
cp -r $V_FOLDER $DEST_FOLDER

# multi-thread related
tmp_fifofile="/tmp/$$.fifo"
mkfifo $tmp_fifofile
exec 6<>$tmp_fifofile
rm $tmp_fifofile

for ((i=0;i<${THREAD_NUM};i++));do
	echo
done >&6

# read folder
function read_dir() {
    for file in `ls $1`; do
        if [ -d "$1/$file" ]; then
            read_dir "$1/$file"
        else
            if [ "${file#*.}"x = "jpg"x ]; then
                if [ $(( 10#${file:3:7} % $(($BF+1)) )) = 1 ]; then
	                read -u6
	                {
                        cp "$1/$file" "$DEST_FOLDER/${1#*/}/$file"
	            	    echo >&6
	                } &
                fi
            else
                echo "ERROR: $1/$file is not in PNG format!"
            fi
        fi
    done
} 

read_dir $ORIG_FOLDER

wait

stop_time=`date +%s`
echo "TIME: `expr $stop_time - $start_time`s"

exec 6>&-
echo "Finished creating $DEST_FOLDER !"

