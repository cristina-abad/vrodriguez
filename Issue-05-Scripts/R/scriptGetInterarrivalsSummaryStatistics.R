#### Add libraries neccesaries
for (package in c('getopt', 'hash', 'moments')) {
  if (!require(package, character.only=T, quietly=T)) {
    install.packages(package)
    library(package, character.only=T)
  }
}

### Functions
gmean <- function(x){
  return(exp(mean(log(x))))
}

ptp <- function(x){
  return(max(x) - min(x))
}

### Main program
traceFilename <- ""
spec <- t(matrix(c('help', 'h', 0, "logical",
          'file', 'f', 1, "character",
          'tracefile', 't', 2, "character"),nrow=4, ncol=3))
argv <- commandArgs(trailingOnly = TRUE)
#argv <- c("-f", "Animation-lookup-100k.txt")
opts = getopt(spec, argv)
if(!is.null(opts$help)){
  print('scriptGetInterarrivalsSummaryStatistics.py -f <tracefile>')
  quit(save = "no", status = 2)
}else if(!is.null(opts$file) || !is.null(opts$tracefile)){
    traceFilename <- opts$file
}else{
  print('scriptGetInterarrivalsSummaryStatistics.py -f <tracefile>')
  quit(save = "no", status = 2)
}
if(length(traceFilename) == 0){
  print ('ERROR: Must specify a trace filename.')
  print ('scriptGetInterarrivalsSummaryStatistics.py -f <tracefile>')
  quit(save = "no", status = 1)
}

### Create the interarrival dictionary

interarrival <- hash() # Create a hash empty

### Open the file in read mode, and parse each line to obtain the timestamp,
### the command, and the id.

reader <- read.csv(file = traceFilename, sep = " ", header = FALSE)
for(line in 1:nrow(reader)){
  write(reader[line,1], file = paste(traceFilename,"-IndiceLeido", sep = ""), append = TRUE) # Add file to log
  if(!is.null(interarrival[[as.character(reader[line,3])]])){
    dir.create(paste(traceFilename, "-interarrivals", sep = ""))
    name <- paste(traceFilename, "-interarrivals/it-", reader[line,3], ".txt", sep = "")
    cont <- (reader[line,1] * 1000) - interarrival[[as.character(reader[line,3])]]
    write(cont, file = name, append = TRUE) # Add file to lo
  }
  interarrival[[as.character(reader[line,3])]] <- (reader[line,1] * 1000)
}

### Calculate the summary statistics for each key with more than 2 interarrivals.

print('id mean median mid-range gmean std iqr range mad coeficiente_variacion skewness kurtosis')

for(k in ls(interarrival)){
  t <- interarrival[[k]]
  n <- paste(traceFilename,"-interarrivals/it-",k,".txt",sep = "")
  if(file.exists(n)){
    v <- as.matrix(read.table(n))
    if(nrow(v) > 1){
      cat(paste(k, 
                  mean(v), 
                  median(v), 
                  (max(v)-min(v))/2, 
                  gmean(v),
                  sd(v),
                  quantile(v, .75) - quantile(v, .25),
                  ptp(v),
                  mad(v), 
                  var(v),
                  skewness(v),
                  kurtosis(v), "\n",sep = " "))
    }
  }
}