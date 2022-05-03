x1 <- stats::rnorm(50)
x2 <- stats::rnorm(200)

testthat::test_that("jackknife returns a single numeric value", {
  testthat::expect_length(object = jackknife(.x = x1, .f = mean), n = 1)
  testthat::expect_length(object = jackknife(.x = x2, .f = mean), n = 1)
})

testthat::test_that("jackknife se is smaller with larger sample size", {
  testthat::expect_true(object = jackknife(.x = x1, .f = mean) > jackknife(.x = x2, .f = mean))
})
