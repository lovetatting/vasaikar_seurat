
log_info('File permissions for data directory is {permissions_for_dir("data")}')
if(file.access("data", 2) == 0) { # C function return value encoding
  log_info('Data directory is writable')
} else {
  log_error('Data directory is not writable')
  stop("Data directory is not writable")
}

data.dir <- create_directory("data")

geo.dir <- create_directory(file.path(data.dir, "GEO"), 'for GEO files')

matrices.dir <- 
  create_directory(file.path(data.dir, 'matrices'))

data.rds.dir <- create_directory(file.path(data.dir, 'RDS'))

#hdf5.v5.raw.dir <- create_directory(file.path(hdf5.dir, "v5", "raw"))
# hdf5.v5.clipped.dir <- create_directory(file.path(hdf5.dir, "v5", "clipped"), 'for clipped raw dataset')
# hdf5.v5.clipped.normalised.dir <- create_directory(file.path(hdf5.dir, "v5", "clipped", "normalised"), 'for clipped and normalised dataset')
# hdf5.v5.reduced.dir <- create_directory(file.path(hdf5.dir, "v5", "reduced"), 'for dataset with dimensionality reduction')
# hdf5.v5.integrated.dir <- create_directory(file.path(hdf5.dir, "v5", "integrated"), 'for integrated dataset')

data.v4.raw.rds.file.gz <- file.path(file.path(geo.dir,
                     "GSE190992_AIFI-scRNA-PBMC-FinalData.RDS.gz")
           )
data.v4.raw.rds.file <- file.path(file.path(geo.dir,
                     "GSE190992_AIFI-scRNA-PBMC-FinalData.RDS")
           )

data.v5.raw.rds.file <- file.path(data.rds.dir, "data-v5-raw.rds")

data.v5.clipped.rds.file <- file.path(data.rds.dir, "data-v5-clipped.rds")

data.v5.normalised.rds.file <- 
  file.path(data.rds.dir, "data-v5-clipped-normalised.RDS")

data.v5.reduced.rds.file <- file.path(data.rds.dir, "data-v5-reduced.rds")

