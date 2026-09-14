test_that("gls summary has expected short output", {
  skip_if_not_installed("nlme")
  output <- summary_output(
    "x <- nlme::gls(distance ~ age, data = nlme::Orthodont)",
    packages = "nlme"
  )
  expect_snapshot(output)
})

test_that("gls summary is shortened", {
  skip_if_not_installed("nlme")
  x <- expect_shortsummary(
    "x <- nlme::gls(distance ~ age, data = nlme::Orthodont)",
    packages = "nlme"
  )
  expect_no_match(x$short, "Generalized least squares fit")
  expect_match(x$short, "Value")
})

test_that("lme summary has expected short output", {
  skip_if_not_installed("nlme")
  output <- summary_output(
    "x <- nlme::lme(distance ~ age, random = ~ age | Subject, data = nlme::Orthodont)",
    packages = "nlme"
  )
  expect_snapshot(output)
})

test_that("lme summary is shortened", {
  skip_if_not_installed("nlme")
  x <- expect_shortsummary(
    "x <- nlme::lme(distance ~ age, random = ~ age | Subject, data = nlme::Orthodont)",
    packages = "nlme"
  )
  expect_no_match(x$short, "Linear mixed-effects model fit by REML")
  expect_match(x$short, "Random effects:")
  expect_match(x$short, "Fixed effects:")
})

test_that("merMod summary has expected short output", {
  skip_if_not_installed("lme4")
  output <- summary_output(
    "x <- lme4::lmer(Reaction ~ Days + (Days | Subject), data = lme4::sleepstudy)",
    packages = "lme4"
  )
  expect_snapshot(output)
})

test_that("merMod summary is shortened", {
  skip_if_not_installed("lme4")
  x <- expect_shortsummary(
    "x <- lme4::lmer(Reaction ~ Days + (Days | Subject), data = lme4::sleepstudy)",
    packages = "lme4"
  )
  expect_no_match(x$short, "Linear mixed model fit by REML")
  expect_match(x$short, "Random effects:")
  expect_match(x$short, "Fixed effects:")
})

test_that("gam summary has expected short output", {
  skip_if_not_installed("mgcv")
  output <- summary_output(
    "x <- mgcv::gam(mpg ~ s(hp) + wt, data = mtcars)",
    packages = "mgcv"
  )
  expect_snapshot(output)
})

test_that("gam summary is shortened", {
  skip_if_not_installed("mgcv")
  x <- expect_shortsummary(
    "x <- mgcv::gam(mpg ~ s(hp) + wt, data = mtcars)",
    packages = "mgcv"
  )
  expect_no_match(x$short, "^Call:")
  expect_match(x$short, "Parametric coefficients:")
  expect_match(x$short, "Approximate significance of smooth terms:")
})

test_that("coxph summary has expected short output", {
  skip_if_not_installed("survival")
  output <- summary_output(
    "x <- survival::coxph(survival::Surv(futime, fustat) ~ age + rx, data = survival::ovarian)",
    packages = "survival"
  )
  expect_snapshot(output)
})

test_that("coxph summary is shortened", {
  skip_if_not_installed("survival")
  x <- expect_shortsummary(
    "x <- survival::coxph(survival::Surv(futime, fustat) ~ age + rx, data = survival::ovarian)",
    packages = "survival"
  )
  expect_no_match(x$short, "^Call:")
  expect_match(x$short, "coef")
})

test_that("hurdle summary has expected short output", {
  skip_if_not_installed("pscl")
  output <- summary_output(
    "x <- pscl::hurdle(art ~ fem + mar + kid5 + phd + ment, data = pscl::bioChemists, dist = 'poisson')",
    packages = "pscl"
  )
  expect_snapshot(output)
})

test_that("hurdle summary is shortened", {
  skip_if_not_installed("pscl")
  x <- expect_shortsummary(
    "x <- pscl::hurdle(art ~ fem + mar + kid5 + phd + ment, data = pscl::bioChemists, dist = 'poisson')",
    packages = "pscl"
  )
  expect_no_match(x$short, "^Call:")
  expect_match(x$short, "Count model")
})

test_that("zeroinfl summary has expected short output", {
  skip_if_not_installed("pscl")
  output <- summary_output(
    "x <- pscl::zeroinfl(art ~ fem + mar + kid5 + phd + ment | fem + mar + kid5, data = pscl::bioChemists, dist = 'poisson')",
    packages = "pscl"
  )
  expect_snapshot(output)
})

test_that("zeroinfl summary is shortened", {
  skip_if_not_installed("pscl")
  x <- expect_shortsummary(
    "x <- pscl::zeroinfl(art ~ fem + mar + kid5 + phd + ment | fem + mar + kid5, data = pscl::bioChemists, dist = 'poisson')",
    packages = "pscl"
  )
  expect_no_match(x$short, "^Call:")
  expect_match(x$short, "Count model")
})

test_that("polr summary has expected short output", {
  skip_if_not_installed("MASS")
  output <- summary_output(
    "x <- MASS::polr(Sat ~ Infl + Type + Cont, data = MASS::housing, Hess = TRUE)",
    packages = "MASS"
  )
  # polr's optimizer can differ at machine precision across R/platforms.
  # Snapshot the printed structure while redacting numerical values.
  output <- gsub(
    "[-+]?(?:[0-9]+\\.?[0-9]*|\\.[0-9]+)(?:[eE][-+]?[0-9]+)?",
    "<NUM>",
    output,
    perl = TRUE
  )
  expect_snapshot(output)
})

test_that("polr summary is shortened", {
  skip_if_not_installed("MASS")
  x <- expect_shortsummary(
    "x <- MASS::polr(Sat ~ Infl + Type + Cont, data = MASS::housing, Hess = TRUE)",
    packages = "MASS"
  )
  expect_no_match(x$short, "^Call:")
  expect_match(x$short, "Coefficients:")
  expect_match(x$short, "Intercepts:")
})

test_that("all supported optional summaries are shorter", {
  cases <- list(
    gls = list(
      package = "nlme",
      code = "x <- nlme::gls(distance ~ age, data = nlme::Orthodont)"
    ),
    lme = list(
      package = "nlme",
      code = "x <- nlme::lme(distance ~ age, random = ~ age | Subject, data = nlme::Orthodont)"
    ),
    merMod = list(
      package = "lme4",
      code = "x <- lme4::lmer(Reaction ~ Days + (Days | Subject), data = lme4::sleepstudy)"
    ),
    gam = list(
      package = "mgcv",
      code = "x <- mgcv::gam(mpg ~ s(hp) + wt, data = mtcars)"
    ),
    coxph = list(
      package = "survival",
      code = "x <- survival::coxph(survival::Surv(futime, fustat) ~ age + rx, data = survival::ovarian)"
    ),
    hurdle = list(
      package = "pscl",
      code = "x <- pscl::hurdle(art ~ fem + mar + kid5 + phd + ment, data = pscl::bioChemists, dist = 'poisson')"
    ),
    zeroinfl = list(
      package = "pscl",
      code = "x <- pscl::zeroinfl(art ~ fem + mar + kid5 + phd + ment | fem + mar + kid5, data = pscl::bioChemists, dist = 'poisson')"
    ),
    polr = list(
      package = "MASS",
      code = "x <- MASS::polr(Sat ~ Infl + Type + Cont, data = MASS::housing, Hess = TRUE)"
    )
  )

  for (case in cases) {
    skip_if_not_installed(case$package)
    result <- expect_shortsummary(case$code, packages = case$package)
    expect_lt(nchar(result$short), nchar(result$standard))
  }
})
