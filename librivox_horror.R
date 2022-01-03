# Code to read the Librivox Collections
# 
# Adapted from the librivox_horror program
#
# This code Identifies the different Librivox collections
# and identifies collects of horror and ghost stories
# which it then downloads


library(rvest)
library(dplyr)
library(xml2)

PROJECT_DIR <- "c:/R/Gutenberg/"
DATA_DIR    <- paste0(PROJECT_DIR,"data/")
LB_DIR      <- paste0(DATA_DIR,"librivox/zip/")

load(paste0(DATA_DIR,"/librivox.RData"))  # Load the data

# Identify Collections:
# Author=Various, no text source given.

collect <- librivox %>% filter(author_last_name=="Various",url_text_source=="") %>% arrange(id)

# How many by type?
table(gsub("\\s*\\w*$", "", collect$title)) %>% sort()

summary <- collect %>% mutate(collection = gsub("\\s*\\w*$", "", title)) %>%
                   group_by(collection) %>% summarise(collections=n(), stories=sum(num_sections),time=sum(totaltimesecs/3600))

# Download Ghost and Horror

horror <- collect[grepl("Horror",collect$title),]
ghost  <- collect[grepl("Ghost",collect$title),]

gh <- rbind(ghost,horror) %>% select("url_zip_file") %>% filter(url_zip_file != "") %>% unique() %>% arrange()

# Download the Ghost & Horror stories
for (i in 1:nrow(gh)){
  filename=tail(strsplit(gh$url_zip_file[i],"/")[[1]],1)
  if (!file.exists(paste0(LB_DIR,filename))){
    print(paste("Number",i,"Downloading file",filename))
    download.file(gh$url_zip_file[i],paste0(LB_DIR,filename))
  } else {
    print(paste("Number",i,filename,"--- File Already Exists"))
  }
}
