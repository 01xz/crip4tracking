#! /bin/bash

for x in ./*/*.jpg; do
	convert "$x" "${x%.jpg}.png"
	rm "$x"
done
