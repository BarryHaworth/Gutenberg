# Code to read the Librivox Collections

# This code Identifies the different Librivox collections
# and then rips them to identify individual sections and their details
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

collect <- librivox %>% filter(author_last_name=="Various",
                               url_text_source=="",
                               totaltimesecs >0) %>% arrange(id)

# How many by type?
table(gsub("\\s*\\w*$", "", collect$title)) %>% sort()

summary <- collect %>% mutate(collection = gsub("\\s*\\w*$", "", title)) %>%
                   group_by(collection) %>% summarise(collections=n(), stories=sum(num_sections),time=sum(totaltimesecs/3600))

# Rip contents of collections
head(collect[c('id','title','url_librivox')])

url <- collect$url_librivox[1]  #First Ghost story collection.  Contains Gutenberg links

# Using https://www.storybench.org/scraping-html-tables-and-downloading-files-with-r/

rip_url <- function(url){
  webpage <- read_html(url)

  chapters <- rvest::html_table(webpage)[[1]] %>% 
    tibble::as_tibble(.name_repair = "unique") %>%
    select(-c("Section","Source"))
  chapters
  
  links <- webpage %>%
    html_nodes(".chapter-download") %>%
    html_nodes("a") 
  
  text_links <- links[grepl("Etext",links)] %>% html_attr("href")
  text_links
    
  chapters$url_text_source <- text_links
  
  return(chapters)
}


