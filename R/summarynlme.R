#' Shorter lme model summary output
#'
#' Replaces the default nlme version by removing the method header, data name,
#' AIC/BIC/logLik table, fixed-effects formula, standardised residuals, and
#' observation/group counts.
#'
#' @param x an object of class \code{"summary.lme"}.
#' @param digits the number of significant digits to use when printing.
#' @param verbose logical. If TRUE, print convergence iteration count.
#' @param concise logical. If TRUE (default), suppress the method header, data
#'   name, AIC/BIC/logLik table, fixed-effects formula label, standardised
#'   within-group residuals, and observation/group counts.
#' @param ... further arguments passed to or from other methods.
#' @return Nothing — prints output only.
#' @export print.summary.lme
print.summary.lme <- function(x, digits = .Options$digits, verbose = FALSE,
                               concise = TRUE, ...)
{
  dd <- x$dims
  verbose <- verbose || attr(x, "verbose")

  if (!concise) {
    if (inherits(x, "nlme")) {
      cat("Nonlinear mixed-effects model fit by ")
      cat(if (x$method == "REML") "REML\n" else "maximum likelihood\n")
      cat("  Model:", deparse(x$call$model), "\n")
    } else {
      cat("Linear mixed-effects model fit by ")
      cat(if (x$method == "REML") "REML\n" else "maximum likelihood\n")
    }
    cat("  Data:", deparse(x$call$data), "\n")
    if (!is.null(x$call$subset))
      cat("  Subset:", deparse(nlme::asOneSidedFormula(x$call$subset)[[2L]]), "\n")
    print(data.frame(AIC = x$AIC, BIC = x$BIC, logLik = c(x$logLik),
                     row.names = " "), ...)
    if (verbose)
      cat("Convergence at iteration:", x$numIter, "\n")
    cat("\n")
  }

  # Random effects — always shown (this is the key unique content)
  print(summary(x$modelStruct), sigma = x$sigma,
        reEstimates = x$coefficients$random, verbose = verbose, ...)

  # Fixed effects
  fixF <- x$call$fixed
  if (!concise)
    cat("Fixed effects: ",
        deparse(if (inherits(fixF, "formula") || is.call(fixF))
          fixF else lapply(fixF, function(el) as.name(deparse(el)))),
        "\n")
  else
    cat("\nFixed effects:\n")

  xtTab <- as.data.frame(x$tTable)
  wchPval <- match("p-value", names(xtTab))
  for (i in names(xtTab)[-wchPval])
    xtTab[, i] <- format(zapsmall(xtTab[, i]))
  xtTab[, wchPval] <- format(round(xtTab[, wchPval], 4))
  if (any(wchLv <- (as.double(levels(xtTab[, wchPval])) == 0)))
    levels(xtTab[, wchPval])[wchLv] <- "<.0001"
  row.names(xtTab) <- dimnames(x$tTable)[[1L]]
  print(xtTab, ...)

  if (!concise) {
    if (nrow(x$tTable) > 1) {
      corr <- x$corFixed
      class(corr) <- "correlation"
      print(corr, title = " Correlation:", ...)
    }
    cat("\nStandardized Within-Group Residuals:\n")
    print(x$residuals, ...)
    cat("\nNumber of Observations:", x$dims[["N"]])
    cat("\nNumber of Groups: ")
    Ngrps <- dd$ngrps[1:dd$Q]
    if ((lNgrps <- length(Ngrps)) == 1L) {
      cat(Ngrps, "\n")
    } else {
      sNgrps <- 1:lNgrps
      aux <- rep(names(Ngrps), sNgrps)
      aux <- split(aux, array(rep(sNgrps, lNgrps),
                              c(lNgrps, lNgrps))[!lower.tri(diag(lNgrps))])
      names(Ngrps) <- unlist(lapply(aux, paste, collapse = " %in% "))
      cat("\n")
      print(rev(Ngrps), ...)
    }
  }
  invisible(x)
}

#' Shorter lme model print output
#'
#' Replaces the default nlme version by removing the method header, data name,
#' log-likelihood, fixed-effects formula label, random-effects structure, and
#' observation/group counts.
#'
#' @param x an object of class \code{"lme"}.
#' @param concise logical. If TRUE (default), suppress header, data, log-lik,
#'   formula label, and observation/group counts.
#' @param ... further arguments passed to or from other methods.
#' @return Nothing — prints output only.
#' @export print.lme
print.lme <- function(x, concise = TRUE, ...)
{
  dd <- x$dims
  if (!concise) {
    if (inherits(x, "nlme")) {
      cat("Nonlinear mixed-effects model fit by ")
      cat(if (x$method == "REML") "REML\n" else "maximum likelihood\n")
      cat("  Model:", deparse(x$call$model), "\n")
    } else {
      cat("Linear mixed-effects model fit by ")
      cat(if (x$method == "REML") "REML\n" else "maximum likelihood\n")
    }
    cat("  Data:", deparse(x$call$data), "\n")
    if (!is.null(x$call$subset))
      cat("  Subset:", deparse(nlme::asOneSidedFormula(x$call$subset)[[2L]]), "\n")
    cat("  Log-", if (x$method == "REML") "restricted-" else "",
        "likelihood: ", format(x$logLik), "\n", sep = "")
    fixF <- x$call$fixed
    cat("  Fixed:", deparse(if (inherits(fixF, "formula") || is.call(fixF) ||
                               is.name(fixF)) fixF
                            else lapply(fixF, function(el) as.name(deparse(el)))), "\n")
  }
  print(nlme::fixef(x), ...)
  cat("\n")
  print(summary(x$modelStruct), sigma = x$sigma, ...)
  if (!concise) {
    cat("Number of Observations:", dd[["N"]])
    cat("\nNumber of Groups: ")
    Ngrps <- dd$ngrps[1:dd$Q]
    if ((lNgrps <- length(Ngrps)) == 1L) {
      cat(Ngrps, "\n")
    } else {
      sNgrps <- 1:lNgrps
      aux <- rep(names(Ngrps), sNgrps)
      aux <- split(aux, array(rep(sNgrps, lNgrps),
                              c(lNgrps, lNgrps))[!lower.tri(diag(lNgrps))])
      names(Ngrps) <- unlist(lapply(aux, paste, collapse = " %in% "))
      cat("\n")
      print(rev(Ngrps), ...)
    }
  }
  invisible(x)
}

