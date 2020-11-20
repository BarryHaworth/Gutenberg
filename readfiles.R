# Read files
# Read the Gutenberg RDF files and extract basic information, then save to a data frame
# First go.  Program gets the list of files and loops through them
# Some issues with identifying fields.  Have fields which are usually strings, but sometimes lists.

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
  recs <-  xml_find_all(pg, "//dcterms:title")  #get title
  title <- trimws(xml_text(recs))
  recs3 <-  xml_find_all(pg, "//pgterms:downloads")   #get total downloads
  downloads <- as.numeric(trimws(xml_text(recs3)))
  recs4 <-  xml_find_all(pg, "//dcterms:subject")  # get subject
  val4  <- trimws(xml_text(recs4))
  recs5 <-  xml_find_all(pg, "//pgterms:alias")  # get author
  author <- trimws(xml_text(recs5))
  author <- toString(author)
  recs7 <-  xml_find_all(pg, "//dcterms:language")   # language
  language <- trimws(xml_text(recs7))
  language <- toString(language)
  recs6 <-  xml_find_all(pg, "//dcterms:issued")
  d <- trimws(xml_text(recs6))
  if(d != "None")  date <- as.Date(d)
#  print(paste("reading file number",i,rdf_file,title,"by",author))
  print(paste("reading file number",i,":",title,"by",author))
  if(length(title)>0){
    xmlframe <- data.frame(title, author,filenumber=i, downloads, Subject = I(list(val4)), date, language)
    gutenberg <- rbind(gutenberg,xmlframe)
  }
}

summary(gutenberg$language)
summary(gutenberg$author)
summary(gutenberg$date)
summary(gutenberg$downloads)

hist(gutenberg$downloads)
