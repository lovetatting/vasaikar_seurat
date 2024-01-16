#!/bin/bash

# Download the R Markdown file
Rscript -e "download.file('https://raw.githubusercontent.com/lovetatting/vasaikar_seurat/main/stage/GEOdataVasaikar.Rmd', destfile = '/home/ruser/GEOdataVasaikar.Rmd')"

# Check if the first argument is 'debug'
if [ "$1" == "compute" ]; then
    echo "Running in compute mode: Purling and executing R file"
    # Purl the Rmd file into an R script
    export NO_PLOTS=TRUE
    Rscript -e "knitr::purl('/home/ruser/GEOdataVasaikar.Rmd', output = '/home/ruser/GEOdataVasaikar.R')"
    # Run the purled R script
    Rscript /home/ruser/GEOdataVasaikar.R
else
    # Render the R Markdown file
    Rscript -e "rmarkdown::render(input = '/home/ruser/GEOdataVasaikar.Rmd')"
fi

