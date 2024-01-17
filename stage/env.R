
# determin DEBUG status
if (Sys.getenv("DEBUG") != "") {
  DEBUG <- TRUE
} else {
  DEBUG <- FALSE
}

# Determine whether to run plot chunks
if (Sys.getenv("NO_PLOTS") != "") {
  NO_PLOTS <- TRUE
} else {
  NO_PLOTS <- FALSE
}

# Determine whether to downsample
if (Sys.getenv("DOWNSAMPLE") != "") {
  tryCatch({
    DOWNSAMPLE <- as.numeric(Sys.getenv("DOWNSAMPLE"))
    stopifnot("Donwsample need to be a positive integer" = DOWNSAMPLE > 0)
  }, error = function(e) {
    log.error("DOWNSAMPLE must be a number. Quitting.")
    stop(e)
  })
} else {
  DOWNSAMPLE <- FALSE
}

