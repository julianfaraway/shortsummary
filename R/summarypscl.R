#' Replaces default hurdle version by removing useless call and residuals info 
#'
#' @param x an object of class "summary.hurdle", usually, a result of a call to summary().
#' @param digits the number of significant digits to use when printing.
#' @param ... further arguments passed to or from other methods.
#' @return Nothing - prints output only.
#' @export print.summary.hurdle
print.summary.hurdle <- function (x, digits = max(3, getOption("digits") - 3), ...) 
{
  if (!x$converged) {
    cat("model did not converge\n")
  }
  else {
    cat(paste("Count model coefficients (truncated ", x$dist$count, 
              " with log link):\n", sep = ""))
    printCoefmat(x$coefficients$count, digits = digits, signif.legend = FALSE)
    zero_dist <- if (x$dist$zero != "binomial") 
      paste("censored", x$dist$zero, "with log link")
    else paste("binomial with", x$link, "link")
    cat(paste("Zero hurdle model coefficients (", zero_dist, 
              "):\n", sep = ""))
    printCoefmat(x$coefficients$zero, digits = digits, signif.legend = FALSE)
    if (getOption("show.signif.stars") & any(rbind(x$coefficients$count, 
                                                   x$coefficients$zero)[, 4] < 0.1, na.rm = TRUE)) 
      cat("---\nSignif. codes: ", "0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1", 
          "\n")
    if (!is.null(x$theta)) 
      cat(paste("\nTheta:", paste(names(x$theta), round(x$theta, 
                                                        digits), sep = " = ", collapse = ", ")))
  }
  invisible(x)
}
#' Shorter version of hurdle model output
#'
#' @param x an object of class "hurdle", usually, a result of a call to hurdle().
#' @param digits the number of significant digits to use when printing.
#' @param ... further arguments passed to or from other methods.
#' @return Nothing - prints output only.
#' @export print.hurdle
print.hurdle <- function (x, digits = max(3, getOption("digits") - 3), ...) 
{
  if (!x$converged) {
    cat("model did not converge\n")
  }
  else {
    cat(paste("Count model coefficients (truncated ", x$dist$count, 
              " with log link):\n", sep = ""))
    print.default(format(x$coefficients$count, digits = digits), 
                  print.gap = 2, quote = FALSE)
    if (x$dist$count == "negbin") 
      cat(paste("Theta =", round(x$theta["count"], digits), 
                "\n"))
    zero_dist <- if (x$dist$zero != "binomial") 
      paste("censored", x$dist$zero, "with log link")
    else paste("binomial with", x$link, "link")
    cat(paste("\nZero hurdle model coefficients (", zero_dist, 
              "):\n", sep = ""))
    print.default(format(x$coefficients$zero, digits = digits), 
                  print.gap = 2, quote = FALSE)
    if (x$dist$zero == "negbin") 
      cat(paste("Theta =", round(x$theta["zero"], digits), 
                "\n"))
  }
  invisible(x)
}
#' Replaces default zeroinfl version by removing useless call and residuals info 
#'
#' @param x an object of class "summary.zeroinfl", usually, a result of a call to summary().
#' @param digits the number of significant digits to use when printing.
#' @param ... further arguments passed to or from other methods.
#' @return Nothing - prints output only.
#' @export print.summary.zeroinfl
print.summary.zeroinfl <- function (x, digits = max(3, getOption("digits") - 3), ...) 
{
  if (!x$converged) {
    cat("model did not converge\n")
  }
  else {
    cat(paste("Count model coefficients (", x$dist, " with log link):\n", 
              sep = ""))
    printCoefmat(x$coefficients$count, digits = digits, signif.legend = FALSE)
    cat(paste("\nZero-inflation model coefficients (binomial with ", 
              x$link, " link):\n", sep = ""))
    printCoefmat(x$coefficients$zero, digits = digits, signif.legend = FALSE)
    if (getOption("show.signif.stars") & any(rbind(x$coefficients$count, 
                                                   x$coefficients$zero)[, 4] < 0.1, na.rm = TRUE)) 
      cat("---\nSignif. codes: ", "0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1", 
          "\n")
    if (x$dist == "negbin") 
      cat(paste("\nTheta =", round(x$theta, digits), "\n"))
  }
  invisible(x)
}
#' Shorter version of zeroinfl model output
#'
#' @param x an object of class "zeroinfl", usually, a result of a call to zeroinfl().
#' @param digits the number of significant digits to use when printing.
#' @param ... further arguments passed to or from other methods.
#' @return Nothing - prints output only.
#' @export print.zeroinfl
print.zeroinfl <- function (x, digits = max(3, getOption("digits") - 3), ...) 
{
  if (!x$converged) {
    cat("model did not converge\n")
  }
  else {
    cat(paste("Count model coefficients (", x$dist, " with log link):\n", 
              sep = ""))
    print.default(format(x$coefficients$count, digits = digits), 
                  print.gap = 2, quote = FALSE)
    if (x$dist == "negbin") 
      cat(paste("Theta =", round(x$theta, digits), "\n"))
    cat(paste("\nZero-inflation model coefficients (binomial with ", 
              x$link, " link):\n", sep = ""))
    print.default(format(x$coefficients$zero, digits = digits), 
                  print.gap = 2, quote = FALSE)
  }
  invisible(x)
}