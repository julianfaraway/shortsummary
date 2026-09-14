test_that("lda printing is shortened", {
  output <- run_r(
    c(
      "x <- MASS::lda(Species ~ Sepal.Length + Sepal.Width + Petal.Length + Petal.Width, data = iris)",
      "print(x)"
    ),
    packages = "MASS",
    shortsummary = FALSE
  )

  short <- run_r(
    c(
      "x <- MASS::lda(Species ~ Sepal.Length + Sepal.Width + Petal.Length + Petal.Width, data = iris)",
      "print(x)"
    ),
    packages = "MASS",
    shortsummary = TRUE
  )

  expect_false(identical(output, short))
  expect_lt(nchar(short), nchar(output))
})
