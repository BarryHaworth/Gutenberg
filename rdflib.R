# Read the RDF/XML files using rdflib
# Info at https://annakrystalli.me/rdflib-review/index.nb.html#rdflib_-_package_review
# Ideally, want to extract the title, author, subject(s)

library(rdflib)

ls('package:rdflib')
   
PROJECT_DIR <- "c:/R/Gutenberg"
DATA_DIR    <- paste0(PROJECT_DIR,"/data")
RDF_DIR     <- paste0(DATA_DIR,"/cache/epub")

rdf_file <- paste0(RDF_DIR,"/5230/pg5230.rdf")  # The Invisible Man

parse <- rdf_parse(rdf_file)
rdf_serialize(rdf_file,doc=out,format="ntriples")
