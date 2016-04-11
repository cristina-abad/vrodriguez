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

pca <- function(data, n_components = NULL){
  i <- 0
  tmp <- 0
  t.pca <- princomp(x = data)
  t.summary <- summary(t.pca)
  t.totalVariance <-sum(t.summary$sdev^2)
  t.variances <- t.summary$sdev^2 / t.totalVariance
  for(i in 1:length(t.variances)){
    tmp <- tmp + t.variances[i]
    if(tmp >= n_components)
      break;
  }
  t.transformed <-predict(t.pca, newdata = data)
  t.components <-as.data.frame(t.transformed[,1:i])
  return (t)
}

### Main program

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
cat(sprintf("Variance Threshold:%s\n", dim(x.varianceThreshold)))
cat('Shape after VarianceThreshold:')
cat(x.varianceThreshold)

### Apply PCA
x.scaled_pca <- pca(data = x.scaled, n_components = variance)
cat('========================================\n')
cat(sprintf("Shape after PCA: %s\n", dim(x.scaled_pca.pca)))
cat('Varinate Ratio: ')
cat(x.scaled_pca.variances)

### K-Means with the Scaled Dataset - k=<clusters> 500 by default
cat('========================================\n')
cat('K-means only with Scaled Dataset:\n')
# In R, doesn't exist 'kmeans++'
kmeans.allFeatures = kmeans(x = x.scaled, centers = clusters, nstart = 10)
write.csv(kmeans.allFeatures, 
          file = paste(datasetFile, "_clustered-Z_allFeatures.csv", sep = ''),
          col.names = 'Cluster-id',
          sep = ',')

write.csv(kmeans.allFeatures$centers,
          file = paste(datasetFile, "_clusters_centers-Z_allFeatures.csv", sep = ''),
          sep = ',')

### K-Means with VarianceThreshold - k=500 per elbow test
cat('========================================\n')
cat('K-means with VarianceThreshold:\n')
if (dim(x.scaled) == dim(x.varianceThreshold)){
  cat('VarianceThreshold didn\'t remove any feature.')
}else{
  kmeans.varianceThreshold <- kmeans(x = x.varianceThreshold, centers = clusters, nstart = 10)
  write.csv(kmeans.allFeatures, 
            file = paste(datasetFile, "_clustered-Z_varianceThreshold.csv", sep = ''),
            col.names = 'Cluster-id',
            sep = ',')
  
  write.csv(kmeans.allFeatures$centers,
            file = paste(datasetFile, "_clusters_centers-Z_varianceThreshold.csv", sep = ''),
            sep = ',')
}

### K-Means with PCA - k=<clusters> 500 by default
cat('========================================\n')
cat('K-means with PCA:\n')
###kmeans_withPCA = KMeans(init='k-means++', n_clusters=500, n_init=10)
kmeans.withPCA = kmeans(x = x.scaled_pca, centers = clusters, nstart = 10)
write.csv(kmeans.allFeatures, 
          file = paste(datasetFile, "_clustered-Z_withPCA.csv", sep = ''),
          col.names = 'Cluster-id',
          sep = ',')

write.csv(kmeans.allFeatures$centers,
          file = paste(datasetFile, "_clusters_centers-Z_withPCA.csv", sep = ''),
          sep = ',')

### K-Means 2 Features Skewness and AverageInterarrival (mean) - k=<clusters> 500 by default
### id mean median mid-range gmean std iqr range mad coeficiente_variacion skewness kurtosis

cat('========================================\n')
cat('K-means with 2 Features: Skewness and AverageInterarrival:\n')
kmeans.twoFeatures <- kmeans(x = x.scaled[, c(1,10)])
write.csv(kmeans.allFeatures, 
          file = paste(datasetFile, "_clustered-Z_twoFeatures.csv", sep = ''),
          col.names = 'Cluster-id',
          sep = ',')

write.csv(kmeans.allFeatures$centers,
          file = paste(datasetFile, "_clusters_centers-Z_twoFeatures.csv", sep = ''),
          sep = ',')