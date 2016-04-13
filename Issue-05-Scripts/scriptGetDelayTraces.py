#!/bin/env python
# -*- coding: utf-8 -*-

import sys, getopt, numpy
import csv, os

def main(argv):
    ### Put the arguments in variables.
    traceFilename = ''
    try:
        opts, args = getopt.getopt(argv,"hf:",["tracefile="])
    except getopt.GetoptError:
        print 'scriptGetDelayTraces.py -f <tracefile>'
        sys.exit(2)
    for opt, arg in opts:
        if opt == '-h':
            print 'scriptGetDelayTraces.py -f <tracefile>'
            sys.exit()
        elif opt in ("-f", "--tracefile"):
            traceFilename = arg
    if traceFilename == '':
        print 'ERROR: Must specify a trace filename.'
        print 'scriptGetDelayTraces.py -f <tracefile>'
        sys.exit(1)

    ### Get the first line to get the starting point
    with open (traceFilename, "r") as traceFile:
        reader = csv.reader(traceFile, delimiter=' ')
	row1 = next(reader)
    zero = float(row1[0])

    ### Create the interarrival dictionary
    interarrival = {}
    file = open(traceFilename + "-delays-IndiceLeido", "a")

    ### Open the file in read mode, and parse each line to obtain the timestamp,
    ### the command, and the id.
    with open (traceFilename, "r") as traceFile:
        reader = csv.reader(traceFile, delimiter=' ')
        for line in reader:
	    file.write(line[2]+'\n')
            if line[2] not in interarrival:
		interarrival[line[2]] = [float(line[0])]
		with open(traceFilename + "-delays", "a") as myfile:
    		     myfile.write(line[2] +  ' ' + str((float(line[0])-zero)*1000)+'\n')
    file.close()

if __name__ == "__main__":
   main(sys.argv[1:])
