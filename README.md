
<!-- README.md is generated from README.Rmd. Please edit that file -->

# mice.mcerror

<!-- badges: start -->
<!-- badges: end -->

The {mice.mcerror} package is an add-on package to
{[mice](https://CRAN.R-project.org/package=mice)} that can be used to
calculate Monte Carlo error estimates for statistics computed using
multiply imputed data.

## Installation

You can install the development version of {mice.mcerror} from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("ellessenne/mice.mcerror")
```

# Comparison with Stata

We replicate the following example from Stata:

``` stata
use http://www.stata-press.com/data/r14/mheart1s20

mi estimate, dots mcerror: logit attack smokes age bmi hsgrad female
```

``` r
library(mice)
#> 
#> Attaching package: 'mice'
#> The following object is masked from 'package:stats':
#> 
#>     filter
#> The following objects are masked from 'package:base':
#> 
#>     cbind, rbind
data("mheart1s20.mice")

fit <- with(
  data = mheart1s20.mice,
  expr = glm(
    formula = attack ~ smokes + age + bmi + hsgrad + female,
    family = binomial(link = "logit")
  )
)
summary(pool(fit))
#>          term    estimate  std.error  statistic       df     p.value
#> 1 (Intercept) -5.47814267 1.68507424 -3.2509800 126.8211 0.001473199
#> 2      smokes  1.19859490 0.35781943  3.3497199 144.8489 0.001031456
#> 3         age  0.03601589 0.01543992  2.3326480 145.0907 0.021041181
#> 4         bmi  0.10394161 0.04761362  2.1830229 113.0103 0.031102235
#> 5      hsgrad  0.15789925 0.40492566  0.3899463 144.3469 0.697151071
#> 6      female -0.10674329 0.41647344 -0.2563028 144.9173 0.798080548
```
