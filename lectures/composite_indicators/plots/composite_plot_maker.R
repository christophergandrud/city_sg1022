# ---------------------------------------------------------------------------- #
# Plots for composite plots lecture
# Christopher Gandrud
# MIT LICENSE
# ---------------------------------------------------------------------------- #

library(rio)
library(dplyr)
library(DataCombine)
library(repmis)
library(corrplot)
library(ggplot2)
library(WDI)
library(psych)

# Set working directory
possibles <- c('/git_repositories/city_sg1022/lectures/composite_indicators/')

set_valid_wd(possibles)

# Correlation examples ---------------------------------------------------------
x_rand <- rnorm(n = 10, mean = 5, sd = 2)
y_rand_po <- rnorm(n = 10, mean = 5, sd = 3)
y_rand_neg <- rnorm(n = 10, mean = -5, sd = 3)
y_no <- rep(5, 10)

x <- c(1:10, 1:10, x_rand, x_rand, x_rand)
y <- c(1:10, -1:-10, y_no, y_rand_po, y_rand_neg)

labels <- c(rep('Perfect Positive (r = +1)', 10), 
            rep('Perfect Negative (r = -1)', 10),
            rep('No Correlation (r = 0)', 10), 
            rep(paste('r =', round(cor(x[31:40], y[31:40]), digits = 2)), 10),
            rep(paste('r =', round(cor(x[41:50], y[41:50]), digits = 2)), 10)
          )

cor_example <- data.frame(labels, x, y)

cor_plot <- ggplot(cor_example, aes(x, y, group = labels)) +
    geom_point() +
    facet_wrap(~labels, scales = 'free') +
    stat_smooth(method = 'lm', se = F) +
    xlab('') + ylab('') +
    theme_bw()

ggsave(cor_plot, filename = 'figures/corr_plot_example.pdf')



# Sustainability Index ---------------------------------------------------------
wdi <- WDI(indicator = c('EN.ATM.METH.KT.CE', 'EG.USE.ELEC.KH.PC', 
                         'EN.ATM.CO2E.PC', 'SP.POP.GROW',
                         'EG.USE.COMM.CL.ZS'), 
                         start = 1990)

# Save
export(wdi, 'plots/wdi_environment_data.csv')
wdi <- import('plots/wdi_environment_data.csv')

# Keep only countries
regions <- unique(wdi$iso2c[grep('^[1-9]', wdi$iso2c)])
wdi <- subset(wdi, !(iso2c %in% regions))

wdi <- wdi %>% rename(methane_emissions = EN.ATM.METH.KT.CE) %>%
               rename(electricity_use = EG.USE.ELEC.KH.PC) %>%
               rename(co2_emissions = EN.ATM.CO2E.PC) %>% 
               rename(population_growth = SP.POP.GROW) %>%
               rename(alternative_energy = EG.USE.COMM.CL.ZS)

# Create correlation plot
cor_wdi <- cor(wdi[, 5:8], use = 'complete.obs')

pdf(file = 'figures/energy_corr.pdf')
    corrplot(cor_wdi, method = "number")
dev.off()

# Reverse code alternative energy use 
## i.e. higher values of alternative energy use should indicate less unsustainability
wdi$alternative_energy <- max(wdi$alternative_energy, na.rm = TRUE) - 
    wdi$alternative_energy

# Drop incomplete cases
wdi_sub <- DropNA(wdi, c('electricity_use', 
                         'co2_emissions', 'population_growth', 
                         'alternative_energy'))


# FRT Comparison ---------------------------------------------------------------
# Load data 
URL <- 'https://raw.githubusercontent.com/FGCH/FRTIndex/master/IndexData/FRTIndex.csv'

frt_index <- import(URL)

keepers <- c('Brazil', 'United States', 'Germany', 'France', 'Slovak Republic',
             'United Kingdom')
frt_sub <- frt_index %>% filter(year == 2011) %>% filter(country %in% keepers)

frt_plot <- ggplot(frt_sub, aes(x = median, y = reorder(country, median),
                 xmin = lower_95,
                 xmax = upper_95)) +
    geom_point(size = 3) +
    geom_segment(aes(x = lower_95, xend = upper_95,
                     yend = reorder(country, median)), size = 0.5,
                 alpha = 0.4) +
    geom_segment(aes(x = lower_90, xend = upper_90,
                     yend = reorder(country, median)), size = 1.5,
                 alpha = 0.4) +
    xlab('\n Financial Sup. Transparency Score') + ylab('') +
    theme_bw()

ggsave(frt_plot, filename = 'figures/frt_uncertainty.pdf')
