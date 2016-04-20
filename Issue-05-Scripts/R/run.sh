#!/bin/bash
traceFilename="$1"
clusters="$2"
echo  
echo "###################"
echo "Starting..."
date
echo "Get list of unique objets in the trace..."
cut -d " " -f 3 $traceFilename|sort -u > $traceFilename-uniqueObjects
date
echo "Clear trace folder and index file..."
rm -rf $traceFilename-interarrivals $traceFilename-IndiceLeido.txt
mkdir $traceFilename-interarrivals
echo "Get interarrival times and summary statistics..."
date
Rscript scriptGetInterarrivalsSummaryStatistics.R -f $traceFilename > $traceFilename-dataset
echo "Get SPAN y AccessCounts..."
Rscript scriptGetSpanAccessCount.R $traceFilename > $traceFilename-SpanAccessCount
date
echo "Get DELAYS..."
Rscript scriptGetDelayTraces.R -f $traceFilename
date

echo "Sort SPAN/AccessCounts and DELAYS files..."
sort $traceFilename-delays > $traceFilename-delays-sorted
sort $traceFilename-SpanAccessCount > $traceFilename-SpanAccessCount-sorted
date

echo "K-means..."
Rscript scriptKmeans.R -f $traceFilename-dataset -k $clusters
date