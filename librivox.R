# Code to read the Librivox catalog
# Should perhaps for in something other than my Gutenberg repo,
# But for now here it is.
#
# Discussion thread about the Librivox API can be found on this discussion thread:
#
# https://forum.librivox.org/viewtopic.php?f=24&t=44129
#
# The API itself is here:
#  https://librivox.org/api/info

# Get a single book:
# https://librivox.org/api/feed/audiobooks/?id=52

# Default format is xml.  To get JSON:

# https://librivox.org/api/feed/audiobooks/?id=52&format=json
#
# ID currently goes from 52 to 
# https://librivox.org/api/feed/audiobooks/?id=17234

# This code loops through librivox files from 1 to 18000 and saves the results
# as json and xml files.

library(rvest)
library(dplyr)
library(xml2)

PROJECT_DIR <- "c:/R/Gutenberg/"
DATA_DIR    <- paste0(PROJECT_DIR,"data/")
LB_DIR      <- paste0(DATA_DIR,"librivox/")

 
url <- "https://librivox.org/api/feed/audiobooks/?id=52"
local_file <- paste0(LB_DIR,"librivox52.xml")
download.file(url,local_file)
url <- "https://librivox.org/api/feed/audiobooks/?id=52&format=json"
local_file <- paste0(LB_DIR,"librivox52.json")
download.file(url,local_file,quiet=TRUE)

for (i in seq(1,18000)){
  print(paste("Downloading file number",i))
  url_x   <- paste0("https://librivox.org/api/feed/audiobooks/?id=",i)
  local_x <- paste0(LB_DIR,"librivox_",i,".xml")
  url_j   <- paste0("https://librivox.org/api/feed/audiobooks/?id=",i,"&format=json")
  local_j <- paste0(LB_DIR,"librivox_",i,".json")
  tryCatch({
    download.file(url_x,local_x,quiet=TRUE)
    download.file(url_j,local_j,quiet=TRUE)}
    ,error = function(e) print(paste("Librivox file",i,"does not work exist"))
    )
}

