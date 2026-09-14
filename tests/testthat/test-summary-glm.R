test_that("gaussian glm summary has expected short output", {
  output <- summary_output(
    "x <- glm(dist ~ speed, data = cars, family = gaussian)"
  )
  expect_snapshot(output)
})

test_that("binomial glm summary has expected short output", {
  output <- summary_output(
    "x <- glm(am ~ wt + hp, data = mtcars, family = binomial)"
  )
  expect_snapshot(output)
})

test_that("Poisson glm summary has expected short output", {
  output <- summary_output(
    "x <- glm(cyl ~ mpg + hp, data = mtcars, family = poisson)"
  )
  expect_snapshot(output)
})

test_that("gaussian glm summary is shortened", {
  x <- expect_shortsummary(
    "x <- glm(dist ~ speed, data = cars, family = gaussian)"
  )

  expect_no_match(x$short, "^Call:")
  expect_no_match(x$short, "AIC:")
  expect_no_match(x$short, "Number of Fisher Scoring iterations")
  expect_match(x$short, "Estimate")
  expect_match(x$short, "Null deviance")
  expect_match(x$short, "Residual deviance")
})

test_that("binomial glm summary is shortened", {
  x <- expect_shortsummary(
    "x <- glm(am ~ wt + hp, data = mtcars, family = binomial)"
  )

  expect_no_match(x$short, "^Call:")
  expect_no_match(x$short, "AIC:")
  expect_no_match(x$short, "Number of Fisher Scoring iterations")
  expect_no_match(x$short, "Dispersion parameter for binomial")
  expect_match(x$short, "Null deviance")
  expect_match(x$short, "Residual deviance")
})

test_that("Poisson glm summary is shortened", {
  x <- expect_shortsummary(
    "x <- glm(cyl ~ mpg + hp, data = mtcars, family = poisson)"
  )

  expect_no_match(x$short, "^Call:")
  expect_no_match(x$short, "AIC:")
  expect_no_match(x$short, "Number of Fisher Scoring iterations")
  expect_no_match(x$short, "Dispersion parameter for poisson")
  expect_match(x$short, "Null deviance")
  expect_match(x$short, "Residual deviance")
})

test_that("glm summary supports show.nobs", {
  output <- run_r(
    c(
      "x <- glm(am ~ wt + hp, data = mtcars, family = binomial)",
      "print(summary(x), show.nobs = TRUE)"
    ),
    shortsummary = TRUE
  )

  expect_match(output, "n = 32")
})
