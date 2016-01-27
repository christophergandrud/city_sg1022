# ---------------------------------------------------------------------------- #
# Example comparative word clouds for Angela Merkel Press Releases
# Christopher Gandrud
# MIT LICENSE
# ---------------------------------------------------------------------------- #


# Load packages
library(dplyr)
library(tm)
library(wordcloud)
library(RColorBrewer)

# Set working directory
setwd('/git_repositories/city_sg1022/seminars/week_4/')

# Set colour palette
pal <- brewer.pal(8,"Set2")

# September 2015
## http://www.bundeskanzlerin.de/Content/EN/Artikel/2015/09_en/2015-09-09-generaldebatte-merkel_en.html
clean_sept <- Corpus(DirSource('refugees_pre/')) %>%
    tm_map(stripWhitespace) %>%
    tm_map(removePunctuation) %>%
    tm_map(removeNumbers) %>%
    tm_map(removeWords,
           stopwords(kind = "SMART")) %>%
    tm_map(removeWords, words = c('angela', 'merkel'))

wordcloud(clean_sept, scale=c(8, 0.2),
          random.order = FALSE, rot.per = .15, colors = pal2)

# January 2016
# http://www.bundeskanzlerin.de/Content/EN/Artikel/2016/01_en/2016-01-11-konsequenzen-nach-koeln_en.html
clean_jan <- Corpus(DirSource('refugees_post/')) %>%
    tm_map(stripWhitespace) %>%
    tm_map(removePunctuation) %>%
    tm_map(removeNumbers) %>%
    tm_map(removeWords,
           stopwords(kind = "SMART"))

wordcloud(clean_jan, scale=c(8, 0.2),
          random.order = FALSE, rot.per = 0.15, colors = pal)
