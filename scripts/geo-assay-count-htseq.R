library(RSQLite)
library(magrittr)
library(ggplot2)
library(dplyr)
library(tidyr)

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
