#! /bin/octave -qf
warning("off");
source("./myFunctions.m");

% Add packages
pkg load statistics;
format long;

% Main program

args = argv();
traceFilename = "";

if paramIn('-h', args)
	printf("scriptParseYoutubeTraces.m -f <tracefile> \n");
	exit(0);
endif

properties = struct('-h',[],'-f', []);
properties = getopt(properties, args{:});

if paramIn('-f', args)
	traceFilename = properties.("-f");
endif

if isempty(traceFilename)
	printf("ERROR: Must specify a trace filename.\n");
	printf("scriptGetDelayTraces.m -f <tracefile>")
	exit(0);
endif

traceFile = fopen(traceFilename, "r");
[zero, tmp] = fscanf(traceFile, "%f %[^\n]", "C");
fclose(traceFile);

% Create the interarrival dictionary
interarrival = javaObject("java.util.Hashtable");
file = fopen(strcat(traceFilename, "-delays-IndiceLeido"), "a");

% Open the file in read mode, and parse each line to obtain the timestamp,
% the command, and the id.

traceFile = fopen(traceFilename, "r");
while(!feof(traceFile))
	[line1, line2, line3] = fscanf(traceFile,"%f %s %[^\n]","C");
	fprintf(file, "%s\n", line3);
	if(!interarrival.containsKey(line3))
		interarrival.put(line3, line1);
		myFile = fopen(strcat(traceFilename, "-delays"), "a");
		fprintf(myFile, "%s %f\n",line3, (line1-zero)*1000);
		fclose(myFile);
	endif
endwhile

fclose(traceFile);