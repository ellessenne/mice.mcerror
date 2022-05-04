
<!-- README.md is generated from README.Rmd. Please edit that file -->

Last updated: 2022-05-04 16:02:58

# mice.mcerror

<!-- badges: start -->

[![Codecov test
coverage](https://codecov.io/gh/ellessenne/mice.mcerror/branch/main/graph/badge.svg)](https://app.codecov.io/gh/ellessenne/mice.mcerror?branch=main)
[![R-CMD-check](https://github.com/ellessenne/mice.mcerror/workflows/R-CMD-check/badge.svg)](https://github.com/ellessenne/mice.mcerror/actions)
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
<!-- badges: end -->

The {mice.mcerror} package is an add-on package to
{[mice](https://CRAN.R-project.org/package=mice)} that can be used to
calculate Monte Carlo error estimates for statistics computed using
multiply imputed data.

Note that the Monte Carlo error estimate of an MI statistic is defined
as the standard error of the mean of the pseudo-values for that
statistic, computed by omitting one imputation at a time (i.e., using
the jackknife).

> *Warning:* this package is still experimental, so please test it out
> and find where it breaks!

## Installation

You can install the development version of {mice.mcerror} from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("ellessenne/mice.mcerror")
```

# Workflow

We replicate the following example from Stata:

``` stata
. use http://www.stata-press.com/data/r14/mheart1s20

. mi estimate, dots mcerror: logit attack smokes age bmi hsgrad female

Imputations (20):
  .........10.........20 done

Multiple-imputation estimates                   Imputations       =         20
Logistic regression                             Number of obs     =        154
                                                Average RVI       =     0.0312
                                                Largest FMI       =     0.1355
DF adjustment:   Large sample                   DF:     min       =   1,060.38
                                                        avg       = 223,362.56
                                                        max       = 493,335.88
Model F test:       Equal FMI                   F(   5,71379.3)   =       3.59
Within VCE type:          OIM                   Prob > F          =     0.0030

------------------------------------------------------------------------------
      attack |      Coef.   Std. Err.      t    P>|t|     [95% Conf. Interval]
-------------+----------------------------------------------------------------
      smokes |   1.198595   .3578195     3.35   0.001     .4972789    1.899911
             |   .0068541   .0008562     0.01   0.000     .0056572    .0082212
             |
         age |   .0360159   .0154399     2.33   0.020     .0057541    .0662776
             |   .0002654   .0000351     0.01   0.001     .0002319    .0003108
             |
         bmi |   .1039416   .0476136     2.18   0.029      .010514    .1973692
             |   .0038014   .0008904     0.09   0.006     .0039928    .0044049
             |
      hsgrad |   .1578992   .4049257     0.39   0.697    -.6357464    .9515449
             |   .0091517   .0010209     0.02   0.016     .0086215    .0100602
             |
      female |  -.1067433   .4164735    -0.26   0.798    -.9230191    .7095326
             |   .0077566   .0009279     0.02   0.015      .006985    .0088408
             |
       _cons |  -5.478143   1.685075    -3.25   0.001    -8.782394   -2.173892
             |   .1079841   .0248274     0.07   0.000     .1310618    .1050817
------------------------------------------------------------------------------
Note: Values displayed beneath estimates are Monte Carlo error estimates.
```

Using the {mice.mcerror} it is possible to replicate this. First, let’s
fit all models as you would do using {mice}:

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
library(mice.mcerror)

data("mheart1s20.mice")
fit <- with(
  data = mheart1s20.mice,
  expr = glm(
    formula = attack ~ smokes + age + bmi + hsgrad + female,
    family = binomial(link = "logit")
  )
)
```

The pooled estimates can be obtained by using the `summary()` and
`pool()` functions:

``` r
summary(pool(fit), conf.int = TRUE)
#>          term    estimate  std.error  statistic       df     p.value
#> 1 (Intercept) -5.47814267 1.68507424 -3.2509800 126.8211 0.001473199
#> 2      smokes  1.19859490 0.35781943  3.3497199 144.8489 0.001031456
#> 3         age  0.03601589 0.01543992  2.3326480 145.0907 0.021041181
#> 4         bmi  0.10394161 0.04761362  2.1830229 113.0103 0.031102235
#> 5      hsgrad  0.15789925 0.40492566  0.3899463 144.3469 0.697151071
#> 6      female -0.10674329 0.41647344 -0.2563028 144.9173 0.798080548
#>          2.5 %     97.5 %
#> 1 -8.812645721 -2.1436396
#> 2  0.491373044  1.9058167
#> 3  0.005499680  0.0665321
#> 4  0.009610547  0.1982727
#> 5 -0.642450426  0.9582489
#> 6 -0.929890162  0.7164036
```

Analogously, Monte Carlo errors can be computed using the `summary()`
and `mcerror()` functions:

``` r
summary(mcerror(fit), conf.int = TRUE)
#>          term     estimate    std.error  statistic        df       p.value
#> 1 (Intercept) 0.1079841257 0.0248274274 0.06805349 6.7080984 0.00032722871
#> 2      smokes 0.0068540746 0.0008562227 0.01391383 0.2809890 0.00004807809
#> 3         age 0.0002654228 0.0000350775 0.01472704 0.3241435 0.00079508665
#> 4         bmi 0.0038014054 0.0008904166 0.08508803 9.4563780 0.00635632037
#> 5      hsgrad 0.0091516583 0.0010209042 0.02227213 0.5925768 0.01642837575
#> 6      female 0.0077566042 0.0009278750 0.01893419 0.2898725 0.01458706658
#> Note: Values displayed are Monte Carlo error estimates.
```

Calling just `pool()` and `mcerror()` returns a larger set of imputation
statistics:

``` r
pool(fit)
#> Class: mipo    m = 20 
#>          term  m    estimate         ubar              b           t dfcom
#> 1 (Intercept) 20 -5.47814267 2.5946031821 0.233211428245 2.839475182   148
#> 2      smokes 20  1.19859490 0.1270482021 0.000939566769 0.128034747   148
#> 3         age 20  0.03601589 0.0002369116 0.000001408985 0.000238391   148
#> 4         bmi 20  0.10394161 0.0019635921 0.000289013657 0.002267056   148
#> 5      hsgrad 20  0.15789925 0.1622059843 0.001675056999 0.163964794   148
#> 6      female 20 -0.10674329 0.1721866640 0.001203298181 0.173450127   148
#>         df         riv      lambda        fmi
#> 1 126.8211 0.094377437 0.086238472 0.10031571
#> 2 144.8489 0.007765124 0.007705292 0.02112839
#> 3 145.0907 0.006244670 0.006205916 0.01962734
#> 4 113.0103 0.154545511 0.133858310 0.14879046
#> 5 144.3469 0.010843064 0.010726753 0.02415456
#> 6 144.9173 0.007337752 0.007284302 0.02070688
mcerror(fit)
#> Class: mimcerror    m = 20 
#>          term     estimate            ubar               b              t
#> 1 (Intercept) 0.1079841257 0.0296514752332 0.0700813711255 0.083436110077
#> 2      smokes 0.0068540746 0.0005593530661 0.0002105698954 0.000612572458
#> 3         age 0.0002654228 0.0000008618997 0.0000004631871 0.000001082963
#> 4         bmi 0.0038014054 0.0000260422478 0.0000769302779 0.000084618319
#> 5      hsgrad 0.0091516583 0.0005205921044 0.0005522879082 0.000826596530
#> 6      female 0.0077566042 0.0006140148450 0.0002974806046 0.000772802194
#>          df         riv      lambda         fmi
#> 1 6.7080984 0.028332497 0.023832967 0.024191009
#> 2 0.2809890 0.001743612 0.001717197 0.001719479
#> 3 0.3241435 0.002054099 0.002030107 0.002032066
#> 4 9.4563780 0.041340237 0.031262521 0.031939611
#> 5 0.5925768 0.003579272 0.003508304 0.003514678
#> 6 0.2898725 0.001810954 0.001785572 0.001787732
#> Note: Values displayed are Monte Carlo error estimates.
```

Compare this with results from Stata (displayed above) and see that they
*should* be the same!

Additional statistics can be obtained in Stata as follows:

``` stata
. mi estimate, vartable mcerror nocitable

Multiple-imputation estimates                   Imputations       =         20
Logistic regression

Variance information
------------------------------------------------------------------------------
             |        Imputation variance                             Relative
             |    Within   Between     Total       RVI       FMI    efficiency
-------------+----------------------------------------------------------------
      smokes |   .127048    .00094   .128035   .007765   .007711       .999615
             |   .000559   .000211   .000613   .001744    .00172        .00009
             |                                                  
         age |   .000237   1.4e-06   .000238   .006245    .00621        .99969
             |   8.6e-07   4.6e-07   1.1e-06   .002054   .002033       .000107
             |                                                  
         bmi |   .001964   .000289   .002267   .154545   .135487       .993271
             |   .000026   .000077   .000085    .04134   .031986        .00166
             |                                                  
      hsgrad |   .162206   .001675   .163965   .010843   .010739       .999463
             |   .000521   .000552   .000827   .003579   .003516       .000185
             |                                                  
      female |   .172187   .001203    .17345   .007338    .00729       .999636
             |   .000614   .000297   .000773   .001811   .001788       .000094
             |                                                  
       _cons |    2.5946   .233211   2.83948   .094377   .086953       .995671
             |   .029651   .070081   .083436   .028332   .024216       .001263
------------------------------------------------------------------------------
Note: Values displayed beneath estimates are Monte Carlo error estimates.
```
