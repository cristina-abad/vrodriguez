#### Add libraries neccesaries
for (package in c('data.table')) {
  if (!require(package, character.only=T, quietly=T, warn.conflicts = F)) {
    install.packages(package)
    library(package, character.only=T, quietly = T, warn.conflicts = F)
  }
}

args <- commandArgs(trailingOnly = TRUE)  # Get params in terminal
f.filename <- args[1]
f.filenameDataSet <- paste(args[1], "-dataset", sep = "")

f.tmp <- fread(input = f.filenameDataSet, sep = " ", header = TRUE)

cat("id span accessCount\n")

mapply(function(id){
  f2.filename_id <- paste(f.filename, "-interarrivals/it-", id, ".txt", sep = "")
  f2.file <- fread(input = f2.filename_id)
  f2.interarrivals <- nrow(f2.file)   # Get interarrivals
  f2.accessCount <- f2.interarrivals + 1
  f2.span <- sprintf("%.10f", sum(f2.file))
  cat(sprintf("%s %s %s\n", id, f2.span, f2.accessCount))
}, f.tmp$id)