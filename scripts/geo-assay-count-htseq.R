library(RSQLite)
library(magrittr)
library(ggplot2)
library(dplyr)
library(tidyr)
devtools::load_all('../')

con <- dbConnect(SQLite(), '../data/GEOmetadb.sqlite')
pmids_by_query <- readRDS('../data/pmids_by_query.RDS')
assay_cardio_htseq <- dbGetQuery(con, paste('SELECT gsm.gsm, gsm.source_name_ch1, gsm.organism_ch1, organism_ch2, gpl.gpl, gpl.title as platform, gpl.description as platform_description, technology, gse.gse, gse.submission_date, gse.pubmed_id, gse.title, gse.summary, gse.type as study_type, gsm.type as sample_type, gsm.molecule_ch1',
                                    'FROM gse ',
                                    'JOIN gse_gsm ON gse.gse = gse_gsm.gse',
                                    'JOIN gse_gpl ON gse.gse = gse_gpl.gse',
                                    'JOIN gsm ON gse_gsm.gsm = gsm.gsm',
                                    'JOIN gpl ON gse_gpl.gpl = gpl.gpl',
                                    'WHERE pubmed_id IN (', paste(pmids_by_query$`cardiovascular diseases`,collapse=','), ')',
                                    'AND technology LIKE "high-throughput sequencing"'))
assay_cardio_htseq %>% write.table(file = '../data/geo-assay-cardio-htseq.tsv', sep='\t',row.names = FALSE)
assay_cardio_htseq %>% dplyr::count(study_type) %>%
    ggplot() +
    geom_bar(aes(x=study_type,y=n), stat='identity', fill = ggplotColours(5)[1]) +
    ylab("Number of assays") +
    theme_bw() +
    coord_flip()

ggsave(filename = '../figures/assay_count_by_study_type-cardio-htseq.png', device='png', width=12, height=3)
# For each study_type, summarize by molecule_ch1
assay_cardio_htseq$study_type %>% unique() %>%
    sapply(function(x) {
        # print(x)
        assay_cardio_htseq[assay_cardio_htseq$study_type == x, c('molecule_ch1')] %>% table() %>% return()
    }) %>%
    print()

assay_cardio_htseq[assay_cardio_htseq$study_type == "",c('gsm', 'study_type')]
