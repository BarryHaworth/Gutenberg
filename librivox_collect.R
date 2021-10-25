# Code to read the Librivox Collections

# This code Identifies the different Librivox collections
# and then rips them to identify individual sections and tieir details
# Title, Author, url_text_source, length


library(rvest)
library(dplyr)
library(xml2)

PROJECT_DIR <- "c:/R/Gutenberg/"
DATA_DIR    <- paste0(PROJECT_DIR,"data/")
LB_DIR      <- paste0(DATA_DIR,"librivox/")

load(paste0(DATA_DIR,"/librivox.RData"))  # Load the data

# Identify Collections:
# Author=Various, no text source given.

collect <- librivox %>% filter(author_last_name=="Various",url_text_source=="") %>% arrange(id)

# How many by type?
table(gsub("\\s*\\w*$", "", collect$title)) %>% sort()

summary <- collect %>% mutate(collection = gsub("\\s*\\w*$", "", title)) %>%
                   group_by(collection) %>% summarise(collections=n(), stories=sum(num_sections),time=sum(totaltimesecs/3600))
