# vasaikar_seurat

## Paths
A volume mount to data in the container (will be at /home/ruser/data) is expected by the script for
output. 

## Slim 

```
# slim down the image from the Dockerfile

slim build --http-probe=false --mount $(pwd)/stage/data:/home/ruser/data --exec-file slim-usage.bash --include-path "/usr/local/lib/R/site-library" --include-path "/usr/local/lib/R/library" --target ghcr.io/lovetatting/vasaikar_seurat:1.0 --tag slim
```

This minimizes the container image from 8Gb to 2.5 Gb. 

## File System

The script expects a file system with a data directory in $PWD named `data`. The script is run wth
ruser in rusergroup with UID 1000 and GID 1000. 

## Current workflow

Since many of the procedures require large amounts of RAM a container workflow with on demand
provision of a compute cluster is recommended (eg. AWS Gargate). 

The main Rmd file is the main file to run. Various helper scripts are used to eg. make sure the
environment is as expected by the computation. 

entrypoint.sh is the intended start point. The flag `compute` will purl the file and skip plot
chunks. This is good for producing the RDS files.




