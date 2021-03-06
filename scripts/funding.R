library(ggplot2)
library(magrittr)

datafile = './data/nih-funding/compiled.xlsx'

funding_a = readxl::read_excel(datafile, sheet = '2008-2014') %>%
    set_names(c('Category', 'IsCVD', 'IsCancer', 2008, 2009, '2009-ARRA', 2010, '2010-ARRA', 2011, 2012, 2013, 2014))
funding_b = readxl::read_excel(datafile, sheet = '2014-2019') %>%
    set_names(c('Category', 'IsCVD', 'IsCancer', 2014:2019))

# There are 2 records for 2014. Pick the newer one
# ## Alternative 1 (over-counting): sum all categories within cancer or cvd
# funding.cvd <-
#     funding_a[funding_a$IsCVD == 1, c('Category', 2008:2013)] %>%
#     merge(y = funding_b[funding_b$IsCVD == 1, c('Category', 2014:2019)], by = 'Category')
# 
# funding.cancer <-
#     funding_a[funding_a$IsCancer == 1, c('Category', 2008:2013)] %>%
#     merge(y = funding_b[funding_b$IsCancer == 1, c('Category', 2014:2019)], by = 'Category')
 
## Alternative 2 (under-counting): select only the broadest categories
funding.cvd <-
    funding_a[funding_a$Category == 'Cardiovascular', c('Category', 2008:2013)] %>%
    merge(y = funding_b[funding_b$Category == 'Cardiovascular', c('Category', 2014:2019)], by = 'Category')

funding.cancer <-
    funding_a[funding_a$Category == 'Cancer', c('Category', 2008:2013)] %>%
    merge(y = funding_b[funding_b$Category == 'Cancer', c('Category', 2014:2019)], by = 'Category')
 
for (x in 2008:2019) {
    funding.cvd[,as.character(x)] <- as.numeric(funding.cvd[,as.character(x)])
}
for (x in 2008:2019) {
    funding.cancer[,as.character(x)] <- as.numeric(funding.cancer[,as.character(x)])
}

total.cancer <- funding.cancer[,-1] %>%
    apply(MARGIN = 2, FUN = sum, na.rm = TRUE) %>%
    data.frame(Year = as.numeric(names(.)), Funding = .)
total.cvd <- funding.cvd[,-1] %>%
    apply(MARGIN = 2, FUN = sum, na.rm = TRUE) %>%
    data.frame(Year = as.numeric(names(.)), Funding = .)

funding.total <- merge(x = total.cancer, y = total.cvd, by = 'Year') %>%
    set_names(c('Year', 'cancer', 'cardiovascular diseases'))


# For consistent coloring with WHO chart
# scales::show_col(scales::hue_pal()(4))

sector.colors = c('cardiovascular diseases' = '#f8766d', 'cancer' = '#c77cff')
funding.total.melted = funding.total %>%
    reshape2::melt(id.vars = 'Year')
p <- ggplot(funding.total.melted) +
    # geom_bar(aes(x = Year, y = value, fill = variable), stat = 'identity', position = 'identity', alpha = 0.3) +
    geom_line(aes(x = Year, y = value, color = variable)) +
    geom_point(aes(x = Year, y = value, color = variable)) +
        xlim(c(2000,2018)) +
        scale_y_continuous(name = 'NIH Funding (in million dollars)') +
        scale_color_manual(values = sector.colors) +
        geom_text(data = subset(funding.total.melted,Year == '2006'),
              aes(y=value+ 400, label=variable, color=variable, x = Year ),hjust =1)  +
        guides(color = FALSE)

ggsave('1-funding.png', plot = p, device='png', width = 7, height = 4.5)

