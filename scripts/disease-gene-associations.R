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

## gene count
geneCount = data.frame(standardNames)
geneCount <-  sapply(dgn.CVDs, length) %>%
    `$<-`(geneCount, 'disgenet', .)
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

plot_gene_count(geneCount, 'disgenet')
ggsave('../figures/disgenet-gene-count.png', device = 'png', width = 10, height=4.5)
plot_gene_count(geneCount, 'HPO')
ggsave('../figures/hpo-gene-count.png', device = 'png', width = 10, height=4.5)

## Plot discrepancy
ggplot(geneCount) +
    geom_point(aes(x=HPO, y = disgenet)) +
    scale_y_log10() +
    scale_x_log10()
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
