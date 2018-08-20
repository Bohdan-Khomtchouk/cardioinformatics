#' This script is used to create a light-weight database from OMIM to facilitate analysis. This database cannot be distributed.
#' To use this script
#' 
#' 1. Download all OMIM data files into a local directory. The files should include
#' genemap2.txt
#' mim2gene.txt
#' mimTitles.txt
#' morbidmap.txt
#' 
#' 2. Set the env var 'DBDIR' to point to this directory
#' 3. Run
#' 
#' A file OMIMdb.sqlite will be created at the same directory
#' 
DATADIR = Sys.getenv('DBDIR')

library(RSQLite)
library(magrittr)

con <- dbConnect(RSQLite::SQLite(), paste0(DATADIR, '/OMIMdb.sqlite'))
# con <- dbConnect(RSQLite::SQLite(), ':memory')

# standardizeFieldNames <- function(df) {
#     names(df) <- gsub(pattern = '\\W+',replacement = '', x = names(df) )
#     return(df)
# }


mappings = data.frame('MappingNumber' = c(1,2,3,4),
                      'MappingDescription' = c('The disorder is placed on the map based on its association with a gene, but the underlying defect is not known.',
                                                'The disorder has been placed on the map by linkage or other statistical method; no mutation has been found.',
                                                'The molecular basis for the disorder is known; a mutation has been found in the gene.',
                                               'A contiguous gene deletion or duplication syndrome, multiple genes are deleted or duplicated causing the phenotype.'))
prefixes = data.frame('PrefixCharacter' = c('*', '^', '#', '%', '+', ''),
                      'PrefixName' = c('Asterisk', 'Caret', 'Number Sign', 'Percent', 'Plus', 'NULL'),
                      'PrefixMeaning' = c('Gene', 'Entry has been removed from the database or moved to another entry', 'Phenotype, molecular basis known', 'Phenotype or locus, molecular basis unknown', 'Gene and phenotype, combined', 'Other, mainly phenotypes with suspected mendelian basis'))
# Asterisk (*)  Gene  
# Plus (+)  Gene and phenotype, combined
# Number Sign (#)  Phenotype, molecular basis known 
# Percent (%)  Phenotype or locus, molecular basis unknown
# NULL (<null>)  Other, mainly phenotypes with suspected mendelian basis 
# Caret (^)  Entry has been removed from the database or moved to another entry ))

genemap2 <-
    data.table::fread(paste0(DATADIR, '/genemap2.txt'),sep='\t',stringsAsFactors = FALSE,
                      col.names = c('Chromosome', 'GenomicPositionStart', 'GenomicPositionEnd', 'CytoLocation', 'ComputedCytoLocation', 'MIMNumber', 'GeneSymbols', 'GeneName', 'ApprovedSymbol', 'EntrezGeneID', 'EnsemblGeneID', 'Comments', 'Phenotypes', 'MouseGeneSymbolID'))
mim2gene <-
    data.table::fread(paste0(DATADIR, '/mim2gene.txt'),sep='\t',stringsAsFactors = FALSE,
                              col.names = c('MIMNumber', 'MIMEntryType', 'EntrezGeneID', 'ApprovedGeneSymbol', 'EnsemblGeneID'))
mimTitles <- 
    data.table::fread(paste0(DATADIR, '/mimTitles.txt'),sep='\t',stringsAsFactors = FALSE,
                               col.names = c('Prefix', 'MIMNumber', 'PreferredTitle', 'AlternativeTitles', 'IncludedTitles')) %>%
    data.table::setkey('MIMNumber')

morbidmap <- data.table::fread(paste0(DATADIR, '/morbidmap.txt'), sep='\t', stringsAsFactors = FALSE,
                               col.names = c('Phenotype', 'GeneSymbols', 'GeneMIMNumber', 'CytoLocation'))
morbidmap$PhenotypeMIMNumber = gsub(pattern = '^.+,\\W+([0-9]{6})\\W+\\((\\d)\\)$', replacement = "\\1", x = morbidmap[['Phenotype']], perl=TRUE)
morbidmap$MappingNumber = gsub(pattern = '^.+,\\W+([0-9]{6})\\W+\\((\\d)\\)$', replacement = "\\2", x = morbidmap[['Phenotype']], perl=TRUE)

dbWriteTable(con, 'mappings', mappings)
dbWriteTable(con, 'prefixes', prefixes)
dbWriteTable(con, 'genes', genemap2)
dbWriteTable(con, 'phenotypes', mimTitles)
dbWriteTable(con, 'mim_types', mim2gene[,c('MIMNumber', 'MIMEntryType'),with=FALSE])
dbWriteTable(con, 'gene_phenotype', morbidmap[,c('GeneMIMNumber', 'PhenotypeMIMNumber', 'MappingNumber')])


dbDisconnect(con)
