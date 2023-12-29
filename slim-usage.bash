#!/bin/bash

Rscript -e "library(rmarkdown); library(GEOquery); library(BPCells); library(Seurat); library(SeuratObject); library(SeuratDisk); library(SeuratWrappers); library(ggplot2); library(dplyr); library(stringr); library(magrittr); library(scales); library(tidyr)"

# Loop through each path and touch the directory itself
for path in $paths; do
    echo "Touching directory: $path"
    touch "$path"
done

