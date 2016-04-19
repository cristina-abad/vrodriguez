#### Add libraries neccesaries
for (package in c('data.table', 'getopt', 'hash')) {
  if (!require(package, character.only=T, quietly=T, warn.conflicts = F)) {
    install.packages(package)
    library(package, character.only=T, quietly = T, warn.conflicts = F)
  }
}

### Main program
traceFilename <- ""
spec <- t(matrix(c('help', 'h', 0, "logical",
                   'file', 'f', 1, "character",
                   'tracefile', 't', 2, "character"),nrow=4, ncol=3))
args <- commandArgs(trailingOnly = TRUE)
opts = getopt(spec, args)
if(!is.null(opts$help)){
  print('scriptGetDelayTraces.R -f <tracefile>')
  quit(save = "no", status = 2)
}else if(!is.null(opts$file) || !is.null(opts$tracefile)){
  traceFilename <- opts$file
}else{
  print('scriptGetDelayTraces.R -f <tracefile>')
  quit(save = "no", status = 2)
}
if(length(traceFilename) == 0){
  print ('ERROR: Must specify a trace filename.')
  print ('scriptGetDelayTraces.R -f <tracefile>')
  quit(save = "no", status = 1)
}

### Get the first line to get the starting point
reader <- fread(input = traceFilename,  sep = " ", header = FALSE, dec = ".",
                colClasses = c("string", "string", "string"))
zero <- as.numeric(reader$V1[1])

### Create the interarrival dictionary
interarrival <- hash::hash() # Create a hash empty

invisible(mapply(function(id, n){
    write(n, 
          file = paste(traceFilename, "-delays-IndiceLeido", sep = ""), 
          append = TRUE) # Add file to log
  id <- as.numeric(id)
  if(is.null(interarrival[[ n ]])){
    interarrival[[ n ]] <- id
    cont <- paste(n,' ', (id-zero) * 1000, sep = "")
    write(cont, 
          file = paste(traceFilename,"-delays", sep = ""), 
          append = TRUE) # Add file to log
  }
},reader$V1,reader$V3))
