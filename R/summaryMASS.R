#' Replaces default polr version by removing  call info 
#'
#' @param x an object of class "summary.polr", usually, a result of a call to summary().
#' @param digits the number of significant digits to use when printing.
#' @param ... further arguments passed to or from other methods.
#' @return Nothing - prints output only.
#' @export print.summary.polr
print.summary.polr <- function (x, digits = x$digits, ...) 
{
  coef <- format(round(x$coefficients, digits = digits))
  pc <- x$pc
  if (pc > 0) {
    cat("Coefficients:\n")
    print(x$coefficients[seq_len(pc), , drop = FALSE], quote = FALSE, 
          digits = digits, ...)
  }
  else {
    cat("No coefficients\n")
  }
  cat("\nIntercepts:\n")
  print(coef[(pc + 1L):nrow(coef), , drop = FALSE], quote = FALSE, 
        digits = digits, ...)
  cat("\nResidual Deviance:", format(x$deviance, nsmall = 2L), 
      "\n")
  cat("AIC:", format(x$deviance + 2 * x$edf, nsmall = 2L), 
      "\n")
  if (nzchar(mess <- naprint(x$na.action))) 
    cat("(", mess, ")\n", sep = "")
  if (!is.null(correl <- x$correlation)) {
    cat("\nCorrelation of Coefficients:\n")
    ll <- lower.tri(correl)
    correl[ll] <- format(round(correl[ll], digits))
    correl[!ll] <- ""
    print(correl[-1L, -ncol(correl)], quote = FALSE, ...)
  }
  invisible(x)
}
#' Replaces default polr version by removing  call info 
#'
#' @param x an object of class "polr", usually, a result of a call to polr().
#' @param digits the number of significant digits to use when printing.
#' @param ... further arguments passed to or from other methods.
#' @return Nothing - prints output only.
#' @export print.polr
print.polr <- function (x, ...) 
{
  if (length(coef(x))) {
    cat("Coefficients:\n")
    print(coef(x), ...)
  }
  else {
    cat("No coefficients\n")
  }
  cat("\nIntercepts:\n")
  print(x$zeta, ...)
  cat("\nResidual Deviance:", format(x$deviance, nsmall = 2L), 
      "\n")
  cat("AIC:", format(x$deviance + 2 * x$edf, nsmall = 2L), 
      "\n")
  if (nzchar(mess <- naprint(x$na.action))) 
    cat("(", mess, ")\n", sep = "")
  if (x$convergence > 0) 
    cat("Warning: did not converge as iteration limit reached\n")
  invisible(x)
}
#' Replaces default polr version by removing  call info 
#'
#' @param x an object of class "polr", usually, a result of a call to polr().
#' @param digits the number of significant digits to use when printing.
#' @param ... further arguments passed to or from other methods.
#' @return Nothing - prints output only.
#' @export print.polr
print.lda <- function (x, ...) 
{
  cat("Prior probabilities of groups:\n")
  print(x$prior, ...)
  cat("\nGroup means:\n")
  print(x$means, ...)
  cat("\nCoefficients of linear discriminants:\n")
  print(x$scaling, ...)
  svd <- x$svd
  names(svd) <- dimnames(x$scaling)[[2L]]
  if (length(svd) > 1L) {
    cat("\nProportion of trace:\n")
    print(round(svd^2/sum(svd^2), 4L), ...)
  }
  invisible(x)
}