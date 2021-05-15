#! /bin/bash

start_time=`date +%s`
i=0

# source folder
SOURCE_FOLDER=$1

# read folder
function read_dir() {
    for file in `ls $1`; do
        if [ -d "$1/$file" ]; then
            read_dir "$1/$file"
        else
            if [ "${file#*.}"x = "jpg"x ]; then
                 i=$(( $i + 1 ))
            else
                echo "ERROR: $1/$file is not in JPG format!"
            fi
        fi
    done
} 

read_dir $SOURCE_FOLDER


stop_time=`date +%s`
echo "TIME: `expr $stop_time - $start_time`s"

echo "${i} frames"

