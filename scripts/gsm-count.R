library(RSQLite)
library(magrittr)
library(ggplot2)
library(dplyr)
library(tidyr)

con <- dbConnect(SQLite(), '../data/GEOmetadb.sqlite')
pmids_by_query <- readRDS('../data/pmids_by_query.RDS')
cardio_gsm <- dbGetQuery(con, paste('SELECT gsm.gsm, gsm.source_name_ch1, gsm.organism_ch1, organism_ch2, gpl.gpl, gpl.title as platform, gpl.description as platform_description, technology, gse.gse, gse.submission_date, gse.pubmed_id, gse.title, gse.summary, gse.type as study_type, gsm.type as sample_type, gsm.molecule_ch1',
                                    'FROM gse ',
                                    'JOIN gse_gsm ON gse.gse = gse_gsm.gse',
                                    'JOIN gse_gpl ON gse.gse = gse_gpl.gse',
                                    'JOIN gsm ON gse_gsm.gsm = gsm.gsm',
                                    'JOIN gpl ON gse_gpl.gpl = gpl.gpl',
                                    'WHERE pubmed_id IN (', paste(pmids_by_query$`cardiovascular diseases`,collapse=','), ')'))
cardio_gsm$year <- as.numeric(gsub('^(\\d{4})(.+)$','\\1', cardio_gsm$submission_date))

tech_gsm_counts <- cardio_gsm %>%
    subset(TRUE,c('year', 'technology', 'gsm')) %>%
    group_by(year, technology) %>%
    summarize(count = length(year)) %>%
    spread(technology, count) %>%
    reshape2::melt(id.vars='year') %>%
    set_names(c('year', 'technology', 'count'))

tech_gsm_counts$count[is.na(tech_gsm_counts$count)] = 0
tech_gsm_counts %>% group_by(technology) %>% arrange(year) %>% mutate(cumcount = cumsum(count)) %>%
    ggplot() +
    geom_area(aes(x=year,y=cumcount,fill=technology), alpha=0.9, position='stack') +
    ylab('Cumulative number of samples')
ggsave(filename = '../figures/gsm_count_by_tech-cardio.png', device='png', width=7, height=3)
