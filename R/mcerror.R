#' @title Monte Carlo Errors
#'
#' @description Calculate Monte Carlo errors for statistics calculated by combining results of multiply imputed datasets.
#' Monte Carlo errors are defined as the standard deviation of the results across repeated runs of the same
#' imputation procedure using the same data.
#' White, Royston, and Wood (2011) suggest evaluating Monte Carlo error estimates not only for parameter
#' estimates but also for other statistics, including p-values and confidence intervals, as well as
#' multiple imputations statistics such as RVI and FMI.
#'
#' @param object An object of class `mira` (produced by [mice::with.mids()] or [mice::as.mira()]), or a list with model fits.
#' @param dfcom A positive number representing the degrees of freedom in the complete-data analysis.
#' Normally, this would be the number of independent observation minus the number of fitted parameters.
#' The default (`dfcom = NULL`) extract this information in the following order:
#' 1- The component `residual.df` returned by `glance()` if a `glance()` function is found,
#' 2- The result of `df.residual(` applied to the first fitted model, and
#' 3- 999999.
#' In the last case, the warning _Large sample assumed_ is printed.
#' If the degrees of freedom is incorrect, specify the appropriate value manually.
#' @param rule A string indicating the pooling rule.
#' Currently supported are `"rubin1987"` (default, for missing data) and `"reiter2003"` (for synthetic data created from a complete data set).
#' @param conf.int Whether Monte Carlo errors for model parameter confidence intervals are to be calculated.
#' Defaults to `FALSE`.
#' @param conf.level Confidence level for the confidence intervals, defaulting to 0.95.
#'
#' @note This function calculate and displays Monte Carlo errors for statistics calculated by the [mice::pool()] function or by the summary of it.
#'
#' @rdname mcerror
#'
#' @export
#'
#' @examples
#' library(mice)
#' library(mice.mcerror)
#' data("mheart1s20.mice")
#' fit <- with(
#'   data = mheart1s20.mice,
#'   expr = glm(
#'     formula = attack ~ smokes + age + bmi + hsgrad + female,
#'     family = binomial(link = "logit")
#'   )
#' )
#'
#' mce <- mcerror(fit)
#'
#' mce
#'
#' summary(mce)
mcerror <- function(object, dfcom = NULL, rule = NULL, conf.int = FALSE, conf.level = 0.95) {
  call <- match.call()
  if (!is.list(object)) {
    stop("Argument 'object' not a list", call. = FALSE)
  }
  object <- mice::as.mira(object)
  m <- length(object$analyses)
  if (m == 1) {
    stop("Number of multiple imputations m = 1, cannot estimate Monte Carlo errors.")
  }
  dfcom <- get.dfcom(object, dfcom)
  pooled_list <- vector(mode = "list", length = m)
  for (i in seq(m)) {
    object_sub <- object
    object_sub$analyses <- object_sub$analyses[-i]
    out <- mice::pool(mice::getfit(object_sub), dfcom = dfcom, rule = rule)$pooled
    out$std.error <- sqrt(out$t)
    out$statistic <- out$estimate / out$std.error
    out$p.value <- 2 * (1 - stats::pt(abs(out$statistic), pmax(out$df, 0.001)))
    if (conf.int) {
      out$lower <- out$estimate - out$std.error * stats::qt(p = 1 - (1 - conf.level) / 2, df = pmax(out$df, 0.001))
      out$upper <- out$estimate + out$std.error * stats::qt(p = 1 - (1 - conf.level) / 2, df = pmax(out$df, 0.001))
    }
    out$m <- NULL
    out$dfcom <- NULL
    pooled_list[[i]] <- out
  }
  pooled_list <- do.call(rbind.data.frame, pooled_list)
  pooled_list <- split(x = pooled_list, f = pooled_list$term)
  pooled_combined <- vector(mode = "list", length = length(pooled_list))
  for (i in seq(length(pooled_list))) {
    res <- data.frame(
      term = unique(pooled_list[[i]]$term)
    )
    for (nam in names(pooled_list[[i]])[names(pooled_list[[i]]) != "term"]) {
      res[[nam]] <- .jackknife_se(u = pooled_list[[i]][[nam]])
    }
    pooled_combined[[i]] <- res
  }
  pooled <- do.call(rbind.data.frame, pooled_combined)
  names(pooled)[names(pooled) == "lower"] <- paste((1 - conf.level) / 2 * 100, "%")
  names(pooled)[names(pooled) == "upper"] <- paste((1 - (1 - conf.level) / 2) * 100, "%")
  rr <- list(call = call, m = m, pooled = pooled)
  class(rr) <- c("mimcerror", "data.frame")
  return(rr)
}

#' @rdname mcerror
#'
#' @param x An object of class `mimcerror` to print.
#' @param ... Additional arguments to be passed to [print.data.frame()].
#'
#' @export
print.mimcerror <- function(x, ...) {
  cat("Class: mimcerror    m =", x$m, "\n")
  idx <- which(!(grepl(pattern = "%|std.error|statistic|p.value", x = names(x$pooled))))
  print.data.frame(x$pooled[, idx], ...)
  cat("Note: Values displayed are Monte Carlo error estimates.\n")
  invisible(x)
}

#' @rdname mcerror
#'
#' @param object An object of class `mimcerror` to summarise.
#' @param ... Additional arguments to be passed to [print.data.frame()].
#'
#' @export
summary.mimcerror <- function(object, ...) {
  idx <- which(grepl(pattern = "term|estimate|df|%|std.error|statistic|p.value", x = names(object$pooled)))
  toprint <- object$pooled[, idx]
  nms1 <- c("term", "estimate", "std.error", "statistic", "df", "p.value")
  nms2 <- names(toprint)[grepl(pattern = "%", x = names(toprint))]
  toprint <- toprint[, c(nms1, nms2)]
  print.data.frame(x = toprint, ...)
  cat("Note: Values displayed are Monte Carlo error estimates.\n")
  invisible(object)
}
