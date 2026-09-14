# Internal store for original functions, keyed by package name.
# Stored in the shortsummary namespace so it persists for the session
# and is accessible to .onUnload without a global variable.
.originals <- new.env(parent = emptyenv())

# Save originals from a namespace and install replacements from this package.
.patch <- function(func_names, ns_name) {
  target <- asNamespace(ns_name)
  self   <- asNamespace("shortsummary")
  bucket <- new.env(parent = emptyenv())
  
  for (nm in func_names) {
    assign(nm, get(nm, envir = target), envir = bucket)  # save original
    unlockBinding(nm, target)
    assign(nm, get(nm, envir = self), envir = target)    # install replacement
    lockBinding(nm, target)
  }
  
  assign(ns_name, bucket, envir = .originals)
}

# Restore all saved originals for one namespace.
.unpatch <- function(ns_name) {
  if (!exists(ns_name, envir = .originals, inherits = FALSE)) return()
  target <- asNamespace(ns_name)
  bucket <- get(ns_name, envir = .originals)
  
  for (nm in ls(bucket)) {
    unlockBinding(nm, target)
    assign(nm, get(nm, envir = bucket), envir = target)
    lockBinding(nm, target)
  }
  
  rm(list = ns_name, envir = .originals)
}

.onLoad <- function(libname, pkgname) {
  .patch(c("print.summary.lm", "print.summary.glm",
           "print.lm", "print.glm"),
         "stats")
  
  if (requireNamespace("lme4", quietly = TRUE))
    .patch("print.summary.merMod", "lme4")
  
  if (requireNamespace("nlme", quietly = TRUE))
    .patch(c("print.summary.lme", "print.summary.gls",
             "print.lme", "print.gls"),
           "nlme")
  
  if (requireNamespace("mgcv", quietly = TRUE))
    .patch("print.summary.gam", "mgcv")
  
  if (requireNamespace("survival", quietly = TRUE))
    .patch("print.summary.coxph", "survival")
  
  if (requireNamespace("pscl", quietly = TRUE))
    .patch(c("print.summary.hurdle", "print.summary.zeroinfl",
             "print.hurdle", "print.zeroinfl"),
           "pscl")
  
  if (requireNamespace("MASS", quietly = TRUE))
    .patch(c("print.summary.polr", "print.polr", "print.lda"), "MASS")
}

.onUnload <- function(libpath) {
  for (ns_name in c("MASS", "pscl", "survival", "mgcv", "nlme", "lme4", "stats")) {
    .unpatch(ns_name)
  }
}
