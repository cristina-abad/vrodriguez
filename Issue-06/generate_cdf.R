args <- commandArgs(trailingOnly = TRUE)
if (length(args)>=1 && length(args)<=2){
  f.name <- args[1]
  delimiter <- if(!is.na(args[2])) args[2] else " "
  if(file.exists(f.name)){
    f.table <- read.table(f.name, quote="\"", comment.char="", sep = delimiter, header = F)
    f.sum <- sum(f.table[2])
    f.relfreq <- f.table[2] / f.sum
    f.cumfreq <- cumsum(f.relfreq)
    for (i in 1:nrow(f.table))
      cat(sprintf("%f %d %f %f\n", f.table[i,1], f.table[i,2], f.relfreq[i,1], f.cumfreq[i,1]))
  }else{
    print("No such file or directory")
  }
}else{
  print("amount of parameters: 2")
  print("usage: generate_sdf.py <inputfile> <delimiter>")
}