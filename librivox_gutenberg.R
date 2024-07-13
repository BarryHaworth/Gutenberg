# Make a list of the Project Gutenberg texts that have 
# been included in Librivox projects

library(dplyr)

PROJECT_DIR <- "c:/R/Gutenberg/"
DATA_DIR    <- paste0(PROJECT_DIR,"data/")

load(paste0(DATA_DIR,"/librivox.RData"))  # Load the Librivox data
load(paste0(DATA_DIR,"/sections.RData"))  # Load the Librivox sections data
load(paste0(DATA_DIR,"/gutenberg.RData"))  # Load the Gutenberg data

# Extract the URLS and filter for Gutenberg
lib_url  <- librivox %>% 
  mutate(Author=paste(author_first_name,author_last_name)) %>%
  select(id,title,Author,copyright_year,url_text_source,totaltimesecs) %>% 
  filter(grepl("www.gutenberg.org",url_text_source))

sect_url <- sections %>% 
  select(id,title,Author,copyright_year,url_text_source,totaltimesecs) %>% 
#  rename(title=Chapter) %>%
  filter(grepl("www.gutenberg.org",url_text_source))

lib_gut <- rbind(lib_url,sect_url) %>% unique() %>% arrange(url_text_source)

# Identify the Gutenberg file number
#  - Split URL into parts
#  - find www.gutenberg.org
#  - take the third field after.

lib_gut$filenumber <- 0

for (i in seq(1:nrow(lib_gut))){
  lib_gut$filenumber[i] <- as.numeric(strsplit(strsplit(lib_gut$url_text_source[i],"www.gutenberg.org/")[[1]][2],"/")[[1]][2])
  if(is.na(lib_gut$filenumber[i])){
    lib_gut$filenumber[i] <- as.numeric(strsplit(strsplit(lib_gut$url_text_source[i],"cache/")[[1]][2],"/")[[1]][2])
  }
}

# Filter out unknown numbers

lib_gut <- lib_gut %>% filter(!is.na(filenumber)) %>% arrange(filenumber)

save(lib_gut,file=paste0(DATA_DIR,"/lib_gut.RData"))

