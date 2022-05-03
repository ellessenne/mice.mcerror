#' @title Fictional Heart Attack Data with Missing BMI
#'
#' @description Fictional heart attack data with missing BMI information, imported from Stata 17.
#' This dataset includes 20 multiply imputed copies of the same dataset, stacked on top of each other in long format.
#'
#' @format A data frame with 594 rows and 9 variables:
#' * `attack` Binary outcome;
#' * `smokes` Binary covariate;
#' * `age` Continuous covariate
#' * `bmi` Continuous covariate with some degree of missingness;
#' * `female` Binary covariate;
#' * `hsgrad` Binary covariate;
#' * `X_mi_id` Subject-specific IDContinuous covariate with some degree of missingness (from Stata's internal `mi` structure);
#' * `X_mi_miss` Missingness indicator variable (from Stata's internal `mi` structure);
#' * `X_mi_m` Identifies each imputed dataset (from Stata's internal `mi` structure).
#'
#' @references http://www.stata-press.com/data/r17/mheart1s20.dta
#'
#' @rdname mheart1s20
#' @note The original dataset with missingness consists of 154 patients and can be obtained by subsetting for `X_mi_m == 0`.
#' @note A version of this dataset in `mids` format (for compatibility with {mice} is included).
#'
#' @examples
#' data("mheart1s20", package = "mice.mcerror")
"mheart1s20"

#' @rdname mheart1s20
#'
#' @examples
#' data("mheart1s20.mice", package = "mice.mcerror")
"mheart1s20.mice"
