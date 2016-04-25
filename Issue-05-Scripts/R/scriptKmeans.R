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

getNComponents <- function(dd, variance){
  r <-0
  cnt <- 0
  for (i in dd) {
    if(r >= variance)
      break
    r <- r + i
    cnt <- cnt + 1
  }
  return(cnt)
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

writeResult <- function(ds, clusters, centers, filename1, filename2){
  write.table('Cluster-id', 
              file = paste(ds, filename1, sep = ''),
              row.names = F, col.names = F)
  
  write.table(clusters,
              file = paste(ds, filename1, sep = ''),
              append = T, sep = '\n', row.names = F, col.names = F)
  
  write.csv(centers,
            file = paste(ds, filename2, sep = ''),
            row.names = F)
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

cat("========================================\n\n")
cat('Scaled Dataset Shape: \n')
cat(dim(x.scaled))
cat("\n")

### Set similar variance for all dimensionality reduction methods:
### This could be read from arguments
variance <- 0.9

### Apply Variance Threshold
x.varianceThreshold <- varianceThreshold(x.ds, variance)
x.varianceThreshold_var <- colVar(x.ds)
cat('========================================\n')
cat("\nVariance Threshold: \n")
cat('\nShape after Variance Threshold:\n')
cat(dim(x.varianceThreshold))
cat("\n\nVariance of each feature: \n\n")
cat(x.varianceThreshold_var)
cat("\n\n")


### Apply PCA
x_scaled_pca <- pca(data = x.scaled, n_components = variance)
cat('========================================\n\nPCA\n\n')
cat("Shape after PCA:")
d<- getNComponents(x_scaled_pca$variances, variance)
cmps <- x_scaled_pca$pca$scores[, c(1:d)]
cat(dim(cmps))
cat('\n\nVarinate Ratio: \n\n')
cat(x_scaled_pca$variances[c(1:d)])
cat("\n\n")

### K-Means with the Scaled Dataset - k=<clusters> 500 by default
cat('========================================\n\n')
cat('K-means only with Scaled Dataset:\n\n')
# In R, doesn't exist 'kmeans++'
kmeans.allFeatures = kmeans(x = x.scaled, centers = clusters, nstart = 10)

writeResult(ds = datasetFile, clusters = kmeans.allFeatures$cluster-1,
            centers = kmeans.allFeatures$centers,
            filename1 = "_clustered-Z_allFeatures.csv",
            filename2 = "_clusters_centers-Z_allFeatures.csv")

### K-Means with VarianceThreshold - k=500 per elbow test
cat('========================================\n\n')
cat('K-means with VarianceThreshold:\n\n')
if (all(dim(x.scaled) == dim(x.varianceThreshold))){
  cat('VarianceThreshold didn\'t remove any feature.')
}else{
  kmeans.varianceThreshold <- kmeans(x = x.varianceThreshold, centers = clusters, nstart = 10)

  writeResult(ds = datasetFile, clusters = kmeans.allFeatures$cluster-1,
              centers = kmeans.allFeatures$centers,
              filename1 = "_clustered-Z_varianceThreshold.csv",
              filename2 = "_clustered-centers-Z_varianceThreshold.csv")
}

### K-Means with PCA - k=<clusters> 500 by default
cat('========================================\n\n')
cat('K-means with PCA:\n\n')
###kmeans_withPCA = KMeans(init='k-means++', n_clusters=500, n_init=10)
kmeans.withPCA = kmeans(x = x_scaled_pca$pca$scores, centers = clusters, nstart = 10)

writeResult(ds = datasetFile, clusters = kmeans.withPCA$cluster-1,
            centers = kmeans.withPCA$centers,
            filename1 = "_clustered-Z_withPCA.csv",
            filename2 = "_clusters_centers-Z_withPCA.csv")

### K-Means 2 Features Skewness and AverageInterarrival (mean) - k=<clusters> 500 by default
### id mean median mid-range gmean std iqr range mad coeficiente_variacion skewness kurtosis

cat('========================================\n\n')
cat('K-means with 2 Features: Skewness and AverageInterarrival:\n\n')
kmeans.twoFeatures <- kmeans(x = x.scaled[, c(1,10)], centers = clusters, nstart = 10)

writeResult(ds = datasetFile, clusters = kmeans.twoFeatures$cluster-1,
            centers = kmeans.twoFeatures$centers,
            filename1 = "_clustered-Z_twoFeatures.csv",
            filename2 = "_clusters_centers-Z_twoFeatures.csv")
