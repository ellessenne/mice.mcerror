#' @keywords internal
#'
#' @note This is the function to calculate the jackknife standard error of pooled estimates.
#'  `u` is the 'leave-one-out' statistic values whose SE is to be calculated.
.jackknife_se <- function(u) {
  n <- length(u)
  sqrt(((n - 1) / n) * sum((u - mean(u))^2))
}
