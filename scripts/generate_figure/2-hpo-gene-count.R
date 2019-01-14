options(stringsAsFactors = FALSE)
library(magrittr)
library(ontologyIndex)
library(RSQLite)
library(ggplot2)

DATADIR = '../../data'
standardNames = data.table::fread(paste(DATADIR, 'conditionList.tsv', sep = '/'), sep='\t')

## HPO
hpo = get_ontology(paste(DATADIR,'hpo/hpo.obo', sep = '/'), extract_tags = 'everything')
phenotypeAnnotation = data.table::fread(paste(DATADIR, 'hpo/phenotype_annotation.tab', sep='/'),
                                        sep='\t',header = FALSE, quote = "",
                                        col.names = c('DB', 'DB_Object_ID', 'DB_Name', 'Qualifier', 'HPO_ID', 'DB_Reference', 'Evidence_Code', 'Onset_Modifier', 'Frequency', 'Sex', 'Modifier', 'Aspect', 'Date_Created', 'Assigned_By'))
hpo.associations = data.table::fread(paste(DATADIR, 'hpo/ALL_SOURCES_ALL_FREQUENCIES_phenotype_to_genes.txt', sep='/'),
                                     sep = '\t', header=FALSE, quote="") %>%
    set_names(c('HPOTermId', 'HPOTermName', 'GeneId', 'GeneSymbol'))
hpo.CVDs = standardNames$HPOTermId %>%
    lapply(function(x) {
        subset(hpo.associations, HPOTermId == x) %>%
            `$`('GeneSymbol') %>%
            unique()  %>%
            return()
    }) %>%
    set_names(standardNames$HPOTermId)

## gene count
geneCount = data.frame(standardNames)
geneCount <- sapply(hpo.CVDs, length) %>%
    `$<-`(geneCount, 'HPO', .)

## Plot gene count
plot_gene_count <- function(data, fieldName, yLabel = 'Number of genes') {
    groupColors = c('#a6cee3', '#1f78b4', '#4daf4a', 'darkgreen', '#fb9a99', '#e31a1c', '#fdbf6f', '#ff7f00', '#cab2d6')
    tmp = data
    tmp$color <- factor(tmp$query) %>% `levels<-`(groupColors) %>% as.character()
    tmp %>%
        ggplot(aes_string(y = fieldName)) +
        geom_bar(aes(x=factor(HPOTermName, levels=HPOTermName),
                     fill=query),stat = 'identity') +
        theme_bw() +
        theme(axis.text.y = element_text(color = tmp$color)) +
        scale_fill_manual(values = groupColors) +
        guides(fill=guide_legend(title='Group')) +
        ylab(yLabel) +
        xlab('Phenotype') +
        coord_flip()
}

plot_gene_count(geneCount, 'HPO')
ggsave('2-hpo-gene-count.png', device = 'png', width = 10, height=4.5)
