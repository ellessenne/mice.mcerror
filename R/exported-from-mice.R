#' @keywords internal
#' @note This is copied over from mice:::get.dfcom, which is unfortunately not exported...
get.dfcom <- function(object, dfcom = NULL) {
  if (!is.null(dfcom)) {
    return(max(dfcom, 1L))
  }
  glanced <- get.glanced(object)
  if (!is.null(glanced)) {
    if ("df.residual" %in% colnames(glanced)) {
      return(glanced$df.residual[1L])
    }
  }
  if (!is.null(glanced)) {
    if ("nobs" %in% colnames(glanced)) {
      model <- mice::getfit(object, 1L)
      if (inherits(model, "coxph")) {
        return(max(
          model$nevent - length(stats::coef(model)),
          1L
        ))
      }
      return(max(
        glanced$nobs[1L] - length(stats::coef(model)),
        1L
      ))
    }
  }
  warning("Infinite sample size assumed.")
  Inf
}

#' @keywords internal
#' @note This is copied over from mice:::get.glanced, which is unfortunately not exported...
get.glanced <- function(object) {
  if (!is.list(object)) {
    stop("Argument 'object' not a list", call. = FALSE)
  }
  object <- mice::as.mira(object)
  glanced <- try(data.frame(summary(mice::getfit(object), type = "glance")),
    silent = TRUE
  )
  if (inherits(glanced, "data.frame")) {
    if (!"nobs" %in% colnames(glanced)) {
      glanced$nobs <- length(stats::residuals(object$analyses[[1]]))
    }
  } else {
    glanced <- NULL
  }
  glanced
}
