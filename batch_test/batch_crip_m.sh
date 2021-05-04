#! /bin/bash

start_time=`date +%s`

# max thread numbers
THREAD_NUM=32

# current path
BASE_PATH=$(dirname $(readlink -f "$0"))

# CLI path
CLI_PATH="/approx-vision/pipelines/CLI/pipeline.py"

# make path
MAKE_PATH="/approx-vision/pipelines/CLI/core"

# obj path
OBJ_PATH="${MAKE_PATH}/Pipeline.o"

# source folder
SOURCE_FOLDER=$1

# version
VERSION=$2

# if folder 'output' doesn't exist, create it
if [ ! -d "$BASE_PATH/output" ]; then
	mkdir "$BASE_PATH/output"
fi

# if source folder doesn't exist, create it, otherwise, empty it
if [ ! -d "$BASE_PATH/output/$SOURCE_FOLDER" ]; then
	mkdir -p "$BASE_PATH/output/$SOURCE_FOLDER"
else
	rm -rf "$BASE_PATH/output/$SOURCE_FOLDER/*"
fi

# build Pipeline.o from source file
if [ ! -f "${OBJ_PATH}" ]; then
	make -C ${MAKE_PATH}
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
            mkdir -p "$BASE_PATH/output/$1/$file"
            read_dir "$1/$file"
        else
            if [ "${file#*.}"x = "png"x ]; then
	            read -u6
	            {
		            python $CLI_PATH --build False --infile "$BASE_PATH/$1/$file" --outfile "$BASE_PATH/output/$1/$file" --version $VERSION
	            	echo >&6
	            } &
            else
                echo "ERROR: PNG image NOT FOUND!"
            fi
        fi
    done
} 

read_dir $SOURCE_FOLDER

wait

# record time
stop_time=`date +%s`
echo "TIME: `expr $stop_time - $start_time`s"

exec 6>&-
echo "Conversion of $SOURCE_FOLDER under version$VERSION complete!"

