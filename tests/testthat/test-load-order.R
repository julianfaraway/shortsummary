test_that("shortsummary is loaded before optional packages", {
  output <- run_r(
    c(
      "x <- lm(dist ~ speed, data = cars)",
      "print(summary(x))"
    ),
    shortsummary = TRUE
  )

  expect_no_match(output, "^Call:")
  expect_no_match(output, "Residuals:")
  expect_match(output, "Estimate")
})

test_that("shortsummary remains active for a package loaded afterwards", {
  skip_if_not_installed("mgcv")

  output <- run_r(
    c(
      "x <- mgcv::gam(mpg ~ s(hp) + wt, data = mtcars)",
      "print(summary(x))"
    ),
    packages = "mgcv",
    shortsummary = TRUE
  )

  expect_no_match(output, "^Call:")
  expect_match(output, "Parametric coefficients:")
})
