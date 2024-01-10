#  Simple regression model for the length of a text against the reading time

library(dplyr)

PROJECT_DIR <- "c:/R/Gutenberg/"
DATA_DIR    <- paste0(PROJECT_DIR,"data/")

# Load the data

load(file=paste0(DATA_DIR,"/lib_gut.RData"))
load(file=paste0(DATA_DIR,"/librivox.RData"))

load(file=paste0(DATA_DIR,"/gutenberg.RData"))

# Combine Gutenberg and Librivox to combine Gutenberg file size with Librivox reading time (seconds)


# Model reading Time as a function of Text size


# Do a plot or two
