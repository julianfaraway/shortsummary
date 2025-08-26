.onLoad <- function(libname, pkgname) {
  envir = environment(stats::summary.lm)

  unlockBinding("print.summary.lm",envir)
  assign("print.summary.lm",print.summary.lm,envir)

  unlockBinding("print.summary.glm",envir)
  assign("print.summary.glm",print.summary.glm,envir)
}
