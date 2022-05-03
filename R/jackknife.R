#' @title Jackknife
#'
#' @description Calculate the jackknife standard error of a function `.f` using jackknife resampling.
#'
#' @param .x A vector of values.
#' @param .f A function that calculates a summary statistic of `.x`.
#' @param ... Additional arguments passed to `.f`.
#'
#' @export
#'
#' @examples
#' x <- rnorm(100)
#' jackknife(.x = x, .f = mean)
jackknife <- function(.x, .f, ...) {
  n <- length(.x)
  u <- rep(0, n)
  for (i in seq(n)) {
    u[i] <- .f(.x[-i], ...)
  }
  jack.se <- sqrt(((n - 1) / n) * sum((u - mean(u))^2))
  return(jack.se)
}
