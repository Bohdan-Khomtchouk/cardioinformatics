options(stringsAsFactors = FALSE)
library(magrittr)
library(ontologyIndex)
library(RSQLite)
library(ggplot2)

standardNames = data.table::fread('../data/conditionList.tsv', sep='\t')

## disgenet
dgn.all = data.table::fread('../data/disgenet/all_gene_disease_associations.tsv')
dgn.mappings = data.table::fread('../data/disgenet/disease_mappings.tsv', sep='\t')
dgn.CVDs = standardNames$HPOTermId %>%
    lapply(function(x) {
        return(dgn.mappings[dgn.mappings$code == x, 'diseaseId'])
    }) %>%
    set_names(standardNames$HPOTermId) %>%
    lapply(function(x) {
        subset(dgn.all, diseaseId %in% x[['diseaseId']]) %>%
            `$`('geneSymbol') %>%
            unique() %>%
            return()
    })

## HPO
hpo = get_ontology('../data/hpo/hpo.obo', extract_tags = 'everything')
phenotypeAnnotation = data.table::fread('../data/hpo/phenotype_annotation.tab', sep='\t',header = FALSE, quote = "",
                                        col.names = c('DB', 'DB_Object_ID', 'DB_Name', 'Qualifier', 'HPO_ID', 'DB_Reference', 'Evidence_Code', 'Onset_Modifier', 'Frequency', 'Sex', 'Modifier', 'Aspect', 'Date_Created', 'Assigned_By'))
hpo.associations = data.table::fread('../data/hpo/ALL_SOURCES_ALL_FREQUENCIES_phenotype_to_genes.txt', sep = '\t', header=FALSE, quote="") %>%
    set_names(c('HPOTermId', 'HPOTermName', 'GeneId', 'GeneSymbol'))
hpo.CVDs = standardNames$HPOTermId %>%
    lapply(function(x) {
        subset(hpo.associations, HPOTermId == x) %>%
            `$`('GeneSymbol') %>%
            unique()  %>%
            return()
    }) %>%
    set_names(standardNames$HPOTermId)

geneCount = data.frame(standardNames)
geneCount <-  sapply(dgn.CVDs, length) %>%
    `$<-`(geneCount, 'disgenet', .)
geneCount <- sapply(hpo.CVDs, length) %>%
    `$<-`(geneCount, 'HPO', .)
p <- geneCount %>%
    reshape2::melt(id.vars = c('HPOTermName', 'HPOTermId', 'query')) %>%
    ggplot() +
    geom_point(aes(x=HPOTermName, y = value, shape=variable)) +
    geom_line(aes(x=HPOTermName, y = value)) +
    scale_shape_manual(values = c(19, 24)) +
    guides(shape=guide_legend(title='Source')) +
    scale_y_log10() +
    ylab('Number of genes associated') +
    xlab('Phenotype') + 
    theme_bw() +
    theme(axis.ticks = element_blank()) +
    coord_flip()
print(p)
ggsave('../figures/gene-associations-discrepancy.png', device = 'png', width = 10, height=4.5)
