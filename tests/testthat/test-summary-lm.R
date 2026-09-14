test_that("lm summary has expected short output", {
  output <- summary_output("x <- lm(dist ~ speed, data = cars)")
  expect_snapshot(output)
})

test_that("lm summary is shortened", {
  x <- expect_shortsummary("x <- lm(dist ~ speed, data = cars)")

  expect_no_match(x$short, "^Call:")
  expect_no_match(x$short, "Residuals:")
  expect_match(x$short, "Estimate")
  expect_match(x$short, "Residual standard error")
})

test_that("lm concise can be disabled", {
  output <- run_r(
    c(
      "x <- lm(dist ~ speed, data = cars)",
      "print(summary(x), concise = FALSE)"
    ),
    shortsummary = TRUE
  )

  expect_match(output, "Call:")
  expect_match(output, "Residuals:")
  expect_match(output, "Coefficients:")
})

test_that("lm summary supports show.nobs", {
  output <- run_r(
    c(
      "x <- lm(dist ~ speed, data = cars)",
      "print(summary(x), show.nobs = TRUE)"
    ),
    shortsummary = TRUE
  )

  expect_match(output, "n = 50")
  expect_match(output, "p = 2")
})
