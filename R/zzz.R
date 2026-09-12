.onLoad <- function(libname, pkgname) {
  # Patch stats functions
  envir <- asNamespace("stats")
  lisfunc <- list("print.summary.lm",
                  "print.summary.glm",
                  "print.lm",
                  "print.glm")
  lapply(lisfunc, \(x) unlockBinding(x, envir))
  lapply(lisfunc, \(x) assign(x, get(x), envir = envir))
  lapply(lisfunc, \(x) lockBinding(x, envir))

  # Patch lme4 if available
  if (requireNamespace("lme4", quietly = TRUE)) {
    envir <- asNamespace("lme4")
    unlockBinding("print.summary.merMod", envir)
    assign("print.summary.merMod", print.summary.merMod, envir = envir)
    lockBinding("print.summary.merMod", envir)
  }

  # Patch nlme if available
  if (requireNamespace("nlme", quietly = TRUE)) {
    envir <- asNamespace("nlme")
    lisfunc <- list("print.summary.lme",
                    "print.summary.gls",
                    "print.lme",
                    "print.gls")
    lapply(lisfunc, \(x) unlockBinding(x, envir))
    lapply(lisfunc, \(x) assign(x, get(x), envir = envir))
    lapply(lisfunc, \(x) lockBinding(x, envir))
  }

  # Patch mgcv if available
  if (requireNamespace("mgcv", quietly = TRUE)) {
    envir <- asNamespace("mgcv")
    unlockBinding("print.summary.gam", envir)
    assign("print.summary.gam", print.summary.gam, envir = envir)
    lockBinding("print.summary.gam", envir)
  }

  # Patch survival if available
  if (requireNamespace("survival", quietly = TRUE)) {
    envir <- asNamespace("survival")
    unlockBinding("print.summary.coxph", envir)
    assign("print.summary.coxph", print.summary.coxph, envir = envir)
    lockBinding("print.summary.coxph", envir)
  }

  # Patch pscl if available
  if (requireNamespace("pscl", quietly = TRUE)) {
    envir <- asNamespace("pscl")
    lisfunc <- list("print.summary.hurdle",
                    "print.summary.zeroinfl",
                    "print.hurdle",
                    "print.zeroinfl")
    lapply(lisfunc, \(x) unlockBinding(x, envir))
    lapply(lisfunc, \(x) assign(x, get(x), envir = envir))
    lapply(lisfunc, \(x) lockBinding(x, envir))
  }

  # Patch MASS if available
  if (requireNamespace("MASS", quietly = TRUE)) {
    envir <- asNamespace("MASS")
    lisfunc <- list("print.summary.polr",
                    "print.polr",
                    "print.lda")
    lapply(lisfunc, \(x) unlockBinding(x, envir))
    lapply(lisfunc, \(x) assign(x, get(x), envir = envir))
    lapply(lisfunc, \(x) lockBinding(x, envir))
  }
}
