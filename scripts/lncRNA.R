library(magrittr)

ldd <- data.table::fread('../data/lncRNAdisease/data_v2017.txt', na.strings = "N/A") %>%
    set_names(c('lncRNA', 'disease', 'association', 'description', 'chr', 'start', 'end', 'strand', 'species', 'other_names', 'ID', 'pmid'))
conditionList <- read.table('../data/conditionList.tsv', sep='\t', header=TRUE)
lnc_cvd <- conditionList$query %>%
    unique() %>%
    lapply(function(query) {
        agrepl(query, x = ldd$disease) %>%
            subset(ldd, .) %>%
            return()
    }) %>%
    set_names(conditionList$query %>% unique()) %>%
    do.call(rbind, .) %>%
    dplyr::distinct()

write.table(lnc_cvd,'../data/lncRNAdisease/lncRNA_CVD.tsv', sep='\t', quote=FALSE,row.names = FALSE)
lnc_cvd$ID %>% unique()
