#! /bin/bash

start_time=`date +%s`

# define max thread numbers
thread_num=12

tmp_fifofile="/tmp/$$.fifo"
mkfifo $tmp_fifofile
exec 6<>$tmp_fifofile
rm $tmp_fifofile

for ((i=0;i<${thread_num};i++));do
	echo
done >&6

for image in ./*/*.jpg; do
	read -u6
	{
		convert "$image" "${image%.jpg}.png"
		rm "$image"
		echo >&6
	} &
done

wait

stop_time=`date +%s`
echo "TIME: `expr $stop_time - $start_time`s"

exec 6>&-
echo "Conversion completed!"
