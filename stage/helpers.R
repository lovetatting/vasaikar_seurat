get_memory_usage_gb <- function() {
  bytes <- mem_used()
  gb <- round(bytes / 1024 / 1024 / 1024)
  return(gb)
}

log_info_ram <- function() {
  log_info('Current ram usage is: {get_memory_usage_gb()}Gb')
}

time_it <- function(expr) {
  func_call_str <- deparse(substitute(expr))  # Capture the entire function call as a string

  log_info('Calling {func_call_str}')
  
  start_time <- Sys.time()
  result <- eval(substitute(expr))

  end_time <- Sys.time()
  duration <- end_time - start_time  # Duration rounded to whole seconds
  
  log_info('Executed {func_call_str} in {round(duration)} seconds.')
  
  log_info_ram()

  return(result)
}

any_inodes <- function(path) {
  length(list.files(path, include.dirs = T)) 
}

create_directory <- function(dir_path, dir_description = "") {
  if (!dir.exists(dir_path)) {
    dir.create(dir_path, recursive = T)
    log_info(paste('Created directory:', dir_path, dir_description))
  } else {
    log_info(paste('Directory already exists:', dir_path))
  }
  dir_path
}

#debug: write permissions on data directory in container
permissions_for_dir <- function(dir) {
  file.info(dir) %>% 
    pull(mode) %>% 
    log_debug('\nPermissions for {dir}: {.}\n')
}

save.data <- function(obj, file) {
  qsave(obj, file, nthreads = 8)
}

load.data <- function(file) {
  qread(file, nthreads = 8)
}
