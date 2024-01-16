
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

