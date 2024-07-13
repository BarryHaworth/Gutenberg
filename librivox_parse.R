# Parse the Librivox files

library(dplyr)
library(XML)
library(openxlsx)

PROJECT_DIR <- "c:/R/Gutenberg/"
DATA_DIR    <- paste0(PROJECT_DIR,"data/")
LB_DIR      <- paste0(DATA_DIR,"librivox/")

file.path(LB_DIR)

# Load the previous database and create if not present.
if (file.exists(paste0(DATA_DIR,"/librivox.RData"))){
  load(paste0(DATA_DIR,"/librivox.RData"))
} else librivox = data.frame()

# Get a list of files
lb_list <- dir(LB_DIR)
lb_xml  <- lb_list[grepl("xml",lb_list)]

# Parse the results

#i=3
#for (i in seq(1,10)){
for (i in seq(1,length(lb_xml))){
  data <- xmlParse(paste0(LB_DIR,lb_xml[i]))
  xml_data <- xmlToList(data)[[1]]$book
  
  id              <- as.numeric(xml_data$id)
  title           <- toString(xml_data$title)
  description     <- toString(xml_data$description)
  language        <- toString(xml_data$language)
  copyright_year  <- max(0,as.numeric(xml_data$copyright_year))
  num_sections    <- max(0,as.numeric(xml_data$num_sections))
  url_librivox    <- toString(xml_data$url_librivox)
  url_text_source <- toString(xml_data$url_text_source)
  url_zip_file    <- toString(xml_data$url_zip_file)
  url_rss         <- toString(xml_data$url_rss)
  url_project     <- toString(xml_data$url_project)
  url_other       <- toString(xml_data$url_other)
  totaltime       <- toString(xml_data$totaltime)
  totaltimesecs   <- max(0,as.numeric(xml_data$totaltimesecs))
  author_id         <- max(0,as.numeric(xml_data$authors[1]$author$id))
  author_first_name <- toString(xml_data$authors[1]$author$first_name)
  author_last_name  <- toString(xml_data$authors[1]$author$last_name)
  author_dob        <- max(0,as.numeric(xml_data$authors[1]$author$dob))
  author_dod        <- max(0,as.numeric(xml_data$authors[1]$author$dod))
  
  print(paste("Book:",i,"ID:",id,title,"by",author_first_name,author_last_name))
  
  book=data.frame(id,title,description,language,copyright_year,num_sections,
                  url_librivox,url_text_source,url_zip_file,url_rss,url_project,url_other,
                  totaltime,totaltimesecs,
                  author_id,author_first_name,author_last_name,author_dob,author_dod,
                  stringsAsFactors = FALSE)
  
  librivox <- rbind(librivox,book)
}

librivox <- librivox %>% unique() %>% arrange(id)

save(librivox,file=paste0(DATA_DIR,"/librivox.RData"))
write.xlsx(librivox,file=paste0(DATA_DIR,"/librivox.xlsx"))
