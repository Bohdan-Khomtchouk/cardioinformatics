library(ggplot2)
library(magrittr)
library(dplyr)
library(tidyr)
MAINDIR = '../../'
devtools::load_all(MAINDIR)
VAR.CONSEQUENCES = data.table::fread(file.path(MAINDIR, 'data', 'ensembl-vep-consequences.tsv'), sep='\t')

# ## Exploratory analysis of GWAS
# 
# ### Data files and structures
# 
# The GWAS-provided table of `studies` contains the association of a given phenotype in a given study (represented by Pubmed ID). Thus a single pubmed id (a publication) may  have multiple rows in this table, if it reports associations with multiple phenotypes.
# 
# 
# ```{r}
gwas = data.table::fread(file.path(MAINDIR, 'data', 'gwas/gwas_catalog_v1.0.2-associations_e93_r2018-08-28.tsv'), sep='\t')
# gwas.studies = data.table::fread('../data/gwas/gwas_catalog_v1.0.2-studies_r2018-09-15.tsv', sep='\t')
# test.pmid = gwas.studies %>% count(PUBMEDID) %>% filter(n > 1) %>% `[[`(1,'PUBMEDID')
# ```
# 
# For example the study `r test.pmid` has `r nrow(filter(gwas.studies, PUBMEDID == test.pmid))`, each has a different `MAPPED_TRAIT`,
# 
# ```{r}
# filter(gwas.studies, PUBMEDID == test.pmid)
# ```
# 
# Each of such unique pair (PMID - MAPPED_TRAIT) is given a study accession uniquely identify the record within GWAS database.
# 
# ```{r}
# nrow(gwas.studies) == gwas.studies$`STUDY ACCESSION` %>% unique() %>% length()
# ```

# The `associations` table report one _association_ per row. There are three types of associations.
# 1. The single SNP - trait association
# 2. The multiple-SNP haplotype - trait association, in which SNPs are separated by `;`
# 3. The SNP-SNP interaction, in which the pairs are described as `snp1 x snp2`

# type1.ind = (!grepl(pattern = ';', gwas$SNPS) & !grepl(pattern = ' x ', gwas$SNPS))
# type2.ind = grepl(pattern = ';', gwas$SNPS)
# type3.ind = grepl(pattern = ' x ', gwas$SNPS)

is.type1 = function(X, test_col = 'SNPS') { return(!grepl(pattern = ';', X[[test_col]]) & !grepl(pattern = ' x ', X[[test_col]])) }
is.type2 = function(X, test_col = 'SNPS') { return(grepl(pattern = ';', X[[test_col]])) }
is.type3 = function(X, test_col = 'SNPS') { return(grepl(pattern = ' x ', X[[test_col]])) }

# Some examples of multiple-SNP haplotypes
# gwas[grepl(pattern = ";", gwas$SNPS), c('SNPS', 'MAPPED_TRAIT', 'PVALUE_MLOG')]

# Some examples of SNP interaction studies
# gwas[grepl(pattern = " x ", gwas$SNPS), c('SNPS', 'MAPPED_TRAIT', 'PVALUE_MLOG') ]
# 
# There are some SNPs that are not given a name with the pattern `rsXXXXX`, for example
# gwas[!grepl(pattern = 'rs\\d+', gwas$SNPS, perl=TRUE), 'SNPS']

### SNPs reported both as single SNP and in the haplotypes
# There are SNPs associated with traits both as an individual variant and in linkage with other variants. The fact that a single SNP is associated with a trait does not exclude it from the linkage with other SNPs, but it is simply the result of single-SNP focused analyses.

# start = proc.time()
# type1.snp = gwas[type1.ind,]$SNPS %>% unique()
# type2.snp = gwas[type2.ind,]$SNPS %>% unique()
# type3.snp = gwas[type3.ind,]$SNPS %>% unique()
# singleInMulti = sapply(type1.snp, FUN = function(y) {return(grep(pattern = paste0('\\b', y, '\\b'), x = type2.snp, value = TRUE, perl = TRUE))})
# singleInInter = sapply(type1, FUN = function(y) {return(grep(pattern = paste0('\\b', y, '\\b'), x = type3, value = TRUE, perl = TRUE))})
# dt = proc.time() - start
# print(dt)
# cnt.singleInMulti = sapply(singleInMulti, FUN = length)
# tmp<-singleInMulti[which(cnt.singleInMulti > 1)] %>%
#     do.call(c,.) %>%
#     c(names(singleInMulti[which(cnt.singleInMulti > 1)])) %>%
#     as.character()
# dplyr::filter(gwas, SNPS %in% tmp)[c('SNPS', 'DISEASE/TRAIT')]

