#!/bin/env python
# -*- coding: utf-8 -*-
"""
Created on Wed Aug 18 15:56:22 2015
Updated on Fri Feb 26 18:00 2016

@author: Edwin Boza

This script will take the traces in the format:

<timestamp>,<command>,<key>

Example:
1169603076.856202900 lookup b182cb03632d031c20000000055471839fad021e60f8077662000000005e2900
1169603076.856487580 lookup 059f13004fb46a0d2000000002223e3b198b7c0560f8073d059f13004fb46a00
1169603076.856570728 lookup 059f13004fb46a0d20000000004d4d950e7b500d60f8073d059f13004fb46a00
1169603076.857083462 lookup b182cb03632d031c20000000005fdd62e02f540660f8077662000000005e2900

And will build a dictionary data structure (associative array) where the "key"
is the same from the trace, and the "value" will be a list with the first "timestamp" 
in the first column followed by the interarrival times for that key in the trace.

Example:

b5uYCMK5OPw [1201640127.407787, 149.57468390464783]
cCrovnNGdSg [1201639835.880928, 41.252618074417114, 114.19751787185669]
FJ2UzCZiKgU [1201640457.867881, 134.70666790008545, 186.00839400291443]
6Xvl5NIYRMo [1201640001.472448, 86.00124883651733]
PHftynDEdnI [1201640604.287385, 5.040781021118164]
b_2UjlF_0Cw [1201640380.362763, 282.40411615371704]
1eTvHe-B_pQ [1201639811.482183, 156.42174196243286, 312.8852529525757, 469.40604305267334, 625.7763419151306, 782.145672082901]


Then compute the summary statistics for the interarrivals for each key with 
more than 2 interarrival times:

beHSh19FJo8 [111.50369501113892, 1.7767560482025146, 113.15753507614136, 4.485356092453003, 119.55210494995117, 12.519658088684082]


"""

import sys, getopt, numpy
import csv, os
from scipy import stats

def mad(data, axis=None):
    return numpy.median(numpy.absolute(data - numpy.median(data, axis)), axis)

def main(argv):
    ### Put the arguments in variables.
    traceFilename = ''
    try:
        opts, args = getopt.getopt(argv,"hf:",["tracefile="])
    except getopt.GetoptError:
        print 'scriptGetInterarrivalsSummaryStatistics.py -f <tracefile>'
        sys.exit(2)
    for opt, arg in opts:
        if opt == '-h':
            print 'scriptGetInterarrivalsSummaryStatistics.py -f <tracefile>'
            sys.exit()
        elif opt in ("-f", "--tracefile"):
            traceFilename = arg
    if traceFilename == '':
        print 'ERROR: Must specify a trace filename.'
        print 'scriptGetInterarrivalsSummaryStatistics.py -f <tracefile>'
        sys.exit(1)
    
    ### Create the interarrival dictionary
    interarrival = {}
    file = open(traceFilename + "-IndiceLeido", "a")

    ### Open the file in read mode, and parse each line to obtain the timestamp,
    ### the command, and the id.
    with open (traceFilename, "r") as traceFile:
        reader = csv.reader(traceFile, delimiter=' ')
        for line in reader:
	    file.write(line[0]+'\n')
            if line[2] in interarrival:
		with open(traceFilename + "-interarrivals/it-" + line[2] + ".txt", "a") as myfile:
    		     myfile.write(str((float(line[0])*1000)-interarrival[line[2]][0])+'\n')
            interarrival[line[2]] = [(float(line[0])*1000)]
    file.close()
    ### Calculate the summary statistics for each key with more than 2 interarrivals.
    ### print 'id mean median mid-range gmean hmedian std iqr range mad coeficiente_variacion skewness kurtosis'
    ###        + str(stats.hmean(v[2:])) + ' ' \
    print 'id mean median mid-range gmean std iqr range mad coeficiente_variacion skewness kurtosis'
    for k, t in interarrival.iteritems():
	if os.path.isfile(traceFilename + '-interarrivals/it-' + k + '.txt'):
	   v = [float(line) for line in open(traceFilename + '-interarrivals/it-' + k + '.txt')]
           if len(v) > 1:  
               print k + ' ' + str(numpy.mean(v)) + ' ' \
               + str(numpy.median(v)) + ' ' \
               + str((numpy.max(v)-numpy.min(v))/2) + ' ' \
               + str(stats.mstats.gmean(v)) + ' ' \
               + str(numpy.std(v)) + ' ' \
               + str(numpy.subtract(*numpy.percentile(v, [75, 25]))) + ' ' \
               + str(numpy.ptp(v)) + ' ' \
               + str(mad(v)) + ' ' \
               + str(stats.variation(v)) + ' ' \
               + str(stats.skew(v))  + ' ' \
               + str(stats.kurtosis(v))

if __name__ == "__main__":
   main(sys.argv[1:])
