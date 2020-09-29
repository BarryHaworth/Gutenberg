# REad rdf, using code taken from:
#  https://rdrr.io/cran/RWDataPlyr/man/read.rdf.html

#  Seems to work alright with the test data, but not with the Gutenberg files.
# The Gutenberg files do not appear to be plain RDF, but to be RDF/XML.

PROJECT_DIR <- "c:/R/Gutenberg"
DATA_DIR    <- paste0(PROJECT_DIR,"/data")
RDF_DIR     <- paste0(DATA_DIR,"/cache/epub")

rdf_file <- paste0(RDF_DIR,"/5230/pg5230.rdf")  # The Invisible Man

library(RWDataPlyr)

zz <- read_rdf(system.file('extdata/Scenario/ISM1988_2014,2007Dems,IG,Most', 
                          "KeySlots.rdf", package = "RWDataPlyr"))  # test file

zz <- read_rdf(rdf_file)

zz <- read_rdf(system.file(rdf_file,   package = "RWDataPlyr"))

