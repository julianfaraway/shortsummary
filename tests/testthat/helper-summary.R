run_r <- function(code, packages = character(), shortsummary = FALSE) {
  script <- tempfile(fileext = ".R")
  on.exit(unlink(script), add = TRUE)

  lines <- c(
    "options(warn = 1)"
  )

  # shortsummary must be loaded before packages whose print methods it replaces.
  if (shortsummary) {
    lines <- c(lines, "suppressPackageStartupMessages(suppressWarnings(library(shortsummary)))")
  }

  if (length(packages)) {
    lines <- c(
      lines,
      sprintf(
        "suppressPackageStartupMessages(suppressWarnings(library(%s)))",
        packages
      )
    )
  }

  lines <- c(lines, code)
  writeLines(lines, script)

  output <- system2(
    file.path(R.home("bin"), "Rscript"),
    c("--vanilla", script),
    stdout = TRUE,
    stderr = TRUE
  )

  status <- attr(output, "status")
  output <- paste(output, collapse = "\n")

  if (!is.null(status) && status != 0) {
    stop("R subprocess failed:\n", output, call. = FALSE)
  }

  output
}

summary_output <- function(code,
                           packages = character(),
                           shortsummary = TRUE) {
  run_r(
    c(code, "print(summary(x))"),
    packages = packages,
    shortsummary = shortsummary
  )
}

expect_shortsummary <- function(code, packages = character()) {
  standard <- summary_output(
    code,
    packages = packages,
    shortsummary = FALSE
  )

  short <- summary_output(
    code,
    packages = packages,
    shortsummary = TRUE
  )

  expect_false(
    identical(standard, short),
    "shortsummary did not change the printed output"
  )

  expect_lt(
    nchar(short),
    nchar(standard),
    "shortsummary output is not shorter than standard R output"
  )

  list(standard = standard, short = short)
}
