devtools::load_all()

library(mice)
data("mheart1s20.mice")
fit <- with(
  data = mheart1s20.mice,
  expr = glm(
    formula = attack ~ smokes + age + bmi + hsgrad + female,
    family = binomial(link = "logit")
  )
)
summary(pool(fit), conf.int = TRUE)
mce <- mcerror(fit, conf.int = TRUE)
print(mce)
summary(mce)
