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
# ID currently goes from 47 to 17234 (as at 23/10/2021)
# ID = 20726 as at 07/07/2024

# This code loops through librivox files from 1 to 18000 and saves the results
# as  xml files. (Decided not to use json)

# Issue with collections.  Details of individual chapters are not given.
#  Using "&extended=1" lists the individual title, language and playtime, but not author and link

library(rvest)
library(dplyr)
library(xml2)

PROJECT_DIR <- "c:/R/Gutenberg/"
DATA_DIR    <- paste0(PROJECT_DIR,"data/")
LB_DIR      <- paste0(DATA_DIR,"librivox/")
dir.create(file.path(LB_DIR))

# For testing
url <- "https://librivox.org/api/feed/audiobooks/?id=52"
url <- "https://librivox.org/api/feed/audiobooks/?id=1555?extended=1"
#local_file <- paste0(LB_DIR,"librivox52.xml")
#local_file <- paste0(LB_DIR,"librivox.xml")
#download.file(url,local_file)

# Set the start and end points.  
# If previously run, set end point at highest value + 1000
if (file.exists(paste0(DATA_DIR,"/librivox.RData"))){
  load(paste0(DATA_DIR,"/librivox.RData"))
  end <- max(librivox$id)+250
} else end <- 21000

# Identify incomplete projects (files with duration of zero seconds)
if (exists("librivox")){
  incomplete <- librivox %>% filter(totaltimesecs==0) %>% select(id,title)
  # Retrieve the incomplete files
  for (i in incomplete$id){
    url_x   <- paste0("https://librivox.org/api/feed/audiobooks/?id=",i)
    local_x <- paste0(LB_DIR,"librivox_",i,".xml")
    print(paste("Updating incomplete file number",i))
    tryCatch({
      download.file(url_x,local_x,quiet=TRUE)
    }
    ,error = function(e) print(paste("Librivox file",i,"does not exist"))
    )
  }
}

# Retrieve the other files
for (i in seq(47,end)){
  url_x   <- paste0("https://librivox.org/api/feed/audiobooks/?id=",i)
  local_x <- paste0(LB_DIR,"librivox_",i,".xml")
  if (!file.exists(local_x)){
    print(paste("Downloading file number",i))
    tryCatch({
      download.file(url_x,local_x,quiet=TRUE)
      }
      ,error = function(e) print(paste("Librivox file",i,"does not exist"))
    )
  } else {print(paste(local_x,"already exists"))}
}

