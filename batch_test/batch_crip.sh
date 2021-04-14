#! /bin/bash

mkdir output
for x in ./*/*.png; do
	python /approx-vision/pipelines/CLI/pipeline.py --infile $x --outfile /crip/batch_test/output/${x##*/} --build False --version 12
done
