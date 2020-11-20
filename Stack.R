# This is a test file for reading the Gutenberg RDF files, based on code provided in:
# From https://stackoverflow.com/questions/51503833/read-multiple-xml-files-cleanup-and-merge-with-existing-dataframe-in-r-studio=
# Next step is to generalise this to loop through the whole file list

library(xml2)

PROJECT_DIR <- "c:/R/Gutenberg"
DATA_DIR    <- paste0(PROJECT_DIR,"/data")
RDF_DIR     <- paste0(DATA_DIR,"/cache/epub")

rdf_file <- paste0(RDF_DIR,"/5230/pg5230.rdf")  # The Invisible Man

pg <- read_xml(rdf_file)

#get title
recs <-  xml_find_all(pg, "//dcterms:title")
vals <- trimws(xml_text(recs))

#get file number, though this needs cleaning
recs2 <-  xml_find_all(pg, "//pgterms:ebook/@rdf:about")
vals2 <- gsub("ebooks/", "", trimws(xml_text(recs2)))

#get total downloads
recs3 <-  xml_find_all(pg, "//pgterms:downloads")
vals3 <- trimws(xml_text(recs3))

# get subject
#recs4 <-  xml_find_all(pg, "//rdf:value")
recs4 <-  xml_find_all(pg, "//dcterms:subject")
vals4 <- trimws(xml_text(recs4))

# get author
recs5 <-  xml_find_all(pg, "//pgterms:alias")
vals5 <- trimws(xml_text(recs5))

# language
recs7 <-  xml_find_all(pg, "//dcterms:language")
vals7 <- trimws(xml_text(recs7))

# File name  pgterms:file

recs6 <-  xml_find_all(pg, "//dcterms:issued")
vals6 <- trimws(xml_text(recs6))


xmlframe <- data.frame(Title=vals, 
                       Author = vals5,
                       Filenumber=vals2, 
                       Downloads=vals3,
                       Subject = I(list(vals4)),
                       Date = vals6,
                       Language = vals7
                       )

xmlframe
