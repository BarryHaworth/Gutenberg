# Read files
# Read the Gutenberg RDF files and extract basic information, then save to a data frame
# First go.  Program gets the list of files and loops through them
# Some issues with identifying fields.  Have fields which are usually strings, but sometimes lists.
# Size and Format still need some work.

# Update 18/12/2020
# Changed the Author field
# Defined year (of release on Gutenberg) from Date

# Size and File Type?
# Not always getting the right size.  Problem when number of sizes and number of formats do not align

# Still have problems with reading the full list (only get 6300 or so)

# 30/03/2021
# file has /pgterms, /dcterms (project Gutenberg, Document terms?)
#  Trying to line up sizes (dcterm:extent) with file types (dcterm:format)
#  These appear to be nested under file (pgterms:file) <- DONE

# 01/04/2021
# Added an Audio flag for audiobooks and set their size to 0.

# Setup

library(xml2)
library(dplyr)
library(openxlsx)

PROJECT_DIR <- "c:/R/Gutenberg"
DATA_DIR    <- paste0(PROJECT_DIR,"/data")
RDF_DIR     <- paste0(DATA_DIR,"/cache/epub")  # Old directory.  New again
# RDF_DIR     <- paste0(DATA_DIR,"/export/sunsite/users/gutenbackend/cache/epub")

# Get the list of files and convert to numbers
filelist <- list.files(path= RDF_DIR)
filenum <- as.numeric(filelist)
filenum=sort(na.omit(filenum))
filenum <- filenum[1:length(filenum)-1]  # Drop the last filenum, which is a dud.
summary(filenum)
head(filenum)
tail(filenum)

# Loop through list and extract the book information

gutenberg = data.frame()

for(i in filenum){
  # for(i in tail(filenum,20)){  # the last 20
  # for(i in filenum[8650:8760]){    # Selected range
  rdf_file <- paste0(RDF_DIR,"/",i,"/pg",i,".rdf")  
  print(paste("reading file",rdf_file))
  pg <- read_xml(rdf_file)
  # xml_structure(pg)
  title <- trimws(xml_text(xml_find_all(pg, "//dcterms:title")))[1]                  # get (first) title
  title <- toString(title) 
  downloads <- as.numeric(trimws(xml_text(xml_find_all(pg, "//pgterms:downloads")))) # get total downloads
  subjects  <- trimws(xml_text(xml_find_all(pg, "//dcterms:subject")))               # get subjects
  author <- trimws(xml_text(xml_find_all(pg, "//pgterms:name")))                     # Author Name
  author <- toString(author)
  author_alias <- trimws(xml_text(xml_find_all(pg, "//pgterms:alias")))              # Author Alias
  author_alias <- toString(author_alias)
  language <- trimws(xml_text(xml_find_all(pg, "//dcterms:language")))               # language
  language <- toString(language)
  d <- trimws(xml_text(xml_find_all(pg, "//dcterms:issued")))                        # Date Issued
  if(d != "None")  date <- as.Date(d)
  files <- trimws(xml_text(xml_find_all(pg, "//pgterms:file")))                      # All the File details
  sizes <- trimws(xml_text(xml_find_all(pg, "//dcterms:extent")))                    # All the File Sizes
  size  <- as.numeric(sizes[grepl("text/plain",files)&!grepl("zip",files)][1])  # Size of the first text/plain which isn't a zip
  SF_flag <- sum(grepl("Science fiction",subjects))  # Science Fiction flag
  Audio_flag <- max(grepl("audio/mpeg",files))
  if (Audio_flag){
    audio_flag <- 1
    size <-0 
  } 
  language <- toString(language)
  #  print(paste("reading file number",i,":",title,"by",author))
  if(length(title)>0){
    xmlframe <- data.frame(title, 
                           author,
                           author_alias,
                           filenumber=i, 
                           downloads, 
                           subject_list = I(list(subjects)), 
                           SF_flag,
                           Audio_flag,
                           date, 
                           language, 
                           files = I(list(files)),
                           sizes = I(list(sizes)),
                           size = I(size),
                           link=paste0("https://www.gutenberg.org/ebooks/",i))
    gutenberg <- rbind(gutenberg,xmlframe)
  }
}

gutenberg$size <- as.numeric(gutenberg$size)
gutenberg$year <- as.numeric(format(gutenberg$date,"%Y"))

summary(gutenberg$language)
summary(gutenberg$date)
summary(gutenberg$year)
summary(gutenberg$downloads)
summary(gutenberg$size)

hist(gutenberg$downloads)
hist(gutenberg$year,breaks = max(gutenberg$year)-min(gutenberg$year))

# Maximum downloads?
print("Downloaded Most Often")
tail(arrange(gutenberg[,c("title","author","downloads","date")],downloads),20)

print("Files with NA size")
gutenberg[is.na(gutenberg$size),c('filenumber','title')]  

save(gutenberg,file=paste0(DATA_DIR,"/gutenberg.RData"))
# Need to tidy up the export to XLS to capture subject - cannot export lists as columns in Excel
write.xlsx(gutenberg %>% 
             select(c("title","author","author_alias","filenumber","downloads","date","language",
                      "size","year","SF_flag","Audio_flag","link")),
           paste0(DATA_DIR,"/gutenberg.xlsx"))
