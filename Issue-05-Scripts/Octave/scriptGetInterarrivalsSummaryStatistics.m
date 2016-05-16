#! /bin/octave -qf
warning("off");
source("./functions.m");

% Add packages
%pkg load java;
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
	printf("No such filename\n");
	exit(0);
endif

% Create the interarrival dictionary

interarrival = javaObject("java.util.Hashtable");

% Open the file in read mode, and parse each line to obtain the timestamp,
% the command, and the id.
file = fopen(strcat(traceFilename, "-IndiceLeido"), "w");
reader = fopen(traceFilename, "r");
while(!feof(reader))
	[line1, line2, line3] = fscanf(reader,"%f %s %[^\n]","C");
	fprintf(file,"%.15f\n", line1);
	if(interarrival.containsKey(line3))
		myfile = fopen(strcat(traceFilename, "-interarrivals\/it-", line3,".txt"), "a");
		fprintf(myfile, "%.15f\n", line1*1000 - interarrival.get(line3));
		fclose(myfile);
	endif
	interarrival.put(line3, line1 * 1000);
endwhile
fclose(reader);
fclose(file);

% Calculate the summary statistics for each key with more than 2 interarrivals.

printf("id mean median mid-range gmean std iqr range mad coeficiente_variacion skewness kurtosis\n");
keys = interarrival.keys;
while(keys.hasMoreElements())
	k = keys.nextElement();
	v = interarrival.get(k);
	f = fopen(strcat(traceFilename,"-interarrivals\/it-",k,".txt"), "r");
	if (f != -1)	
		v = fscanf(f, "%f\n");
		if(length(v) > 1)
			printf("%f %f %f %f %f %f %f %f %f %f %f\n",
				mean(v),
				median(v),
				range(v)/2,
				mean(v, "g"),
				std(v),
				prctile(v, 75) - prctile(v, 25),
				range(v),
				mad(v),
				var(v),
				skewness(v),
				kurtosis(v));
		endif
		fclose(f);
	endif
endwhile