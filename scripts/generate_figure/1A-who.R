library(ggplot2)
library(magrittr)
ncd.deaths = data.table::fread('../../data/WHO-NCDDEATHCAUSE.csv', sep=',', header=TRUE, skip = 1)
ncd.deaths$Causes <- trimws(ncd.deaths$Causes)
ncd.deaths$Year <- trimws(ncd.deaths$Year) %>% as.numeric()
ncd.deaths$Total = ncd.deaths$` Both sexes`
ncd.deaths[ncd.deaths$Causes == 'Malignant neoplasms','Causes'] <- 'Malignant neoplasms (cancer)'

subset(ncd.deaths, Country == 'United States of America') %>%
    ggplot(mapping = aes_string(x='Year', y="Total", group='Causes', color='Causes'), data = .) +
    geom_line() +
    geom_point() +
    geom_text(data = ncd.deaths %>% subset(Country == 'United States of America' & Year == 2016),
              aes(y=Total + 40000, label=Causes, color=Causes, x = Year ),hjust =1)  +
    ylab('Number of deaths') +
    guides(color=FALSE)

ggsave('1A-who.png', device='png', width = 7, height = 4.5)