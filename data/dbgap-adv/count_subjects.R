library(data.table)
library(magrittr)

countSubject <- function(file) {
    filePrefix = gsub(x = file, pattern = "(.+)\\.(\\w+)$",replacement = '\\1', perl = T)
    result1 <- fread(paste0(file))
    result1$SubjectCount <- 
        gsub(x=result1[['Study Content']], pattern = "^.+\\W+(\\d+)\\W+subjects.+$", replacement = '\\1',  perl=TRUE) %>%
        as.numeric()
    fwrite(result1, file = paste0(filePrefix, "-SubjectCounted.tsv"), sep ='\t')
}

# countSubject('dbgap-adv-datasets.tsv')
# countSubject('dbgap-adv-study_97_2019-03-14_2101.csv')
# countSubject('dbgap-adv-study_153_2019-03-14_2052.csv')

