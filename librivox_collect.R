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

# Identify Collections

collect <- librivox %>% filter(author_last_name=="Various") %>% arrange(id)
