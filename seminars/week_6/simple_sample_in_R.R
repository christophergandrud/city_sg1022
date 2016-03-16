#----------------------------------------------------------------------------- #
# Draw random sample of women in parliament data for 2005
# Christopher Gandrud
#----------------------------------------------------------------------------- #

# Load packages
library(WDI)
library(dplyr)

# Download women in parliament data
women <- WDI(indicator = 'SG.GEN.PARL.ZS', start = 2005, end = 2005)

# Sample 30% of the sample
women_sample <- sample_frac(women, size = 0.3)

