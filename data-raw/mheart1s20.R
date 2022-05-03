# Code to prepare `mheart1s20` dataset
library(haven)
library(tidyverse)

mheart1s20 <- haven::read_dta(file = "http://www.stata-press.com/data/r17/mheart1s20.dta")
mheart1s20 <- mheart1s20 %>%
  haven::zap_label() %>%
  haven::zap_labels() %>%
  haven::zap_formats()
attr(x = mheart1s20, which = "label") <- NULL
names(mheart1s20) <- make.names(names(mheart1s20))

usethis::use_data(mheart1s20, overwrite = TRUE)
