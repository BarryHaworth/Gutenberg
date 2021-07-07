# Get copies of Project Gutenberg files
# Information about catalogs available here:
#  https://www.gutenberg.org/ebooks/offline_catalogs.html 

library(dplyr)
# library(rmutil)
library(data.table)

(PROJECT_DIR <- "c:/R/Gutenberg")
DATA_DIR    <- "c:/R/Gutenberg/data"

local_file <- paste0(DATA_DIR,"/rdf-files-",Sys.Date(),".tar.zip")
print(paste("Local file:",local_file))
remote_file <- "https://www.gutenberg.org/cache/epub/feeds/rdf-files.tar.zip"
print(paste("Remote File:",remote_file))
download.file(remote_file,local_file)

# Unzip the file
unzip(local_file,exdir=DATA_DIR)
# Untar the file.
tar_file <- paste0(DATA_DIR,"/rdf-files.tar")
untar(tar_file,exdir=DATA_DIR)

# Text Files.  These are not very detailed
# download.file("https://www.gutenberg.org/dirs/GUTINDEX.ALL",paste0(DATA_DIR,"/GUTINDEX.ALL")) 
# download.file("https://www.gutenberg.org/dirs/GUTINDEX.AUS",paste0(DATA_DIR,"/GUTINDEX.AUS"))