### Contexts of the variants

split_records <- function(x, cols, split = ';') {
    lapply(1:nrow(x), FUN = function(i) {
        lapply(cols, function(j) {
            return(strsplit(x[[j]], split = split) %>% unlist() %>% trimws())
        }) %>%
            do.call(cbind, .) %>%
            return()
    }) %>%
        do.call(rbind, .) %>%
        data.frame() %>%
        set_names(cols) %>%
        dplyr::distinct() %>%
        return()
}

context1 = gwas[is.type1(gwas, 'SNPS'),c('SNPS', 'CONTEXT')]
context2 = gwas[is.type2(gwas, 'SNPS'),c('SNPS', 'CONTEXT')]
context3 = gwas[is.type3(gwas, 'SNPS'),c('SNPS', 'CONTEXT')]


variant.contexts = context1 %>% dplyr::distinct()

# one variant, multiple contexts
# dplyr::count(variant.contexts, SNPS)
context.cnt = dplyr::count(variant.contexts, CONTEXT)


#### Distribution of variants in genome
gwas.queries <- data.table::fread(file.path(MAINDIR, 'data', 'conditionList.tsv'), sep='\t')$query %>% unique() %>%
    lapply(FUN = function(y) {
        gwas[grepl(pattern = y, x = gwas$MAPPED_TRAIT, ignore.case = TRUE) | grepl(pattern = y, x = gwas$`DISEASE/TRAIT`, ignore.case = TRUE),] %>%
            return()
    })
gwas.CVDs <- do.call(rbind, gwas.queries)
# is.type1(gwas.CVDs) %>% sum() +
#     is.type2(gwas.CVDs) %>% sum() +
#     is.type3(gwas.CVDs) %>% sum()

context1 = gwas.CVDs[is.type1(gwas.CVDs, 'SNPS'),c('SNPS', 'CONTEXT')]
context2 = gwas.CVDs[is.type2(gwas.CVDs, 'SNPS'),c('SNPS', 'CONTEXT')]
context3 = gwas.CVDs[is.type3(gwas.CVDs, 'SNPS'),c('SNPS', 'CONTEXT')]

# variant.contexts = 
#     split_records(context2, cols = c('SNPS', 'CONTEXT'), split = ';') %>%
#     rbind(split_records(context3, cols = c('SNPS', 'CONTEXT'), split = ' x ')) %>%
#     rbind(context1) %>%
#     dplyr::distinct()

variant.contexts = context1 %>% dplyr::distinct()

context.cnt.cvd = dplyr::count(variant.contexts, CONTEXT) 
context.cnt.combined = 
    context.cnt.cvd %>%
    dplyr::full_join(x = context.cnt, y = ., all = TRUE, by = 'CONTEXT', incomparables = 0) %>%
    `[<-`(is.na(.[[2]]), 2, 0) %>%
    `[<-`(is.na(.[[3]]), 3, 0) %>%
    set_names(c('SOTerm', 'All traits', 'CVD')) %>%
    dplyr::left_join(VAR.CONSEQUENCES[,c('SOTerm', 'DisplayTerm', 'IsProteinCoding')], by = 'SOTerm') %>%
    subset(SOTerm != "") %>%
    dplyr::arrange(., dplyr::desc(.$IsProteinCoding))

labelOrder = context.cnt.combined$DisplayTerm
# context.cnt.combined[['All traits']] = context.cnt.combined[['All traits']] + 0.1
# context.cnt.combined[['CVD']] = context.cnt.combined[['CVD']] + 0.1
labelColors = c('blue', 'green')
tmp <- context.cnt.combined %>%
    reshape2::melt(id.vars = c('SOTerm', 'DisplayTerm', 'IsProteinCoding'))
tmp$color <- factor(tmp$IsProteinCoding) %>% `levels<-`(labelColors) %>% as.character()
p <- context.cnt.combined %>%
    reshape2::melt(id.vars = c('SOTerm', 'DisplayTerm', 'IsProteinCoding')) %>%
    ggplot(mapping =  aes(x = factor(DisplayTerm, levels = labelOrder))) +
    geom_bar(aes(y =value, fill=variable), stat='identity',alpha = 0.8) +
    scale_fill_discrete( guide_legend(title = 'Mapped traits')) +
    scale_y_log10(limits = c(1, NA)) + 
    ylab('Variant count') +
    xlab('Context') +
    theme(legend.position = c(0.83,0.87)) +
    coord_flip()
p
ggsave('3a-variant_contexts-sorted.png',height = 4, width=6)
p + theme(axis.text.y = element_text(color = tmp$color))
ggsave('3b-variant_contexts-sorted-colored.png',height = 4, width=6)