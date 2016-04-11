for (package in c('getopt')) {
  if (!require(package, character.only=T, quietly=T)) {
    install.packages(package)
    library(package, character.only=T)
  }
}

### Functions

skscaleR <- function(x){
  return (scale(x, center = TRUE, scale = apply(x, 2, sd, na.rm = TRUE)))
}

colVar <- function(x){
  return (apply(dd, 2, function(x){ var(x)}))
}

varianceThreshold <- function(dd, variance){
  dd <- as.data.frame(dd)
  return (as.matrix(dd[, colVar(dd)>= variance]))
}

datasetFile <- ''
clusters <- 500
spec <- t(matrix(c('help', 'h', 0, "logical",
                   'file', 'f', 1, "character",
                   'datasetFile=', 'd', 2, "character",
                   'clusters=', 'c', 1, "character")))

argv <- commandArgs(trailingOnly = TRUE)
opts = getopt(spec, argv)
if(!is.null(opts$help)){
  print('scriptKmeans.py -f <datasetFile>')
  quit(save = "no", status = 2)
}else if(!is.null(opts$datasetFile)){
  datasetFile <- opts$file
}else if(!is.null(opts$clusters)){
  clusters <- opts$clusters
}else{
  print('scriptKmeans.py -f <datasetFile>')
  quit(save = "no", status = 2)
}
if(length(traceFilename) == 0){
  print ('ERROR: Must specify a trace filename.')
  print ('scriptKmeans.py -f <datasetFile>')
  quit(save = "no", status = 1)
}

### Load dataset from file passed as argument. Without the ID column. 
dataset <- read.table(datasetFile, quote="\"", comment.char="", sep = " ", header = F)
### X = dataset[:,1:]
x.ds <- dataset
###X_scaled = scale(X, axis=0, with_mean=False, with_std=False, copy=True)
x.scaled <- skscaleR(X)

cat("========================================\n")
cat('Scaled Dataset Shape:')
cat(dim(x.scaled))

### Set similar variance for all dimensionality reduction methods:
### This could be read from arguments
variance <- 0.9

### Apply Variance Threshold
x.varianceThreshold <- varianceThreshold(x.ds, variance)
cat('========================================\n')
cat('Variance Threshold:\n')
cat(sprintf("Shape after VarianceThreshold: %s\n", dim(x.varianceThreshold)))

### Apply PCA
x.pca <- prcomp(x = x.scaled)