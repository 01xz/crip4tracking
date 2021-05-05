#! /bin/bash

start_time=`date +%s`

# max thread numbers
THREAD_NUM=32

# source folder
SOURCE_FOLDER=$1

# version
VERSION=$2

# output folder
OUTPUT_FOLDER="output/v$VERSION"

# if output folder doesn't exist, create it
if [ ! -d "$OUTPUT_FOLDER" ]; then
    mkdir -p "$OUTPUT_FOLDER"
fi

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
            mkdir -p "$OUTPUT_FOLDER/${1#*/}/$file"
            read_dir "$1/$file"
        else
            if [ "${file#*.}"x = "jpg"x ]; then
                read -u6
                {
                	convert "$1/$file" "$OUTPUT_FOLDER/${1#*/}/${file%.jpg}.png"
                	echo >&6
    	        } &
            else
                echo "ERROR: $1/$file is not in JPG format!"
            fi
        fi
    done
} 

# set output path
if [ "${SOURCE_FOLDER%%/*}"x = "datasets"x ]; then
    if [ ! -d "$OUTPUT_FOLDER/${1#*/}" ]; then
        mkdir -p "$OUTPUT_FOLDER/${1#*/}"
    else
        rm -rf $OUTPUT_FOLDER/${1#*/}/*
    fi

    read_dir $SOURCE_FOLDER
else
    echo "ERROR: Not in datasets folder!"
fi

wait

# record running time
stop_time=`date +%s`
echo "TIME: `expr $stop_time - $start_time`s"

exec 6>&-
echo "Conversion of ${SOURCE_FOLDER} to PNG format complete!"

