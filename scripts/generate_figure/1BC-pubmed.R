library(ggplot2)
library(rentrez)
library(GEOmetadb)
library(RSQLite)
library(magrittr)

count_year <- function(year, term) {
    query <- paste(term, "AND (", year, "[PDAT])")
    return(entrez_search(db="pubmed", term=query, retmax =0)$count)
}

get_pmids <- function(query) {
    entrez_search(db="pubmed", term=query, retmax =0)$count %>%
        entrez_search(db="pubmed", term=query, retmax = .) %>%
        `$`('ids') %>%
        return()
}

heartConditions = read.table('../../data/conditionList.tsv', sep='\t', header = TRUE)
endYear = format(Sys.time(), "%Y") %>% as.integer()
heartPubmed = list()

## Pubmed

### Queries

queries <- c('cardiovascular diseases' = '"cardiovascular diseases"[MeSH Terms]',
             'bioinformatics' = 'bioinformatics[MeSH Terms] OR genomics[MeSH Terms]',
             'cardioinformatics' = '(bioinformatics[MeSH Terms] OR genomics[MeSH Terms]) AND ("cardiovascular diseases"[MeSH Terms])',
             'cancer informatics' = '(bioinformatics[MeSH Terms] OR genomics[MeSH Terms]) AND (*cancer[MeSH Terms])',
             'cancer' = '(*cancer[MeSH Terms])'
              )
for (i in 1:length(queries)) {
    queries[i] = paste('((', queries[i], 'AND (hasabstract[text] AND English[lang]))) NOT (("autobiography"[Publication Type] OR "biography"[Publication Type] OR "corrected and republished article"[Publication Type] OR "duplicate publication"[Publication Type] OR "electronic supplementary materials"[Publication Type] OR "interactive tutorial"[Publication Type] OR "interview"[Publication Type] OR "lectures"[Publication Type] OR "legal cases"[Publication Type] OR "legislation"[Publication Type] OR "meta analysis"[Publication Type] OR "news"[Publication Type] OR "newspaper article"[Publication Type] OR "patient education handout"[Publication Type] OR "published erratum"[Publication Type] OR "retracted publication"[Publication Type] OR "retraction of publication"[Publication Type] OR "review"[Publication Type] OR "scientific integrity review"[Publication Type] OR "support of research"[Publication Type] OR "video audio media"[Publication Type] OR "webcasts"[Publication Type]))'
)
}

#### Publication on Cardiovascular diseases over the years

relativePubmed <- data.frame('year' = c(1990:endYear)) %>%
    `$<-`('all', sapply(.[['year']], function(x) { return(count_year(x, ''))})) %>%
    `$<-`('cardiovascular diseases', sapply(.[['year']], function(x) { return(count_year(x, queries['cardiovascular diseases']))})) %>%
    `$<-`('bioinformatics', sapply(.[['year']], function(x) {return(count_year(x, queries['bioinformatics']))})) %>%
    `$<-`('cardioinformatics',  sapply(.[['year']], function(x) {return(count_year(x, queries['cardioinformatics']))})) %>%
    `$<-`('cancer informatics',  sapply(.[['year']], function(x) {return(count_year(x, queries['cancer informatics']))})) %>%
    `$<-`('cancer',  sapply(.[['year']], function(x) {return(count_year(x, queries['cancer']))}))

sector.colors = c('cardiovascular diseases' = '#fbb4ae', 'cancer' = '#fbb4ae', 'bioinformatics' = '#fed9a6', 'cardioinformatics' = '#b3cde3', 'cancer informatics' = '#ccebc5' )
sector.orders = relativePubmed[relativePubmed$year == 2016, -1] %>% as.numeric() %>% order(decreasing = T) %>% `[`(names(relativePubmed)[-1], .)
plot_pubcount <- function(data, yearsToPlot, varsToPlot) {
    p <- data %>%
        reshape2::melt(id.vars='year') %>%
        subset(variable %in% varsToPlot & year %in% yearsToPlot) %>%
        `$<-`('variable', factor(.[['variable']], levels=sector.orders)) %>%
        plyr::arrange(variable) %>%
        ggplot() +
            geom_bar(aes(x=year,y=value,group=variable, fill=variable),stat='identity', position='identity') +
            ylab('Number of publications on Pubmed') +
            scale_x_continuous(breaks = yearsToPlot, labels=as.character(yearsToPlot)) +
            scale_fill_manual(values=sector.colors) +
            theme(axis.text.x = element_text(hjust=1, angle=45), legend.position = c(0.15, 0.85)) +
            guides(fill=guide_legend(title=""))
    if (endYear %in% yearsToPlot)
        p <- p + annotate("text", x=endYear, y=max(subset(data, year == endYear, varsToPlot))*1.1, label="*", size=7)
    return(p)    
}


#### Cardiovascular disease vs bioinformatics/genomics research since 2000 (when bioinformatics research starts to gather enough publication to be visible)
yearsToPlot = 2000:endYear
plot_pubcount(relativePubmed, yearsToPlot, varsToPlot = c('bioinformatics', 'cardioinformatics', 'cardiovascular diseases') )
ggsave('1C-pubmed-cardio.png', device = 'png', width = 7, height=5)

plot_pubcount(relativePubmed, yearsToPlot = yearsToPlot, varsToPlot = c('cancer', 'bioinformatics', 'cancer informatics') ) +
    guides(fill=guide_legend(title=""))
ggsave('1E-pubmed-cancer.png', device = 'png', width = 7, height=5)

plot_pubcount(relativePubmed, yearsToPlot = yearsToPlot, varsToPlot = c('bioinformatics', 'cancer informatics', 'cardioinformatics') )
ggsave('1D-pubmed-cardioinfo-vs-cancerinfo.png', device = 'png', width = 7, height=5)
