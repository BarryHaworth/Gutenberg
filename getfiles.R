# Get copies of Project Gutenberg files

library(dplyr)
library(rmutil)
library(data.table)

PROJECT_DIR <- "c:/R/Gutenberg"
DATA_DIR    <- "c:/R/Gutenberg/data"

local_file <- paste0(DATA_DIR,"/rdf-files.tar.zip")
print(paste("Local file:",local_file))
remote_file <- "https://www.gutenberg.org/cache/epub/feeds/rdf-files.tar.zip"
print(paste("Remote File:",remote_file))
download.file(remote_file,local_file)

# download.file("https://www.gutenberg.org/dirs/GUTINDEX.ALL",paste0(DATA_DIR,"/GUTINDEX.ALL")) # Text files.
# download.file("https://www.gutenberg.org/dirs/GUTINDEX.AUS",paste0(DATA_DIR,"/GUTINDEX.AUS"))
