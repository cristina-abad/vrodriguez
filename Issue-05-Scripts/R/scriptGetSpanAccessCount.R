args <- commandArgs(trailingOnly = TRUE)  # Get params in terminal
f.filename <- args[1]
if (length(args)==1){
  # delimiter <- if(!is.na(args[2])) args[2] else " "
  if(file.exists(f.filename)){
    f.f1 <- read.table(f.filename, quote="\"", comment.char="", sep = " ", header = F)
    f.f1 <- f.f1[1]                 # Get first column
    f.tmp <- f.f1[2:nrow(f.f1),]    # Get kth row until last row
    print("id span accessCount")
    
    for(i in f.tmp){
      root <- "Animation-traces/it-"
      f2.filename_id <- paste(root, i, ".txt" ,sep = "") # Concatenate root + filename + ext
      f2.file <- read.table(f2.filename_id, quote="\"", comment.char="", sep = " ", header = F)
      f2.interarrivals <- nrow(f2.file)   # Get interarrivals
      f2.accessCount <- interarrivals + 1
      f2.span <- sprintf("%.10f", sum(f2.file))
      cat(sprintf("%d %f %d\n",f2.filename_id, f2.span, f2.accessCount))
    }
  }
}else{
  print("Need 1 parameter")
}