#' Shorter gls model summary output
#'
#' Replaces the default nlme version by removing the method header, model
#' formula, data name, AIC/BIC/logLik table, and standardised residuals.
#'
#' @param x an object of class \code{"summary.gls"}.
#' @param verbose logical. If TRUE, print convergence iteration count.
#' @param digits the number of significant digits to use when printing.
#' @param concise logical. If TRUE (default), suppress the method header,
#'   model/data lines, AIC/BIC/logLik table, and standardised residuals.
#' @param ... further arguments passed to or from other methods.
#' @return Nothing — prints output only.
#' @export print.summary.gls
print.summary.gls <- function(x, verbose = FALSE,
                               digits = .Options$digits,
                               concise = TRUE, ...)
{
  dd <- x$dims
  fixSig <- attr(x[["modelStruct"]], "fixedSigma")
  fixSig <- !is.null(fixSig) && fixSig
  verbose <- verbose || attr(x, "verbose")
  mCall <- x$call

  if (!concise) {
    if (inherits(x, "gnls")) {
      cat("Generalized nonlinear least squares fit\n")
    } else {
      cat("Generalized least squares fit by ")
      cat(if (x$method == "REML") "REML\n" else "maximum likelihood\n")
    }
    cat("  Model:", deparse(mCall$model), "\n")
    cat("  Data:", deparse(mCall$data), "\n")
    if (!is.null(mCall$subset))
      cat("  Subset:", deparse(nlme::asOneSidedFormula(mCall$subset)[[2L]]), "\n")
    print(data.frame(AIC = x$AIC, BIC = x$BIC, logLik = as.vector(x$logLik),
                     row.names = " "), ...)
    if (verbose)
      cat("Convergence at iteration:", x$numIter, "\n")
  }

  # Correlation/variance structure — always shown (the unique content of gls)
  if (length(x$modelStruct)) {
    cat("\n")
    print(summary(x$modelStruct), ...)
  }

  # Coefficients
  xtTab <- as.data.frame(x$tTable)
  wchPval <- match("p-value", names(xtTab))
  for (i in names(xtTab)[-wchPval])
    xtTab[, i] <- format(zapsmall(xtTab[, i]))
  xtTab[, wchPval] <- format(round(xtTab[, wchPval], 4L))
  if (any(wchLv <- (as.double(levels(xtTab[, wchPval])) == 0)))
    levels(xtTab[, wchPval])[wchLv] <- "<.0001"
  row.names(xtTab) <- dimnames(x$tTable)[[1L]]
  print(xtTab, ...)

  if (!concise) {
    if (nrow(x$tTable) > 1L) {
      corr <- x$corBeta
      class(corr) <- "correlation"
      print(corr, title = "\n Correlation:", ...)
    }
    cat("\nStandardized residuals:\n")
    print(x$residuals, ...)
    cat("\n")
  }
  cat("\nResidual standard error:", format(x$sigma), "\n")
  cat("Degrees of freedom:", dd[["N"]], "total;",
      dd[["N"]] - dd[["p"]], "residual\n")
  invisible(x)
}

#' Shorter gls model print output
#'
#' Replaces the default nlme version by removing the method header, model
#' formula, data name, and log-likelihood.
#'
#' @param x an object of class \code{"gls"}.
#' @param concise logical. If TRUE (default), suppress the method header,
#'   model/data lines, and log-likelihood.
#' @param ... further arguments passed to or from other methods.
#' @return Nothing — prints output only.
#' @export print.gls
print.gls <- function(x, concise = TRUE, ...)
{
  fixSig <- attr(x[["modelStruct"]], "fixedSigma")
  fixSig <- !is.null(fixSig) && fixSig
  dd <- x$dims
  mCall <- x$call

  if (!concise) {
    if (inherits(x, "gnls")) {
      cat("Generalized nonlinear least squares fit\n")
    } else {
      cat("Generalized least squares fit by ")
      cat(if (x$method == "REML") "REML\n" else "maximum likelihood\n")
    }
    cat("  Model:", deparse(mCall$model), "\n")
    cat("  Data:", deparse(mCall$data), "\n")
    if (!is.null(mCall$subset))
      cat("  Subset:", deparse(nlme::asOneSidedFormula(mCall$subset)[[2L]]), "\n")
    if (inherits(x, "gnls")) {
      cat("  Log-likelihood: ", format(x$logLik), "\n", sep = "")
    } else {
      cat("  Log-", if (x$method == "REML") "restricted-" else "",
          "likelihood: ", format(x$logLik), "\n", sep = "")
    }
  }

  cat("Coefficients:\n")
  print(coef(x), ...)
  cat("\n")
  if (length(x$modelStruct) > 0L)
    print(summary(x$modelStruct), ...)
  cat("Degrees of freedom:", dd[["N"]], "total;",
      dd[["N"]] - dd[["p"]], "residual\n")
  cat("Residual standard error:", format(x$sigma), "\n")
  invisible(x)
}
