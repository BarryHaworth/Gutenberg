# Read Files
# Project Gutenberg catalogs RDF files.

# Using code from 
# https://cran.r-project.org/web/packages/rdflib/vignettes/rdf_intro.html

library(rdflib)
library(dplyr)
library(tidyr)
library(tibble)

rdf <- rdf()

PROJECT_DIR <- "c:/R/Gutenberg"
DATA_DIR    <- "c:/R/Gutenberg/data"

local_file <- paste0(DATA_DIR,"/cache/epub/5230/pg5230.rdf")  # The Invisible Man

system.file(local_file, package="redland") %>%
  rdf_parse() 
