# List of cardiovascular diseases we want to include in heartbioportal:
# coronary artery disease, congestive heart failure, congenital heart disease, hypertension, cardiomyopathy, stroke, myocardial infarction, angina, arrhythmia

install.packages(c("RSQLite"))

# try http:// if https:// URLs are not supported
source("https://bioconductor.org/biocLite.R")
biocLite("GEOmetadb")

library(GEOmetadb)

# add an 'aging' keyword search too (e.g., GSE61242) but remove duplicates (e.g., Alzheimer's)

# comment here
if(!file.exists('GEOmetadb.sqlite')) getSQLiteFile()
con <- dbConnect(SQLite(), 'GEOmetadb.sqlite')


# Collecting GDS accession IDs for major aging-related diseases
alzheimers_gds <- dbGetQuery(con,paste("select gds,pubmed_id,gse,platform_organism,description,title from gds where",
                           "description like '%Alzheimer%'", sep=" "))
parkinsons_gds <- dbGetQuery(con,paste("select gds,pubmed_id,gse,platform_organism,description,title from gds where",
                                       "description like '%Parkinson%'", sep=" "))
copd_gds <- dbGetQuery(con,paste("select gds,pubmed_id,gse,platform_organism,description,title from gds where",
                                       "description like '%COPD%'", sep=" "))
stroke_gds <- dbGetQuery(con,paste("select gds,pubmed_id,gse,platform_organism,description,title from gds where",
                                 "description like '%stroke%'", sep=" "))
type2diabetes_gds <- dbGetQuery(con,paste("select gds,pubmed_id,gse,platform_organism,description,title from gds where",
                                   "description like '%type%II%diabetes%'", sep=" "))
type2diabetes_gds_2 <- dbGetQuery(con,paste("select gds,pubmed_id,gse,platform_organism,description,title from gds where",
                                          "description like '%type%2%diabetes%'", sep=" "))
hypertension_gds <- dbGetQuery(con,paste("select gds,pubmed_id,gse,platform_organism,description,title from gds where",
                                   "description like '%hypertension%'", sep=" "))
dementia_gds <- dbGetQuery(con,paste("select gds,pubmed_id,gse,platform_organism,description,title from gds where",
                                         "description like '%dementia%'", sep=" "))
arthritis_gds <- dbGetQuery(con,paste("select gds,pubmed_id,gse,platform_organism,description,title from gds where",
                                     "description like '%arthritis%'", sep=" "))
osteoporosis_gds <- dbGetQuery(con,paste("select gds,pubmed_id,gse,platform_organism,description,title from gds where",
                                      "description like '%osteoporosis%'", sep=" "))
myocardial_infarction_gds <- dbGetQuery(con,paste("select gds,pubmed_id,gse,platform_organism,description,title from gds where",
                                         "description like '%myocardial%infarction%'", sep=" "))
cataracts_gds <- dbGetQuery(con,paste("select gds,pubmed_id,gse,platform_organism,description,title from gds where",
                                         "description like '%cataract%'", sep=" "))
atherosclerosis_gds <- dbGetQuery(con,paste("select gds,pubmed_id,gse,platform_organism,description,title from gds where",
                                      "description like '%atherosclerosis%'", sep=" "))
coronary_artery_disease_gds <- dbGetQuery(con,paste("select gds,pubmed_id,gse,platform_organism,description,title from gds where",
                                            "description like '%coronary%artery%disease%'", sep=" "))
pulmonary_embolism_gds <- dbGetQuery(con,paste("select gds,pubmed_id,gse,platform_organism,description,title from gds where",
                                                    "description like '%pulmonary%embolism%'", sep=" "))
cardiomyopathy_gds <- dbGetQuery(con,paste("select gds,pubmed_id,gse,platform_organism,sample_organism,description,title from gds where",
                                            "description like '%cardiomyopathy%'", sep=" "))

aging_related_diseases_GDS <- rbind(cardiomyopathy_gds, pulmonary_embolism_gds, coronary_artery_disease_gds, atherosclerosis_gds, cataracts_gds, myocardial_infarction_gds, osteoporosis_gds, arthritis_gds, dementia_gds, hypertension_gds, type2diabetes_gds, type2diabetes_gds_2, stroke_gds, copd_gds, parkinsons_gds, alzheimers_gds)


