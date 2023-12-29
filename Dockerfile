# Use an official R base image
FROM rocker/r-ver:4.3.2

# Install system dependencies in smaller batches
RUN apt-get update && apt-get install -y \
    libharfbuzz-dev \
    libfribidi-dev \
    libcurl4-openssl-dev \
    libopenblas-base \
    libopenblas-dev

RUN apt-get install -y \
    libssl-dev \
    libhdf5-dev \
    libxml2-dev

RUN apt-get install -y \
    libmagick++-dev \
    libpoppler-cpp-dev \
    libcairo2-dev

RUN apt-get install -y \
    libxt-dev \
    libssh2-1-dev \
    libpq-dev

RUN apt-get install -y \
    libgdal-dev \
    libproj-dev \
    qpdf

RUN apt-get install -y \
    libjpeg-dev \
    libpng-dev \
    texlive-full

RUN apt-get install -y \
    python3 \
    python3-pip \
    pandoc \
    wget

RUN wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add -

RUN apt-get install -y \
    fftw3-dev

RUN apt-get install -y \
    cmake \
    libgit2-dev \
    sed \
    llvm \
    git \ 
    && rm -rf /var/lib/apt/lists/*

# Install UMAP
RUN LLVM_CONFIG=/usr/lib/llvm-14/bin/llvm-config pip3 install llvmlite
RUN pip3 install numpy
RUN pip3 install umap-learn

# Install FIt-SNE
RUN git clone --branch v1.2.1 https://github.com/KlugerLab/FIt-SNE.git
RUN g++ -std=c++11 -O3 FIt-SNE/src/sptree.cpp FIt-SNE/src/tsne.cpp FIt-SNE/src/nbodyfft.cpp -o bin/fast_tsne -pthread -lfftw3 -lm


RUN R -e "update.packages(ask = FALSE)"

# Install BiocManager and Bioconductor packages as root
RUN R -e "install.packages('BiocManager')"
RUN R -e "BiocManager::install(version = '3.18', ask = F)"
RUN R -e "BiocManager::install('org.Hs.eg.db', ask = F)"
RUN R -e "BiocManager::install('glmGamPoi', ask = F)"
RUN R -e "BiocManager::install('clusterProfiler', ask = F)"
RUN R -e "BiocManager::install(c('multtest', 'S4Vectors', 'SummarizedExperiment', \
  'SingleCellExperiment', 'MAST', 'DESeq2', 'BiocGenerics', 'GenomicRanges', 'IRanges', \
  'rtracklayer', 'monocle', 'Biobase', 'limma'), ask = F)"

# Install CRAN packages in batches for layering
RUN R -e "install.packages(c('devtools', 'tidyverse'), dependencies=TRUE)"
RUN R -e "install.packages(c('kableExtra', 'pander'), dependencies=TRUE)"
RUN R -e "install.packages(c('ggpubr', 'magrittr'), dependencies=TRUE)"
RUN R -e "install.packages(c('scales', 'patchwork', 'Hmisc'), dependencies=TRUE)"
RUN R -e "install.packages('MASS', dependencies=TRUE)"
RUN R -e "install.packages(c('factoextra', 'FactoMineR', 'Rtsne'), dependencies=TRUE)"
RUN R -e "install.packages(c('M3C', 'RColorBrewer', 'qpdf'), dependencies=TRUE)"
RUN R -e "install.packages(c('gridExtra', 'pdftools', 'remotes'), dependencies=TRUE)"
RUN R -e "install.packages(c('seuratObject'), dependencies=TRUE)"

# Install packages from GitHub
RUN R -e "remotes::install_github('satijalab/seurat-wrappers', ref = 'seurat5', quiet = TRUE)"
RUN R -e "remotes::install_github('mojaveazure/seurat-disk')"
RUN R -e "remotes::install_github('satijalab/seurat', ref = 'seurat5', quiet = TRUE)"
RUN R -e "remotes::install_github('bnprks/BPCells', quiet = TRUE)"

RUN R -e "BiocManager::install('GEOquery')"

# Modify ImageMagick policy
RUN sed -i 's/rights="none" pattern="PDF"/rights="read|write" pattern="PDF"/' /etc/ImageMagick-6/policy.xml


COPY stage/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Create a new user 'ruser'
RUN useradd -m ruser

# Set working directory to ruser's home directory
WORKDIR /home/ruser

# Switch to ruser for executing the container
USER ruser

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
