#' Print glm summary
#'
#' Replaces default stats version by removing call info, AIC and Fisher scoring info.
#' Also removes "Coefficients:" line and other empty lines
#'
#' @param x an object of class "summary.glm", usually, a result of a call to summary.glm.
#' @param digits the number of significant digits to use when printing.
#' @param symbolic.cor logical. If TRUE, print the correlations in a symbolic form
#' @param signif.stars logical. If TRUE, ‘significance stars’ are printed for each coefficient.
#' @param show.residuals logical. If TRUE then a summary of the deviance residuals is printed at the head of the output.
#' @param concise logical. If TRUE, don't print the call, AIC and number of Fisher scoring iterations.
#' @param ... further arguments passed to or from other methods.
#' @return Nothing - prints output only.
#' @export print.summary.glm
print.summary.glm <-
  function (x, digits = max(3L, getOption("digits") - 3L), symbolic.cor = x$symbolic.cor,
          signif.stars = getOption("show.signif.stars"), show.residuals = FALSE,
          concise = TRUE, ...)
{
  if(!concise){
    cat("\nCall:\n", paste(deparse(x$call), sep = "\n", collapse = "\n"),
      "\n", sep = "")
  }
  if (show.residuals) {
    cat("\nDeviance Residuals: \n")
    if (x$df.residual > 5) {
      x$deviance.resid <- setNames(quantile(x$deviance.resid,
                                            na.rm = TRUE), c("Min", "1Q", "Median", "3Q",
                                                             "Max"))
    }
    xx <- zapsmall(x$deviance.resid, digits + 1L)
    print.default(xx, digits = digits, na.print = "", print.gap = 2L)
  }
  if (length(x$aliased) == 0L) {
    cat("\nNo Coefficients\n")
  }
  else {
    df <- if ("df" %in% names(x))
      x[["df"]]
    else NULL
    if (!is.null(df) && (nsingular <- df[3L] - df[1L]))
      cat("\nCoefficients: (", nsingular, " not defined because of singularities)\n",
          sep = "")
    coefs <- x$coefficients
    if (!is.null(aliased <- x$aliased) && any(aliased)) {
      cn <- names(aliased)
      coefs <- matrix(NA, length(aliased), 4L, dimnames = list(cn,
                                                               colnames(coefs)))
      coefs[!aliased, ] <- x$coefficients
    }
    printCoefmat(coefs, digits = digits, signif.stars = signif.stars,
                 na.print = "NA", ...)
  }
  cat("\n(Dispersion parameter for ", x$family$family, " family taken to be ",
      format(x$dispersion), ")\n\n", apply(cbind(paste(format(c("Null",
                                                                "Residual"), justify = "right"), "deviance:"), format(unlist(x[c("null.deviance",
                                                                                                                                 "deviance")]), digits = max(5L, digits + 1L)), " on",
                                                 format(unlist(x[c("df.null", "df.residual")])), " degrees of freedom\n"),
                                           1L, paste, collapse = " "), sep = "")
  if (nzchar(mess <- naprint(x$na.action)))
    cat("  (", mess, ")\n", sep = "")
  if(!concise){
    cat("AIC: ", format(x$aic, digits = max(4L, digits + 1L)),
      "\n\n", "Number of Fisher Scoring iterations: ", x$iter,
      "\n", sep = "")
  }
  correl <- x$correlation
  if (!is.null(correl)) {
    p <- NCOL(correl)
    if (p > 1) {
      cat("\nCorrelation of Coefficients:\n")
      if (is.logical(symbolic.cor) && symbolic.cor) {
        print(symnum(correl, abbr.colnames = NULL))
      }
      else {
        correl <- format(round(correl, 2L), nsmall = 2L,
                         digits = digits)
        correl[!lower.tri(correl)] <- ""
        print(correl[-1, -p, drop = FALSE], quote = FALSE)
      }
    }
  }
  invisible(x)
}
#' Replaces default stats version by removing useless call info 
#'
#' @param x an object of class "lm", usually, a result of a call to lm().
#' @param digits the number of significant digits to use when printing.
#' @param ... further arguments passed to or from other methods.
#' @return Nothing - prints output only.
#' @export print.glm
print.glm <- function (x, digits = max(3L, getOption("digits") - 3L), ...) 
{
  if (length(coef(x))) {
    cat("Coefficients")
    if (is.character(co <- x$contrasts)) 
      cat("  [contrasts: ", apply(cbind(names(co), co), 
                                  1L, paste, collapse = "="), "]")
    cat(":\n")
    print.default(format(x$coefficients, digits = digits), 
                  print.gap = 2, quote = FALSE)
  }
  else cat("No coefficients\n\n")
  cat("\nDegrees of Freedom:", x$df.null, "Total (i.e. Null); ", 
      x$df.residual, "Residual\n")
  if (nzchar(mess <- naprint(x$na.action))) 
    cat("  (", mess, ")\n", sep = "")
  cat("Null Deviance:\t   ", format(signif(x$null.deviance, 
                                           digits)), "\nResidual Deviance:", format(signif(x$deviance, 
                                                                                           digits)), "\tAIC:", format(signif(x$aic, digits)))
  cat("\n")
  invisible(x)
}

