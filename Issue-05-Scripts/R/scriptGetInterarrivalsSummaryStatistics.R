#### Add libraries neccesaries
for (package in c('data.table', 'getopt', 'hash', 'moments')) {
  if (!require(package, character.only=T, quietly=T, warn.conflicts = F)) {
    install.packages(package)
    library(package, character.only=T, quietly = T, warn.conflicts = F)
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
opts = getopt(spec, args)

if(!is.null(opts$help)){
  print('scriptGetInterarrivalsSummaryStatistics.R -f <tracefile>')
  quit(save = "no", status = 2)
}else if(!is.null(opts$file) || !is.null(opts$tracefile)){
    traceFilename <- opts$file
}else{
  print('scriptGetInterarrivalsSummaryStatistics.R -f <tracefile>')
  quit(save = "no", status = 2)
}
if(length(traceFilename) == 0){
  print ('ERROR: Must specify a trace filename.')
  print ('scriptGetInterarrivalsSummaryStatistics.R -f <tracefile>')
  quit(save = "no", status = 1)
}

### Create the interarrival dictionary

interarrival <- hash::hash() # Create a hash empty

### Open the file in read mode, and parse each line to obtain the timestamp,
### the command, and the id.

reader <- fread(input = traceFilename,  sep = " ", header = FALSE)

mapply(function(id, n){
  write(id, 
        file = paste(traceFilename,"-IndiceLeido", sep = ""), 
        append = TRUE) # Add file to log
  if(!is.null(interarrival[[ n ]])){
    #dir.create(paste(traceFilename, "-interarrivals", sep = ""))
    name <- paste(traceFilename, 
                  "-interarrivals/it-", 
                  n, ".txt", sep = "")
    cont <- (id * 1000) - interarrival[[ n ]]
    write(cont, file = name, append = TRUE) # Add file to lo
    }
    interarrival[[ n ]] <- ( id * 1000)
}, reader$V1, reader$V3)

### Calculate the summary statistics for each key with more than 2 interarrivals.

cat('id mean median mid-range gmean std iqr range mad coeficiente_variacion skewness kurtosis')

for(k in ls(interarrival)){
  t <- interarrival[[k]]
  n <- paste(traceFilename,"-interarrivals/it-",k,".txt",sep = "")
  if(file.exists(n)){
    v <- as.matrix(read.table(n))
    if(nrow(v) > 1){
      sk <- skewness(v)
      ku <- kurtosis(v)
      if(is.nan(sk) || is.nan(ku)){
        write(k, file = "NaN_interarrivals.txt", append = TRUE)
      }else{
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
                    sk,
                    ku, "\n",sep = " "))
      }
    }
  }
}
