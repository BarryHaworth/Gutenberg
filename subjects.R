# Analysis of Subjects.
# How many different subjects are there?
# Is there a minimum set of subjects?
# to Check:filenum 64696 has no listed subjects.
# To check: Records with no subjects?

library(dplyr)
library(openxlsx)

PROJECT_DIR <- "c:/R/Gutenberg"
DATA_DIR    <- paste0(PROJECT_DIR,"/data")
read(gutenberg,file=paste0(DATA_DIR,"/gutenberg.RData"))

head(gutenberg$subject_list)

# Expand the subjects

subjects <- data.frame()

for (i in 1:nrow(gutenberg)){
  subject <- gutenberg$subject_list[i][[1]]
  sub_count <- length(subject)
  file = rep(gutenberg$filenum[i],sub_count)
  subject_i <- cbind(file,subject)
  subjects <- rbind(subjects,subject_i)
}

# Counts of subjects

subject_counts <- subjects %>%
  group_by(subject) %>%
  summarise(n=n()) %>%
  arrange(-n)

# Most common subjects
head(subject_counts,20)

save(subjects,file=paste0(DATA_DIR,"/subjects.RData"))
save(subject_counts,file=paste0(DATA_DIR,"/subject_counts.RData"))
write.xlsx(subjects,file=paste0(DATA_DIR,"/subjects.xlsx"))
write.xlsx(subject_counts,file=paste0(DATA_DIR,"/subject_counts.xlsx"))

# Print the other subjects for a specified subject
other_subjects <- function(sub){
  # get all the examples
  print(paste("Checking other subjects with:",sub))
  books_with <- subjects %>% filter(subject==sub) %>% select(file)
  other_sub <- left_join(books_with,subjects,by="file") %>% filter(subject != sub)
  sub_count <- other_sub %>% group_by(subject) %>% summarise(n=n()) %>% arrange(-n)
  print(head(sub_count,n=20))
}

other_subjects("PR")

# Print the top twenty other subjects for the top twenty subjects.
for (sub in head(subject_counts$subject,20)) other_subjects(sub)
