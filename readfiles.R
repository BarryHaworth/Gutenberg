# Read files
# Read the Gutenberg RDF files and extract basic information, then save to a data frame

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

for(i in filenum[1:100]){
  rdf_file <- paste0(RDF_DIR,"/",i,"/pg",i,".rdf")  
  print(paste("reading file number",i," ",rdf_file))
  pg <- read_xml(rdf_file)
}
