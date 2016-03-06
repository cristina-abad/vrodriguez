#!/bin/bash
FNAME=$1

SUM=`cat $FNAME | awk '{s+=$2}; END{print s}'`
#echo $SUM
cat $FNAME | awk -v sum=$SUM '{p=$2/sum; c+=p; print $1, $2, p, c}'