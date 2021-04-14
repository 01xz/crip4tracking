#! /bin/bash

start_time=`date +%s`

# max thread numbers
THREAD_NUM=12

# current path
BASE_PATH=$(dirname $(readlink -f "$0"))

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

for img in ${BASE_PATH}/${SOURCE_FOLDER}/*.jpg; do
	read -u6
	{
		convert "$img" "${img%.jpg}.png"
		rm "$img"
		echo >&6
	} &
done

wait

stop_time=`date +%s`
echo "TIME: `expr $stop_time - $start_time`s"

exec 6>&-
echo "Conversion of ${SOURCE_FOLDER} to PNG format complete!"
