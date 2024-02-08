#!/bin/bash

# Clone the repository
git clone git@github.com:lovetatting/vasaikar_seurat.git

# Change directory to Vasaikar_seurat/stage
cd vasaikar_seurat/stage

# Check if the first argument is 'debug'
if [ "$1" == "compute" ]; then
    echo "Running in compute mode: Purling and executing R file"
    # Purl the Rmd file into an R script
    export NO_PLOTS=TRUE
    Rscript -e "knitr::purl('GEOdataVasaikar.Rmd', output = 'GEOdataVasaikar.R')"
    # Run the purled R script
    Rscript /home/ruser/GEOdataVasaikar.R
else
    # Render the R Markdown file
    Rscript -e "rmarkdown::render(input = 'GEOdataVasaikar.Rmd')"
fi

