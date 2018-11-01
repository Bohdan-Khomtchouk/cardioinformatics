# disease-gene association data from OMIM and disgenet
library(ggplot2)

dga.omim = read.table('../data/geneAssociationCount-OMIM.tsv', sep='\t', header = TRUE)
dga.dgn = read.table('../data/geneAssociationCount-disgenet.tsv', sep='\t', header=TRUE)
dga = merge(dga.omim, dga.dgn[,c('HPOTermId', 'disgenetCount')], by = 'HPOTermId', sort = FALSE)

p <- dga %>%
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
