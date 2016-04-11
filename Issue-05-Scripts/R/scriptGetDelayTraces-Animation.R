#### Add libraries neccesaries
for (package in c('getopt', 'hash', 'moments')) {
  if (!require(package, character.only=T, quietly=T)) {
    install.packages(package)
    library(package, character.only=T)
  }
}

### Main program
traceFilename <- ""
spec <- t(matrix(c('help', 'h', 0, "logical",
                   'file', 'f', 1, "character",
                   'tracefile', 't', 2, "character"),nrow=4, ncol=3))
argv <- commandArgs(trailingOnly = TRUE)
opts = getopt(spec, argv)
if(!is.null(opts$help)){
  print('scriptParseYoutubeTraces.m -f <tracefile>')
  quit(save = "no", status = 2)
}else if(!is.null(opts$tracefile)){
  traceFilename <- opts$file
}else{
  print('scriptParseYoutubeTraces.m -f <tracefile>')
  quit(save = "no", status = 2)
}
if(length(traceFilename) == 0){
  print ('ERROR: Must specify a trace filename.')
  print ('scriptParseYoutubeTraces.py -f <tracefile>')
  quit(save = "no", status = 1)
}

### Get the first line to get the starting point
reader <- read.csv(file = traceFilename, sep = " ", header = FALSE)
row1 <- reader[1,]
zero <- row1[1]

### Create the interarrival dictionary
interarrival <- hash() # Create a hash empty
reader <- read.csv(file = traceFilename, sep = " ", header = FALSE)
for(i in 1:nrow(reader)){
  line <- reader[i,] 
  write(line[3], file = "Animation-IndiceLeido-DELAY.txt", append = TRUE) # Add file to log
  if(is.null(interarrival[[as.character(line[3])]])){
    interarrival[[as.character(line[3])]] <- line[1]
    cont <- paste(line[3],' ',line[1]-zero,'\n', sep = "")
    write(cont, file = "Animation-traces-delays.txt", append = TRUE) # Add file to log
  }
}