% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/mcerror.R
\name{mcerror}
\alias{mcerror}
\alias{print.mimcerror}
\alias{summary.mimcerror}
\title{Monte Carlo Errors}
\usage{
mcerror(object, dfcom = NULL, rule = NULL, conf.int = FALSE, conf.level = 0.95)

\method{print}{mimcerror}(x, ...)

\method{summary}{mimcerror}(object, ...)
}
\arguments{
\item{object}{An object of class \code{mimcerror} to summarise.}

\item{dfcom}{A positive number representing the degrees of freedom in the complete-data analysis.
Normally, this would be the number of independent observation minus the number of fitted parameters.
The default (\code{dfcom = NULL}) extract this information in the following order:
1- The component \code{residual.df} returned by \code{glance()} if a \code{glance()} function is found,
2- The result of \verb{df.residual(} applied to the first fitted model, and
3- 999999.
In the last case, the warning \emph{Large sample assumed} is printed.
If the degrees of freedom is incorrect, specify the appropriate value manually.}

\item{rule}{A string indicating the pooling rule.
Currently supported are \code{"rubin1987"} (default, for missing data) and \code{"reiter2003"} (for synthetic data created from a complete data set).}

\item{conf.int}{Whether Monte Carlo errors for model parameter confidence intervals are to be calculated.
Defaults to \code{FALSE}.}

\item{conf.level}{Confidence level for the confidence intervals, defaulting to 0.95.}

\item{x}{An object of class \code{mimcerror} to print.}

\item{...}{Additional arguments to be passed to \code{\link[=print.data.frame]{print.data.frame()}}.}
}
\description{
Calculate Monte Carlo errors for statistics calculated by combining results of multiply imputed datasets.
Monte Carlo errors are defined as the standard deviation of the results across repeated runs of the same
imputation procedure using the same data.
White, Royston, and Wood (2011) suggest evaluating Monte Carlo error estimates not only for parameter
estimates but also for other statistics, including p-values and confidence intervals, as well as
multiple imputations statistics such as RVI and FMI.
}
\note{
This function calculate and displays Monte Carlo errors for statistics calculated by the \code{\link[mice:pool]{mice::pool()}} function or by the summary of it.
}
\examples{
library(mice)
library(mice.mcerror)
data("mheart1s20.mice")
fit <- with(
  data = mheart1s20.mice,
  expr = glm(
    formula = attack ~ smokes + age + bmi + hsgrad + female,
    family = binomial(link = "logit")
  )
)

mce <- mcerror(fit)

mce

summary(mce)
}
