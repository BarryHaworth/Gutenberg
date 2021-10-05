# Librivox Collections
# Short Science Fiction Collections
# https://librivox.org/short-science-fiction-collection-vol-001-by-various/
# These currently go from number 1 to number 81.

library(rvest)
library(dplyr)
library(xml2)

PROJECT_DIR <- "c:/R/Gutenberg"
DATA_DIR    <- "c:/R/Gutenberg/data"

url <- "https://librivox.org/short-science-fiction-collection-vol-001-by-various/"

webpage <- read_html(url)
details <- xml_attrs(html_nodes(webpage,'td:nth-child(3) , a'))
