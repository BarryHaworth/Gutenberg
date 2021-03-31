# Scratch Code for Checking

sizecheck <- function(num){
  files <- gutenberg$files[gutenberg$filenumber==num][[1]]
  sizes <- gutenberg$sizes[gutenberg$filenumber==num][[1]]
  filesize <- cbind(files,sizes)
  return(filesize)
}

sizecheck(64596)
gutenberg$size[gutenberg$filenumber==64596]
