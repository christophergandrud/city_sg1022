# Reproducible research lecture
# Christopher Gandrud

library(ggplot2)
library(wesanderson)

# WWS example
main <- data.frame(
    country = c('Vietnam', 'Vietnam', 
                'Indonesia', 'Indonesia',
                'Iran', 'Iran',
                'Albania', 'Albania'),
    year = rep(c('1999-2004', '2006-2009'), 4),
    support = c(99, 33,
                96, 95,
                83, 33,
                83, 13)
)

pal <- wes_palette("Cavalcanti")[c(1:2, 4:5)]

pal_ind <- c('#ccc', '#02401B', '#ccc', '#ccc')

# All countries
ggplot(main, aes(as.factor(year), support, group = country, colour = country)) +
    geom_line() +
    scale_colour_manual(values = pal, name = '') +
    scale_y_continuous(limits = c(0, 100)) +
    xlab('\nSurvey Wave') + ylab('Support Military Rule\n(% of respondents)\n') +
    theme_bw()


# Load required packages
library(WDI)
library(dplyr)
library(ggplot2)

# Set working directory. Changed as needed
setwd('U:\\research/group_project')

# Download women in parliament data from World Bank Development indicators
# from 1995. Indicator ID = SG.GEN.PARL.ZS
women <- WDI(indicator = 'SG.GEN.PARL.ZS', start = 1995)

# Clean up: (1) rename women in parliament indicator, 
# (2) select data from Algeria, Germany, Japan, and Sweden
women <- rename(women, women_in_parl = SG.GEN.PARL.ZS)
women <- filter(women, country %in% c('Algeria', 'Germany', 'Japan', 'Sweden'))

# Create a comparative line plot of the data
ggplot(women, aes(x = year, y = women_in_parl, colour = country)) +
geom_line() +
ylab('Women in Parliament (%)') + xlab('') +
theme_bw()
