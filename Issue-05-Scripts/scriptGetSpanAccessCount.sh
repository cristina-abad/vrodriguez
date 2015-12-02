#!/bin/bash

filename="$1"

cut -d \  -f 1 "$filename" > $filename-tmp2
tail -n +2 $filename-tmp2 > $filename-tmp
rm -f $filename-tmp2

echo "id span accessCount"

while read id; do
	filename_id="Animation-traces/it-$id.txt"
	interarrivals=$(wc -l $filename_id | cut -d \  -f 1)
	accessCount=$((interarrivals + 1))
	span=$(awk '{ sum += $1 } END { printf("%.10f\n",sum) }' $filename_id)
	echo "$id $span $accessCount"
done <$filename-tmp

rm -f $filename-tmp
