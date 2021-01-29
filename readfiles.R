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


# Setup

library(xml2)
library(dplyr)

PROJECT_DIR <- "c:/R/Gutenberg"
DATA_DIR    <- paste0(PROJECT_DIR,"/data")
RDF_DIR     <- paste0(DATA_DIR,"/cache/epub")

# Get the list of files and convert to numbers
filelist <- list.files(path= RDF_DIR)
filenum <- as.numeric(filelist)
filenum=sort(na.omit(filenum))
summary(filenum)
head(filenum)
tail(filenum)

# Loop through list and extract the book information

gutenberg = data.frame()

#for(i in filenum){
#for(i in tail(filenum,20)){
for(i in filenum[1:179]){
  rdf_file <- paste0(RDF_DIR,"/",i,"/pg",i,".rdf")  
  print(paste("reading file",rdf_file))
  pg <- read_xml(rdf_file)
  title <- trimws(xml_text(xml_find_all(pg, "//dcterms:title")))     # get title
  downloads <- as.numeric(trimws(xml_text(xml_find_all(pg, "//pgterms:downloads"))))  #get total downloads
  subjects  <- trimws(xml_text(xml_find_all(pg, "//dcterms:subject")))  # get subject
  author <- trimws(xml_text(xml_find_all(pg, "//pgterms:name")))       # Author Name
  author <- toString(author)
  author_alias <- trimws(xml_text(xml_find_all(pg, "//pgterms:alias")))       # Author
  author_alias <- toString(author_alias)
  language <- trimws(xml_text(xml_find_all(pg, "//dcterms:language")))  # language
  language <- toString(language)
  d <- trimws(xml_text(xml_find_all(pg, "//dcterms:issued")))           # Date Issued
  if(d != "None")  date <- as.Date(d)
  files <- trimws(xml_text(xml_find_all(pg, "//pgterms:file")))   # All the File details
  sizes <- trimws(xml_text(xml_find_all(pg, "//dcterms:extent")))   # All the File Sizes
  formats <- trimws(xml_text(xml_find_all(pg, "//dcterms:format"))) # All the File formats
  size  <- as.numeric(sizes[match("text/plain",formats)])            # Size of the Text file
  if(is.na(size)) size  <- as.numeric(sizes[match("text/plain; charset=us-ascii",formats)]) # Size of the Text file
  if(is.na(size)) size  <- as.numeric(sizes[match("text/plain; charset=utf-8",formats)])    # Size of the Text file
  if(is.na(size)) size  <- as.numeric(sizes[match("text/html",formats)])                    # Size of the Text file
  if(is.na(size)) size  <- as.numeric(sizes[match("text/plain; charset=iso-8859-1",formats)])                    # Size of the Text file
  
  language <- toString(language)
#  print(paste("reading file number",i,":",title,"by",author))
  if(length(title)>0){
    xmlframe <- data.frame(title, 
                           author,
                           author_alias,
                           filenumber=i, 
                           downloads, 
                           subject_list = I(list(subjects)), 
                           date, 
                           language, 
                           files = I(list(files)),
                           sizes = I(list(sizes)),
                           formats = I(list(formats)),
                           size)
    gutenberg <- rbind(gutenberg,xmlframe)
  }
}

gutenberg$year <- as.numeric(format(gutenberg$date,"%Y"))

summary(gutenberg$language)
#summary(gutenberg$author)
summary(gutenberg$date)
summary(gutenberg$year)
summary(gutenberg$downloads)
summary(gutenberg$size)

hist(gutenberg$downloads)
hist(gutenberg$year,breaks = max(gutenberg$year)-min(gutenberg$year))

# Maximum downloads?
print("Downloaded Most Often")
tail(arrange(gutenberg[,c("title","author","downloads","date")],downloads),10)

# File formats for missing sizes?
gutenberg[,'formats'][is.na(gutenberg$size)]
print("Files with NA size")
gutenberg[is.na(gutenberg$size),c('filenumber','title')]  

# Check number of sizes, number of formats

gutenberg$sizes.n   <- 0
gutenberg$formats.n <- 0

for(i in seq(1:length(gutenberg))){
  gutenberg$sizes.n[i] <- length(gutenberg$sizes[[i]])
  gutenberg$formats.n[i] <- length(gutenberg$formats[[i]])
}

# Number of sizes does not line up with number of formats.  Something weird is happening when the files are read.