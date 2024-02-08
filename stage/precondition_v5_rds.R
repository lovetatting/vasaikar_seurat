  #add metadata to v5 object
add_metadata_and_qc_stats <- function(data.v5.raw) {
  log_info('Adding metadata to v5 object')
  data.v5.raw@meta.data <- data.v5.raw@meta.data %>%
    mutate(
      Tissue = str_extract(orig.ident, "^PB"),
      orig.ID = as.numeric(str_extract(orig.ident, "(?<=PB)\\d+(?=W)")),
      ID = as.numeric(factor(orig.ID)),
      Week = as.numeric(str_extract(orig.ident, "(?<=W)\\d+$")),
      cell.ID = row.names(data.v5.raw@meta.data) #unique row ID
    ) 

  #add qc stats

  # calculate for mitochondrial genes
  data.v5.raw[["qc.mt.percent"]] <- PercentageFeatureSet(data.v5.raw, pattern = "^MT-")
  # ribosomal genes
  data.v5.raw[["qc.ribo.percent"]] <- PercentageFeatureSet(data.v5.raw, "^RP[SL]")
  # hemoglobin genes
  data.v5.raw[["qc.hb.percent"]] <- PercentageFeatureSet(data.v5.raw, "^HB[^(P)]")
  # platelet genes
  data.v5.raw[["qc.platelet.percent"]] <- PercentageFeatureSet(data.v5.raw, "PECAM1|PF4")
  invisible(data.v5.raw)
}

if(! file.exists(data.v5.raw.rds.file)) {
  if(! file.exists(data.v4.raw.rds.file)) {
    log_info("Unzipping RDS file for seurat v4 object at {data.v4.raw.rds.file}")
    
    time_it(
      gunzip(data.v4.raw.rds.file.gz, remove = F)
    )
  }

  log_info('Reading seurat v4 and converting to Seurat with disk storage')
  log_info('Reading RDS at {data.v4.raw.rds.file}')

  data.v4.raw <- 
    time_it(
      readRDS(
        file.path(data.v4.raw.rds.file)
      )
    )
  log_info('Updating Seurat object to v5')
  
  data.v5.raw <- 
    time_it(
      UpdateSeuratObject(object = data.v4.raw)
    )
  
  log_info('Removing v4 seurat object from ram and gc()')
  rm(data.v4.raw)
  gc()
  log_info_ram()
  
  data.v5.raw <- DietSeurat(data.v5.raw, 
                            layers = "counts",
                            assays = "RNA")
  
  log_info('Upgrading to Assay5')
  
  time_it(
  data.v5.raw[["RNA"]] <- 
    time_it(
      as(data.v5.raw[["RNA"]], "Assay5")
    )
  )


  downsample.sketch <- function(object) {

    data.v5.raw <- SketchData(object = data.v5.raw, 
                                assay = "RNA", 
                                ncells = DOWNSAMPLE,
                                sketched.assay = "RNA.sketch", 
                                verbose = T, 
                                seed = 333
    )
    data.v5.raw <- DietSeurat(object = data.v5.raw, 
                              assay = "RNA.sketch", 
                              verbose = T
    )
    data.v5.raw <- RenameAssays(object = data.v5.raw, 
                               assay.name = "RNA.sketch", 
                               new.assay.name = "RNA"
    )
  }
  
  downsample.uniform <- function(object) {
    subset(object, downsample = DOWNSAMPLE, 
           features = VariableFeatures(data.v5.raw, nfeatures = 125, simplify = T))
  }
  
  if(DOWNSAMPLE) {
    log_info('Downsampling to {DOWNSAMPLE} cells')
    data.v5.raw <- downsample.sketch(data.v5.raw)
  }

  log_info('Writing data-v5-raw to matrices on disk')
  
  time_it(
  write_matrix_dir(mat = data.v5.raw[["RNA"]]$counts, 
                  dir = file.path(matrices.dir, 'data-v5-raw'), 
                  overwrite = T
                  )
  )
  
  rm(data.v5.raw)
  gc()
  log_info_ram()
  
  #read again for automatic disk storage functionality
  counts.mat <- 
    open_matrix_dir(
      dir = file.path(matrices.dir, 'data-v5-raw')
      )

  log_info('Creating the new seurat v5 object from count matrices')
  
  assay.v5.counts.raw <- CreateAssay5Object(counts = counts.mat)
  
  data.v5.raw <- 
    time_it(
      CreateSeuratObject(
        counts = assay.v5.counts.raw, 
        assay = "RNA",
        project = "vasaikar")
      )

  data.v5.raw <- add_metadata_and_qc_stats(data.v5.raw)
  
  time_it(
    save.data(data.v5.raw,
                  file = data.v5.raw.rds.file
    )
  )
  

  } else {
    log_info("RDS file for seurat v5 object already exists at {data.v5.raw.rds.file}")

}
