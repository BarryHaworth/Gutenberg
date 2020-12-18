# Read files
# Read the Gutenberg RDF files and extract basic information, then save to a data frame
# First go.  Program gets the list of files and loops through them
# Some issues with identifying fields.  Have fields which are usually strings, but sometimes lists.
# Size and Format still need some work.

# Setup

library(xml2)

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
for(i in filenum[1:1000]){
  rdf_file <- paste0(RDF_DIR,"/",i,"/pg",i,".rdf")  
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
  sizes <- trimws(xml_text(xml_find_all(pg, "//dcterms:extent")))   # File Sizes
  size  <- as.numeric(size[1])
  formats <- trimws(xml_text(xml_find_all(pg, "//dcterms:format"))) # File formats
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
                           size)
    gutenberg <- rbind(gutenberg,xmlframe)
  }
}

summary(gutenberg$language)
summary(gutenberg$author)
summary(gutenberg$date)
summary(gutenberg$downloads)
summary(gutenberg$size)

hist(gutenberg$downloads)
