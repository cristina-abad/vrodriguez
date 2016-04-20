#### Add libraries neccesaries
for (package in c('data.table', 'getopt')) {
  if (!require(package, character.only=T, quietly=T, warn.conflicts = F)) {
    install.packages(package)
    library(package, character.only=T, quietly = T, warn.conflicts = F)
  }
}

### Functions

skscaleR <- function(dd){
  r <- scale(x = x.ds, center = TRUE, scale = apply(X = x.ds, 2, sd, na.rm = TRUE))
  return(r)
}

colVar <- function(dd){
  return (apply(dd, 2, function(x){ var(x)}))
}

varianceThreshold <- function(dd, variance){
  dd <- as.data.frame(dd)
  r <- as.matrix(dd[, colVar(dd)>= variance])
  return (r)
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
  list("pca" = t.pca, "variances" = t.variances)
}

### Main program

datasetFile <- ''
clusters <- 500
spec <- t(matrix(c('help', 'h', 0, "logical",
                   'file=', 'f', 2, "character",
                   'clusters=', 'k', 1, "character"), nrow = 4))

#argv <- commandArgs(trailingOnly = TRUE)
args <- c("-f","./test/Animation-lookup-100k.txt-dataset", '-k', 10)
opts = getopt(spec, args)
if(!is.null(opts$help)){
  print('scriptKmeans.R -f <datasetFile> -k <clusters>')
  quit(save = "no", status = 2)
}else if(!is.null(opts$file)){
  datasetFile <- opts$file
}
if(!is.null(opts$clusters)){
  clusters <- opts$clusters
}else{
  print('scriptKmeans.R -f <datasetFile> -k <clusters>')
  quit(save = "no", status = 2)
}
if(length(datasetFile) == 0){
  print ('ERROR: Must specify a trace filename.')
  print ('scriptKmeans.py -f <datasetFile>')
  quit(save = "no", status = 1)
}

### Load dataset from file passed as argument. Without the ID column. 
x.ds <- fread(input = datasetFile,  sep = " ", header = T, dec = ".")
x.ds$id <- NULL
x.scaled <- skscaleR(x.ds)

cat("========================================\n")
cat('Scaled Dataset Shape: ')
cat(dim(x.scaled))
cat("\n")

### Set similar variance for all dimensionality reduction methods:
### This could be read from arguments
variance <- 0.9

### Apply Variance Threshold
x.varianceThreshold <- varianceThreshold(x.ds, variance)
cat('========================================\n')
cat("Variance Threshold: ")
cat(dim(x.varianceThreshold))
cat('\nShape after Variance Threshold:')
cat(x.varianceThreshold)
cat("\n")

### Apply PCA
x_scaled_pca <- pca(data = x.scaled, n_components = variance)
cat('========================================\n')
cat("Shape after PCA:")
cat(dim(x_scaled_pca$pca))
cat('\nVarinate Ratio: \n')
cat(x_scaled_pca$variances)
cat("\n")

### K-Means with the Scaled Dataset - k=<clusters> 500 by default
cat('\n========================================\n')
cat('K-means only with Scaled Dataset:\n')
# In R, doesn't exist 'kmeans++'
kmeans.allFeatures = kmeans(x = x.scaled, centers = clusters, nstart = 10)

write.table('Cluster-id', 
          file = paste(datasetFile, "_clustered-Z_allFeatures.csv", sep = ''),
          row.names = F, col.names = F)

write.table(kmeans.allFeatures$cluster, 
          file = paste(datasetFile, "_clustered-Z_allFeatures.csv", sep = ''),
          append = T, sep = '\n', row.names = F, col.names = F)

write.csv(kmeans.allFeatures$centers,
          file = paste(datasetFile, "_clusters_centers-Z_allFeatures.csv", sep = ''),
          row.names = F)

### K-Means with VarianceThreshold - k=500 per elbow test
cat('========================================\n')
cat('K-means with VarianceThreshold:\n')
if (all(dim(x.scaled) == dim(x.varianceThreshold))){
  cat('VarianceThreshold didn\'t remove any feature.')
}else{
  kmeans.varianceThreshold <- kmeans(x = x.varianceThreshold, centers = clusters, nstart = 10)
  
  write.table('Cluster-id', 
              file = paste(datasetFile, "_clustered-Z_varianceThreshold.csv", sep = ''),
              row.names = F, col.names = F)
  
  write.table(kmeans.allFeatures$cluster, 
            file = paste(datasetFile, "_clustered-Z_varianceThreshold.csv", sep = ''),
            append = T, sep = '\n', row.names = F, col.names = F)
  
  write.csv(kmeans.allFeatures$centers,
            file = paste(datasetFile, "_clusters_centers-Z_varianceThreshold.csv", sep = ''),
            row.names = F)
}

### K-Means with PCA - k=<clusters> 500 by default
cat('========================================\n')
cat('K-means with PCA:\n')
###kmeans_withPCA = KMeans(init='k-means++', n_clusters=500, n_init=10)
kmeans.withPCA = kmeans(x = x_scaled_pca$pca$scores, centers = clusters, nstart = 10)

write.table('Cluster-id', 
            file = paste(datasetFile, "_clustered-Z_withPCA.csv", sep = ''),
            row.names = F, col.names = F)

write.table(kmeans.withPCA$cluster, 
          file = paste(datasetFile, "_clustered-Z_withPCA.csv", sep = ''),
          append = T, sep = '\n', row.names = F, col.names = F)

write.csv(kmeans.withPCA$centers,
          file = paste(datasetFile, "_clusters_centers-Z_withPCA.csv", sep = ''),
          row.names = F)

### K-Means 2 Features Skewness and AverageInterarrival (mean) - k=<clusters> 500 by default
### id mean median mid-range gmean std iqr range mad coeficiente_variacion skewness kurtosis

cat('========================================\n')
cat('K-means with 2 Features: Skewness and AverageInterarrival:\n')
kmeans.twoFeatures <- kmeans(x = x.scaled[, c(1,10)], centers = clusters, nstart = 10)

write.table('Cluster-id', 
            file = paste(datasetFile, "_clustered-Z_twoFeatures.csv", sep = ''),
            row.names = F, col.names = F)

write.table(kmeans.twoFeatures$cluster,
          file = paste(datasetFile, "_clustered-Z_twoFeatures.csv", sep = ''),
          append = T, sep = '\n', row.names = F, col.names = F)

write.csv(kmeans.twoFeatures$centers,
          file = paste(datasetFile, "_clusters_centers-Z_twoFeatures.csv", sep = ''),
          row.names = F)