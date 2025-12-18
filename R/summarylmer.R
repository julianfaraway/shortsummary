#' Shorter lmer model summary output
#' 
#' @param x an object of class "summary.merMod", usually, a result of a call to summary.merMod.
#' @param digits the number of significant digits to use when printing.
#' @param correlation logical. Indicates whether the correlation matrix of the fixed-effects parameters should be printed.
#' @param symbolic.cor logical. Should a symbolic encoding of the fixed-effects correlation matrix be printed?
#' @param signif.stars logical. If TRUE, ‘significance stars’ are printed for each coefficient.
#' @param ranef.comp	character vector of length one or two. Indicates if random-effects parameters should be reported on the variance and/or standard deviation scale.
#' @param ranef.corr logical. Print correlations (rather than covariances) of random effects?
#' @param show.resids logical. Should the quantiles of the scaled residuals be printed?
#' @param concise logical. If TRUE, don't print the call and residuals stats.
#' @param ... further arguments passed to or from other methods.
#' @return Nothing - prints output only.
#' @export print.summary.merMod
print.summary.merMod <- function(x, digits = max(3, getOption("digits") - 3),
                                 correlation = FALSE, symbolic.cor = FALSE,
                                 signif.stars = getOption("show.signif.stars"),
                                 ranef.comp = c("Variance", "Std.Dev."),
                                 ranef.corr = any(ranef.comp == "Std.Dev."),
                                 show.resids = TRUE,
                                 concise = TRUE,
                                 ...)
{
  if(!concise){
  lme4::.prt.methTit(x$methTitle, x$objClass)
  lme4::.prt.family(x)
  lme4::.prt.call(x$call); cat("\n")
  lme4::.prt.aictab(x$AICtab); cat("\n")
  if (show.resids)
    ## need residuals.merMod() rather than residuals():
    ##  summary.merMod has no residuals method
    lme4::.prt.resids(x$residuals, digits = digits)
  }
  lme4::.prt.VC(x$varcor, digits = digits, useScale = x$useScale,
          comp = ranef.comp,
          corr = ranef.corr, ...)
  if(!concise){
    lme4::.prt.grps(x$ngrps, nobs = x$devcomp$dims[["n"]])
  }
  
  p <- nrow(x$coefficients)
  if (p > 0) {
    cat("\nFixed effects:\n")
    printCoefmat(x$coefficients, # too radical: zap.ind = 3, #, tst.ind = 4
                 digits = digits, signif.stars = signif.stars)
    ## do not show correlation when   summary(*, correlation=FALSE)  was used:
    hasCor <- !is.null(VC <- x$vcov) && !is.null(VC@factors$correlation)
    ## FIXME: don't understand the logic here. We can easily
    ## defend against the problem of missing pre-computed correlation
    ## function by reconstituting it if necessary
    ## (e.g. if using merDeriv::vcov.lmerMod), as in commented code below.
    ## However, we currently have a test (using fit_agridat_archbold,
    ## see test-methods.R) that fails if we 'fix' this problem ...
    ##
    ## if (hasCor && is.null(VC@factors$correlation)) {
    ##     ## defend against merDeriv definition of vcov.lmerMod; reconstruct
    ##     cc <- cov2cor(VC)
    ##     dimnames(cc) <- dimnames(VC) ## Matrix 1.5.2 bug
    ##     VC@factors <- c(VC@factors, list(correlation = cc))
    ## }
    if(is.null(correlation)) { # default
      cor.max <- getOption("lme4.summary.cor.max")
      correlation <- hasCor && (isTRUE(x$corrSet) || p <= cor.max)
      if(!correlation && p > cor.max && is.na(x$corrSet)) {
        nam <- deparse(substitute(x))
        if(length(nam) > 1 || nchar(nam) >= 32) nam <- "...."
        message(sprintf(paste(
          "\nCorrelation matrix not shown by default, as p = %d > %d.",
          "Use print(%s, correlation=TRUE)  or",
          "    vcov(%s)        if you need it\n", sep = "\n"),
          p, cor.max, nam, nam))
      }
    }
    else if(!is.logical(correlation)) stop("'correlation' must be NULL or logical")
    if(correlation) {
      if(is.null(VC)) VC <- vcov(x, correlation = TRUE)
      corF <- VC@factors$correlation
      if (is.null(corF)) { # can this still happen?
        message("\nCorrelation of fixed effects could have been required in summary()")
        corF <- cov2cor(VC)
      }
      p <- ncol(corF)
      if (p > 1) {
        rn <- rownames(x$coefficients)
        rns <- abbreviate(rn, minlength = 11)
        cat("\nCorrelation of Fixed Effects:\n")
        if (is.logical(symbolic.cor) && symbolic.cor) {
          corf <- as(corF, "matrix")
          dimnames(corf) <- list(rns,
                                 abbreviate(rn, minlength = 1, strict = TRUE))
          print(symnum(corf))
        } else {
          corf <- matrix(format(round(corF@x, 3), nsmall = 3),
                         ncol = p,
                         dimnames = list(rns, abbreviate(rn, minlength = 6)))
          corf[!lower.tri(corf)] <- ""
          print(corf[-1, -p, drop = FALSE], quote = FALSE)
        } ## !symbolic.cor
      }  ## if (p > 1)
    } ## if (correlation)
  } ## if (p>0)
  
  if(length(x$fitMsgs) && any(nchar(x$fitMsgs) > 0)) {
    cat("fit warnings:\n"); writeLines(x$fitMsgs)
  }
  lme4::.prt.warn(x$optinfo,summary=FALSE)
  invisible(x)
}## print.summary.merMod
