testthat::test_that("mheart1s20", {
  data("mheart1s20")

  testthat::expect_equal(object = nrow(mheart1s20), expected = 594)
  testthat::expect_equal(object = ncol(mheart1s20), expected = 9)
  testthat::expect_s3_class(object = mheart1s20, class = "data.frame")
})
