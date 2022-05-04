x1 <- stats::rnorm(50)
x2 <- stats::rnorm(200)
m1 <- sapply(X = seq_along(x1), FUN = function(i) mean(x1[-i]))
m2 <- sapply(X = seq_along(x2), FUN = function(i) mean(x2[-i]))

testthat::test_that(".jackknife_se returns a single numeric value", {
  testthat::expect_length(object = .jackknife_se(u = m1), n = 1)
  testthat::expect_length(object = .jackknife_se(u = m2), n = 1)
})

testthat::test_that(".jackknife_se is smaller with larger sample size", {
  testthat::expect_true(object = .jackknife_se(u = m1) > .jackknife_se(u = m2))
})
