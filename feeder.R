# Read the RDF/XML files usinfg feedR

library(feedeR)

PROJECT_DIR <- "c:/R/Gutenberg"
DATA_DIR    <- paste0(PROJECT_DIR,"/data")
RDF_DIR     <- paste0(DATA_DIR,"/cache/epub")

rdf_file <- paste0(RDF_DIR,"/5230/pg5230.rdf")  # The Invisible Man
