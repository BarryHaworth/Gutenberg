# Create an SF Author flag
# For each book with subjects, calculate the proportion that are SF

library(dplyr)
library(openxlsx)

PROJECT_DIR <- "c:/R/Gutenberg"
DATA_DIR    <- paste0(PROJECT_DIR,"/data")
load(paste0(DATA_DIR,"/gutenberg.RData"))

tail(gutenberg$subject_list)
tail(gutenberg$subject_list)

subjects <- data.frame()

for (i in 1:nrow(gutenberg)){
#  for (i in 1:200){
    subject <- gutenberg$subject_list[i][[1]]
  sub_count <- length(subject)
  file  = gutenberg$filenum[i]
  author = gutenberg$author[i]
  SF_flag = gutenberg$SF_flag[i]
  subject_i <- cbind(file,author,sub_count,SF_flag)
  subjects <- rbind(subjects,subject_i)
}

summary(subjects)
table(subjects$sub_count)
table(subjects$SF_flag)
