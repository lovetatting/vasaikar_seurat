#!/bin/bash

curl -O https://raw.githubusercontent.com/lovetatting/vasaikar_seurat/main/stage/GEOdataVasaikar.Rmd
curl -O https://raw.githubusercontent.com/lovetatting/vasaikar_seurat/main/stage/helpers.R
curl -O https://raw.githubusercontent.com/lovetatting/vasaikar_seurat/main/stage/precondition_v5_rds.R
curl -O https://raw.githubusercontent.com/lovetatting/vasaikar_seurat/main/stage/precondition_filesystem.R
curl -O https://raw.githubusercontent.com/lovetatting/vasaikar_seurat/main/stage/env.R
curl -O https://raw.githubusercontent.com/lovetatting/vasaikar_seurat/main/stage/precondition_raw_data.R

# Check if the first argument is 'compute'
if [ "$1" == "compute" ]; then
    echo "Running in compute mode: Purling and executing R file"
    # Purl the Rmd file into an R script
    export NO_PLOTS=TRUE
    Rscript -e "knitr::purl('GEOdataVasaikar.Rmd', output = 'GEOdataVasaikar.R')"
    # Run the purled R script
    Rscript /home/ruser/GEOdataVasaikar.R
else
    # Render the R Markdown file
    echo "Rendering document"
    Rscript -e "rmarkdown::render(input = 'GEOdataVasaikar.Rmd', output_dir = file.path('data', 'report'))"
fi

