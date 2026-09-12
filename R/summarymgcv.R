#' Shorter gam model summary output
#'
#' Replaces the default mgcv version by removing the family/link header,
#' formula, and the GCV/REML score. The smooth terms table is preserved
#' unchanged as it is unique to GAMs and not available elsewhere.
#'
#' The standard output looks like:
#' \preformatted{
#' Family: gaussian
#' Link function: identity
#'
#' Formula:
#' mpg ~ s(hp) + s(wt)
#'
#' Parametric coefficients: ...
#'
#' Approximate significance of smooth terms: ...
#'
#' R-sq.(adj) = 0.878   Deviance explained = 89.6%
#' GCV = 5.3542  Scale est. = 4.4349  n = 32
#' }
#'
#' The shorter version omits the family/link header and the formula, and
#' consolidates the bottom line to remove the GCV/REML score (which is
#' only meaningful for comparing models, not interpreting a single fit).
#'
#' @param x an object of class \code{"summary.gam"}.
#' @param digits the number of significant digits to use when printing.
#' @param signif.stars logical. If TRUE, significance stars are printed.
#' @param concise logical. If TRUE (default), suppress the family/link header,
#'   formula, and smoothing criterion score (GCV/REML value).
#' @param ... further arguments passed to or from other methods.
#' @return Nothing — prints output only.
#' @export print.summary.gam
print.summary.gam <- function(x,
                               digits = max(3L, getOption("digits") - 3L),
                               signif.stars = getOption("show.signif.stars"),
                               concise = TRUE, ...)
{
  if (!concise) {
    print(x$family)
    cat("Formula:\n")
    if (is.list(x$formula))
      for (i in seq_along(x$formula)) print(x$formula[[i]])
    else
      print(x$formula)
  }

  if (length(x$p.coeff) > 0L) {
    cat("\nParametric coefficients:\n")
    printCoefmat(x$p.table, digits = digits, signif.stars = signif.stars,
                 signif.legend = signif.stars && !concise,
                 na.print = "NA", ...)
  }

  cat("\n")
  if (x$m > 0L) {
    cat("Approximate significance of smooth terms:\n")
    printCoefmat(x$s.table, digits = digits, signif.stars = signif.stars,
                 signif.legend = signif.stars && !concise,
                 has.Pvalue = TRUE, na.print = "NA", cs.ind = 1L, ...)
  }

  cat("\n")
  if (!is.null(x$rank) && x$rank < x$np)
    cat("Rank: ", x$rank, "/", x$np, "\n", sep = "")

  # Summary line: always show R-sq and deviance explained; show
  # smoothing criterion only in non-concise mode.
  if (!is.null(x$r.sq))
    cat("R-sq.(adj) =", formatC(x$r.sq, digits = 3, width = 5), " ")
  if (length(x$dev.expl) > 0L)
    cat("Deviance explained =",
        formatC(x$dev.expl * 100, digits = 3, width = 4), "%")
  cat("\n")

  if (!concise) {
    if (!is.null(x$method) &&
        !(x$method %in% c("PQL", "lme.ML", "lme.REML")))
      cat(x$method, " = ", formatC(x$sp.criterion, digits = 5), sep = "")
  }
  cat("Scale est. =", formatC(x$scale, digits = 5, width = 8, flag = "-"),
      " n =", x$n, "\n")

  invisible(x)
}
