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
DATA_DIR    <- paste0(PROJECT_DIR,"/data")
RDF_DIR     <- paste0(DATA_DIR,"cache/epub")

rdf_file <- paste0(RDF_DIR,"/5230/pg5230.rdf")  # The Invisible Man

system.file(rdf_file, package="redland") %>%
  rdf_parse() 
