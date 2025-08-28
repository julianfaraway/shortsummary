.onLoad <- function(libname, pkgname) {
  envir = asNamespace("stats")

  unlockBinding("print.summary.lm", envir)
  unlockBinding("print.summary.glm",envir)
  
  assign("print.summary.lm", print.summary.lm, envir=envir)
  assign("print.summary.glm",print.summary.glm,envir=envir)
  
  lockBinding("print.summary.lm", envir)
  lockBinding("print.summary.glm",envir)
}
