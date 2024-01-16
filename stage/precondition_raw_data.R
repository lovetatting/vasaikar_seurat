

geo.accession = "GSE190992"

log_info('The GEO is: {geo.accession}')

log_info('Ensuring annotation data in {geo.dir}')

geo_annotation_files <- c("GSE190992_series_matrix.txt.gz", "GPL24676.soft.gz")

geo_suppl_files <- c(
    "GSE190992_AIFI-CBC.csv.gz",
    "GSE190992_AIFI-CellProportion-Flow.csv.gz",
    "GSE190992_AIFI-PlasmaProteome-olink.csv.gz",
    "GSE190992_AIFI-data-annotation.csv.gz",
    "GSE190992_AIFI-scATAC-PBMC-FinalData.Rda.gz",
    "GSE190992_AIFI-scRNA-PBMC-FinalData.RDS.gz",
#    "GSE190992_RAW.tar",
    "GSE190992_X001_Seurat4_labeling_metadata.rda.gz",
    "GSE190992_X002_Seurat4_labeling_metadata.rda.gz"
)


annotation_files_exist <- function(files, directory) {
  all(sapply(files, function(file) file.exists(file.path(directory, file))))
}

if (!annotation_files_exist(geo_annotation_files, geo.dir)) {
  log_info("Downloading GEO annotation files")
  GEOquery::getGEO(geo.accession,
                   destdir = geo.dir,
                   GSEMatrix = TRUE, 
                   getGPL = TRUE)
} 

get_geo_supp_files <- function(file_names, geo.dir, geo.accession) {
  for (file_name in file_names) {
    file_path <- file.path(geo.dir, file_name)
    
    if (file.exists(file_path)) {
      log_info("File {file_name} already exists in {geo.dir}")
    } else {
      start_time <- Sys.time()
      GEOquery::getGEOSuppFiles(GEO = geo.accession, 
                                baseDir = geo.dir, 
                                filter_regex = file_name, 
                                fetch_files = TRUE, 
                                makeDirectory = F)
      end_time <- Sys.time()
      download_duration <- end_time - start_time
      log_info("Downloaded {file_name} to {geo.dir} in {download_duration} seconds")
    }
  }
}

log_info('The timeout option is set to 
         {options("timeout")$timeout} - downloads that 
         take longer time will error. 
         Consider changing it if too short')
get_geo_supp_files(geo_suppl_files, geo.dir, geo.accession)

log_info("These files are in {geo.dir}")
list.files(path = geo.dir) %>% 
  log_info('{geo.dir}: {.}', ... = .)

log_info("Raw data files are present")

