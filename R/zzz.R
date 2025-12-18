.onLoad <- function(libname, pkgname) {
  envir = asNamespace("stats")
  lisfunc = list("print.summary.lm",
                 "print.summary.glm",
                 "print.lm",
                 "print.glm")
  lapply(lisfunc, \(x) unlockBinding(x,envir))
  lapply(lisfunc, \(x) assign(x,get(x),envir=envir))
  lapply(lisfunc, \(x) lockBinding(x,envir))

  if (requireNamespace("lme4", quietly = TRUE)) {
    envir = asNamespace("lme4")
    unlockBinding("print.summary.merMod", envir)
    assign("print.summary.merMod", print.summary.merMod, envir=envir)
    lockBinding("print.summary.merMod", envir)
  }
  
  if (requireNamespace("survival", quietly = TRUE)) {
    envir = asNamespace("survival")
    unlockBinding("print.summary.coxph", envir)
    assign("print.summary.coxph", print.summary.coxph, envir=envir)
    lockBinding("print.summary.coxph", envir)
  }
  
  if (requireNamespace("pscl", quietly = TRUE)) {
    envir = asNamespace("pscl")
    lisfunc = list("print.summary.hurdle",
                "print.summary.zeroinfl",
                "print.hurdle",
                "print.zeroinfl")
    lapply(lisfunc, \(x) unlockBinding(x,envir))
    lapply(lisfunc, \(x) assign(x,get(x),envir=envir))
    lapply(lisfunc, \(x) lockBinding(x,envir))
  }
}