# Collecting GSE accession IDs for major aging-related diseases
alzheimers_gse <- dbGetQuery(con,paste("select gse,pubmed_id,summary,title from gse where",
                                           "summary like '%Alzheimer%'", sep=" "))
parkinsons_gse <- dbGetQuery(con,paste("select gse,pubmed_id,summary,title from gse where",
                                       "summary like '%Parkinson%'", sep=" "))
copd_gse <- dbGetQuery(con,paste("select gse,pubmed_id,summary,title from gse where",
                                       "summary like '%COPD%'", sep=" "))
stroke_gse <- dbGetQuery(con,paste("select gse,pubmed_id,summary,title from gse where",
                                 "summary like '%stroke%'", sep=" "))
type2diabetes_gse <- dbGetQuery(con,paste("select gse,pubmed_id,summary,title from gse where",
                                   "summary like '%type%II%diabetes%'", sep=" "))
type2diabetes_gse_2 <- dbGetQuery(con,paste("select gse,pubmed_id,summary,title from gse where",
                                          "summary like '%type%2%diabetes%'", sep=" "))
hypertension_gse <- dbGetQuery(con,paste("select gse,pubmed_id,summary,title from gse where",
                                   "summary like '%hypertension%'", sep=" "))
dementia_gse <- dbGetQuery(con,paste("select gse,pubmed_id,summary,title from gse where",
                                         "summary like '%dementia%'", sep=" "))
arthritis_gse <- dbGetQuery(con,paste("select gse,pubmed_id,summary,title from gse where",
                                     "summary like '%arthritis%'", sep=" "))
osteoporosis_gse <- dbGetQuery(con,paste("select gse,pubmed_id,summary,title from gse where",
                                      "summary like '%osteoporosis%'", sep=" "))
myocardial_infarction_gse <- dbGetQuery(con,paste("select gse,pubmed_id,summary,title from gse where",
                                         "summary like '%myocardial%infarction%'", sep=" "))
cataracts_gse <- dbGetQuery(con,paste("select gse,pubmed_id,summary,title from gse where",
                                         "summary like '%cataract%'", sep=" "))
atherosclerosis_gse <- dbGetQuery(con,paste("select gse,pubmed_id,summary,title from gse where",
                                      "summary like '%atherosclerosis%'", sep=" "))
coronary_artery_disease_gse <- dbGetQuery(con,paste("select gse,pubmed_id,summary,title from gse where",
                                            "summary like '%coronary%artery%disease%'", sep=" "))
pulmonary_embolism_gse <- dbGetQuery(con,paste("select gse,pubmed_id,summary,title from gse where",
                                                    "summary like '%pulmonary%embolism%'", sep=" "))
cardiomyopathy_gse <- dbGetQuery(con,paste("select gse,pubmed_id,summary,title from gse where",
                                               "summary like '%cardiomyopathy%'", sep=" "))



aging_related_diseases_GSE <- rbind(cardiomyopathy_gse, pulmonary_embolism_gse, coronary_artery_disease_gse, atherosclerosis_gse, cataracts_gse, myocardial_infarction_gse, osteoporosis_gse, arthritis_gse, dementia_gse, hypertension_gse, type2diabetes_gse, type2diabetes_gse_2, stroke_gse, copd_gse, parkinsons_gse, alzheimers_gse)


# Remove duplicates... (but do it carefully so you only keep one, and have that one be the most annotated... otherwise keep duplicates intact)
# > head(aging_related_diseases_GDS)$gse
# [1] "GSE472"  "GSE670"  "GSE670"  "GSE1145" "GSE2236" "GSE1869"
# > head(aging_related_diseases_GSE)$gse
# [1] "GSE472"  "GSE670"  "GSE760"  "GSE1145" "GSE1502" "GSE1869"


#FYI
# > rs <- dbGetQuery(con,paste("select gds,pubmed_id,gse,platform_organism,title from gds where",
#                              +                            "description like '%Alzheimer%'",sep=" "))
# > dim(rs)
# [1] 18  5
#
# However...
#
# > rs <- dbGetQuery(con,paste("select gds,pubmed_id,gse,platform_organism,description from gds where",
#                              +                            "title like '%Alzheimer%'",sep=" "))
# > dim(rs)
# [1] 8 5
#
# So we pick the first one, because it's more inclusive (because description has more words than title)

