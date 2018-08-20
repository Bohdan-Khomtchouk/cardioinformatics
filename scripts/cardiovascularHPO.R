# Human Phenotype Ontology https://raw.githubusercontent.com/obophenotype/human-phenotype-ontology/master/hp.obo

# 
commonNames = c('coronary artery disease',
                'congestive heart failure',
                'congenital heart disease',
                'hypertension',
                'cardiomyopathy',
                'stroke',
                'myocardial infarction',
                'angina',
                'arrhythmia') 
library(ontoCAT)
library(magrittr)

curl::curl_download('https://raw.githubusercontent.com/obophenotype/human-phenotype-ontology/master/hp.obo',destfile = 'hpo.obo')
hpo = ontoCAT::getOntology('hpo.obo')

for (name in commonNames) {
    # not sure why it's returning character instead of OntologyTerm object
    term = searchTerm(hpo,'coronary artery disease') %>%
        getAccession() %>%
        getTermById(hpo, .)
    # term = searchTerm(hpo,'HP_0012436')
}
