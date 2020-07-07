# REad rdf, using code taken from:
#  https://rdrr.io/cran/RWDataPlyr/man/read.rdf.html

#  Seems to work alright with the test data, but not with the Gutenberg files.

PROJECT_DIR <- "c:/R/Gutenberg"
DATA_DIR    <- "c:/R/Gutenberg/data"

local_file <- paste0(DATA_DIR,"/cache/epub/5230/pg5230.rdf")  # The Invisible Man

library(RWDataPlyr)

zz <- read_rdf(local_file)


zz <- read_rdf(system.file(local_file,   package = "RWDataPlyr"))

zz <- read_rdf(system.file(
  'extdata/Scenario/ISM1988_2014,2007Dems,IG,Most', 
  "KeySlots.rdf", 
  package = "RWDataPlyr"
))