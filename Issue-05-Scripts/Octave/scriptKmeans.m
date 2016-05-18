#! /bin/octave -qf
warning("off");
source("./myFunctions.m");

% Add packages
pkg load statistics;
format long;

% Main program

args = argv();
datasetFile = "";

if paramIn("-h", args)
	printf("scriptParseYoutubeTraces.m -f <tracefile> \n");
	exit(0);
endif

properties = struct("-h",[],"-f", [], -k, []);
properties = getopt(properties, args{:});

if paramIn("-f", args)
	traceFilename = properties.("-f");
endif

if paramIn("-k", args)
	datasetFile = properties.("-k");
endif

if isempty(traceFilename)
	printf("ERROR: Must specify a trace filename.\n");
	printf("scriptGetDelayTraces.m -f <tracefile>")
	exit(0);
endif

% Load dataset from file passed as argument. Without the ID column.  
x.ds = dlmread(datasetFile, " ");
x.ds{1,:} = []											% Remove the first column
x.scaled = scale();

printf(""========================================\n\n"");
printf("Scaled Dataset Shape: \n");
disp(size(x.scaled))

% Set similar variance for all sizeensionality reduction methods:
% This could be read from arguments

variance = 0.9;

% Apply Variance Threshold
x.varianceThreshold = x.ds(:, find(var(x.ds)<=variance)
x.varianceThreshold_var = var(x.ds);							% Get variance by columns
printf("========================================\n");
printf("\nVariance Threshold: \n");
printf("\nShape after Variance Threshold:\n");
disp(size(x.varianceThreshold));
printf("\n\nVariance of each feature: \n\n");
disp(x.varianceThreshold_var);
printf("\n\n");

% Apply PCA
x_scaled_pca <- pca(data = x.scaled, n_components = variance)
printf("========================================\n\nPCA\n\n")
printf("Shape after PCA:")
d = getNComponents(x_scaled_pca$variances, variance)
cmps = x_scaled_pca$pca$scores[, c(1:d)]
disp(size(cmps))
printf("\n\nVarinate Ratio: \n\n")
disp(x_scaled_pca.variances[c(1:d)])
printf("\n\n")
