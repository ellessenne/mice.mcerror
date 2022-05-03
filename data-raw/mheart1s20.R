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
mheart1s20 <- as.data.frame(mheart1s20)

usethis::use_data(mheart1s20, overwrite = TRUE)

# Same data in `mids` format
mheart1s20.0 <- dplyr::filter(mheart1s20, X_mi_m == 0)
mheart1s20.gt0 <- dplyr::filter(mheart1s20, X_mi_m > 0)
imp2 <- map(.x = which(!grepl(pattern = "X_", x = names(mheart1s20.gt0))), .f = function(nc) {
  idx <- mheart1s20.0$X_mi_id[is.na(mheart1s20.0[, nc])]
  out <- do.call(cbind.data.frame, map(.x = seq(max(mheart1s20.gt0$X_mi_m)), .f = function(m) {
    mheart1s20.gt0[mheart1s20.gt0[, "X_mi_id"] == idx & mheart1s20.gt0[, "X_mi_m"] == m, nc, drop = F]
  }))
  names(out) <- seq(max(mheart1s20.gt0$X_mi_m))
  out
})
names(imp2) <- names(mheart1s20.gt0)[which(!grepl(pattern = "X_", x = names(mheart1s20.gt0)))]
mheart1s20.0 <- dplyr::select(mheart1s20.0, -dplyr::starts_with("X_"))
mheart1s20.mice <- list(
  data = mheart1s20.0,
  imp = imp2,
  m = max(mheart1s20$X_mi_m),
  where = as.matrix(is.na(mheart1s20.0)),
  nmis = colSums(x = as.matrix(is.na(mheart1s20.0)))
)
class(mheart1s20.mice) <- "mids"
usethis::use_data(mheart1s20.mice, overwrite = TRUE)

# Test with:
library(mice)
fit <- with(
  data = mheart1s20.mice,
  glm(attack ~ smokes + age + bmi + hsgrad + female, family = binomial(link = "logit"))
)
summary(pool(fit))
