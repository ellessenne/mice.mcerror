devtools::load_all()
x <- rnorm(200)
jackknife(x, mean)
