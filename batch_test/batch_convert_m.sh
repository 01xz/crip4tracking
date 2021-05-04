#! /bin/bash

start_time=`date +%s`

# max thread numbers
THREAD_NUM=32

# source folder
SOURCE_FOLDER=$1

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
	            read -u6
	            {
	            	convert "$1/$file" "$1/${file%.jpg}.png"
	            	rm "$1/$file"
	            	echo >&6
	            } &
            elif [ "${file#*.}"x = "png"x ]; then
                echo "WARNING: $1/$file is already in PNG format!"
            else
                echo "ERROR: JPG image NOT FOUND!"
            fi
        fi
    done
} 

read_dir $SOURCE_FOLDER

wait

stop_time=`date +%s`
echo "TIME: `expr $stop_time - $start_time`s"

exec 6>&-
echo "Conversion of ${SOURCE_FOLDER} to PNG format complete!"

