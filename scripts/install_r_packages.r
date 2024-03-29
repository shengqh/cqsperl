Sys.setenv('R_REMOTES_NO_ERRORS_FROM_WARNINGS' = 'true')
if('BiocManager' %in% rownames(installed.packages()) == FALSE) {install.packages('BiocManager', update=FALSE, ask=FALSE, dependencies=TRUE)}

my_install_package<-function(pkg){
  if(!(pkg %in% rownames(installed.packages()))) {
    BiocManager::install(pkg, update=FALSE, ask=FALSE, dependencies=TRUE)
  }
}

#if('hdf5r' %in% rownames(installed.packages()) == FALSE) {BiocManager::install('hdf5r', update=FALSE, ask=FALSE, dependencies=TRUE)}
my_install_package('remotes')
my_install_package('BiocParallel')
my_install_package('tidyverse')
my_install_package('Seurat')
my_install_package('archR')
my_install_package('DESeq2')
my_install_package('MatrixEQTL')
my_install_package('edgeR')
my_install_package('ChIPpeakAnno')
my_install_package('ComplexHeatmap')
my_install_package('DiffBind')
my_install_package('WebGestaltR')

if('RColorBrewer' %in% rownames(installed.packages()) == FALSE) {BiocManager::install('RColorBrewer', update=FALSE, ask=FALSE, dependencies=TRUE)}
if('VennDiagram' %in% rownames(installed.packages()) == FALSE) {BiocManager::install('VennDiagram', update=FALSE, ask=FALSE, dependencies=TRUE)}
if('ggplot2' %in% rownames(installed.packages()) == FALSE) {BiocManager::install('ggplot2', update=FALSE, ask=FALSE, dependencies=TRUE)}
if('grid' %in% rownames(installed.packages()) == FALSE) {BiocManager::install('grid', update=FALSE, ask=FALSE, dependencies=TRUE)}
if('heatmap3' %in% rownames(installed.packages()) == FALSE) {BiocManager::install('heatmap3', update=FALSE, ask=FALSE, dependencies=TRUE)}
if('lattice' %in% rownames(installed.packages()) == FALSE) {BiocManager::install('lattice', update=FALSE, ask=FALSE, dependencies=TRUE)}
if('reshape2' %in% rownames(installed.packages()) == FALSE) {BiocManager::install('reshape2', update=FALSE, ask=FALSE, dependencies=TRUE)}
if('rmarkdown' %in% rownames(installed.packages()) == FALSE) {BiocManager::install('rmarkdown', update=FALSE, ask=FALSE, dependencies=TRUE)}
if('scales' %in% rownames(installed.packages()) == FALSE) {BiocManager::install('scales', update=FALSE, ask=FALSE, dependencies=TRUE)}
if('wordcloud' %in% rownames(installed.packages()) == FALSE) {BiocManager::install('wordcloud', update=FALSE, ask=FALSE, dependencies=TRUE)}
if('rmarkdown' %in% rownames(installed.packages()) == FALSE) {BiocManager::install('rmarkdown', update=FALSE, ask=FALSE, dependencies=TRUE)}
if('DESeq2' %in% rownames(installed.packages()) == FALSE) {BiocManager::install('DESeq2', update=FALSE, ask=FALSE, dependencies=TRUE)}
if('DNAcopy' %in% rownames(installed.packages()) == FALSE) {BiocManager::install('DNAcopy', update=FALSE, ask=FALSE, dependencies=TRUE)}
if('DT' %in% rownames(installed.packages()) == FALSE) {BiocManager::install('DT', update=FALSE, ask=FALSE, dependencies=TRUE)}
if('DirichletReg' %in% rownames(installed.packages()) == FALSE) {BiocManager::install('DirichletReg', update=FALSE, ask=FALSE, dependencies=TRUE)}
if('GenABEL' %in% rownames(installed.packages()) == FALSE) {BiocManager::install('GenABEL', update=FALSE, ask=FALSE, dependencies=TRUE)}
if('GenomicRanges' %in% rownames(installed.packages()) == FALSE) {BiocManager::install('GenomicRanges', update=FALSE, ask=FALSE, dependencies=TRUE)}
if('KEGG.db' %in% rownames(installed.packages()) == FALSE) {BiocManager::install('KEGG.db', update=FALSE, ask=FALSE, dependencies=TRUE)}
if('KEGGprofile' %in% rownames(installed.packages()) == FALSE) {BiocManager::install('KEGGprofile', update=FALSE, ask=FALSE, dependencies=TRUE)}
if('R.utils' %in% rownames(installed.packages()) == FALSE) {BiocManager::install('R.utils', update=FALSE, ask=FALSE, dependencies=TRUE)}
if('RColorBrewer' %in% rownames(installed.packages()) == FALSE) {BiocManager::install('RColorBrewer', update=FALSE, ask=FALSE, dependencies=TRUE)}
if('RCurl' %in% rownames(installed.packages()) == FALSE) {BiocManager::install('RCurl', update=FALSE, ask=FALSE, dependencies=TRUE)}
if('Rcpp' %in% rownames(installed.packages()) == FALSE) {BiocManager::install('Rcpp', update=FALSE, ask=FALSE, dependencies=TRUE)}
if('Rsamtools' %in% rownames(installed.packages()) == FALSE) {BiocManager::install('Rsamtools', update=FALSE, ask=FALSE, dependencies=TRUE)}
if('Seurat' %in% rownames(installed.packages()) == FALSE) {BiocManager::install('Seurat', update=FALSE, ask=FALSE, dependencies=TRUE)}
if('SummarizedExperiment' %in% rownames(installed.packages()) == FALSE) {BiocManager::install('SummarizedExperiment', update=FALSE, ask=FALSE, dependencies=TRUE)}
if('TCGAbiolinks' %in% rownames(installed.packages()) == FALSE) {BiocManager::install('TCGAbiolinks', update=FALSE, ask=FALSE, dependencies=TRUE)}
if('TEQC' %in% rownames(installed.packages()) == FALSE) {BiocManager::install('TEQC', update=FALSE, ask=FALSE, dependencies=TRUE)}
if('TxDb.Hsapiens.UCSC.hg38.knownGene' %in% rownames(installed.packages()) == FALSE) {BiocManager::install('TxDb.Hsapiens.UCSC.hg38.knownGene', update=FALSE, ask=FALSE, dependencies=TRUE)}
if('XML' %in% rownames(installed.packages()) == FALSE) {BiocManager::install('XML', update=FALSE, ask=FALSE, dependencies=TRUE)}
if('biomaRt' %in% rownames(installed.packages()) == FALSE) {BiocManager::install('biomaRt', update=FALSE, ask=FALSE, dependencies=TRUE)}
if('cn.mops' %in% rownames(installed.packages()) == FALSE) {BiocManager::install('cn.mops', update=FALSE, ask=FALSE, dependencies=TRUE)}
if('colorRamps' %in% rownames(installed.packages()) == FALSE) {BiocManager::install('colorRamps', update=FALSE, ask=FALSE, dependencies=TRUE)}
if('cowplot' %in% rownames(installed.packages()) == FALSE) {BiocManager::install('cowplot', update=FALSE, ask=FALSE, dependencies=TRUE)}
if('choisy/cutoff' %in% rownames(installed.packages()) == FALSE) {BiocManager::install('choisy/cutoff', update=FALSE, ask=FALSE, dependencies=TRUE)}
if('data.table' %in% rownames(installed.packages()) == FALSE) {BiocManager::install('data.table', update=FALSE, ask=FALSE, dependencies=TRUE)}
if('dendextend' %in% rownames(installed.packages()) == FALSE) {BiocManager::install('dendextend', update=FALSE, ask=FALSE, dependencies=TRUE)}
if('digest' %in% rownames(installed.packages()) == FALSE) {BiocManager::install('digest', update=FALSE, ask=FALSE, dependencies=TRUE)}
if('dplyr' %in% rownames(installed.packages()) == FALSE) {BiocManager::install('dplyr', update=FALSE, ask=FALSE, dependencies=TRUE)}
if('edgeR' %in% rownames(installed.packages()) == FALSE) {BiocManager::install('edgeR', update=FALSE, ask=FALSE, dependencies=TRUE)}
if('forcats' %in% rownames(installed.packages()) == FALSE) {BiocManager::install('forcats', update=FALSE, ask=FALSE, dependencies=TRUE)}
if('genefilter' %in% rownames(installed.packages()) == FALSE) {BiocManager::install('genefilter', update=FALSE, ask=FALSE, dependencies=TRUE)}
if('getopt' %in% rownames(installed.packages()) == FALSE) {BiocManager::install('getopt', update=FALSE, ask=FALSE, dependencies=TRUE)}
if('ggExtra' %in% rownames(installed.packages()) == FALSE) {BiocManager::install('ggExtra', update=FALSE, ask=FALSE, dependencies=TRUE)}
if('ggplot2' %in% rownames(installed.packages()) == FALSE) {BiocManager::install('ggplot2', update=FALSE, ask=FALSE, dependencies=TRUE)}
if('ggpubr' %in% rownames(installed.packages()) == FALSE) {BiocManager::install('ggpubr', update=FALSE, ask=FALSE, dependencies=TRUE)}
if('grid' %in% rownames(installed.packages()) == FALSE) {BiocManager::install('grid', update=FALSE, ask=FALSE, dependencies=TRUE)}
if('gridExtra' %in% rownames(installed.packages()) == FALSE) {BiocManager::install('gridExtra', update=FALSE, ask=FALSE, dependencies=TRUE)}
if('gtools' %in% rownames(installed.packages()) == FALSE) {BiocManager::install('gtools', update=FALSE, ask=FALSE, dependencies=TRUE)}
if('heatmap3' %in% rownames(installed.packages()) == FALSE) {BiocManager::install('heatmap3', update=FALSE, ask=FALSE, dependencies=TRUE)}
if('htmltools' %in% rownames(installed.packages()) == FALSE) {BiocManager::install('htmltools', update=FALSE, ask=FALSE, dependencies=TRUE)}
if('kableExtra' %in% rownames(installed.packages()) == FALSE) {BiocManager::install('kableExtra', update=FALSE, ask=FALSE, dependencies=TRUE)}
if('knitr' %in% rownames(installed.packages()) == FALSE) {BiocManager::install('knitr', update=FALSE, ask=FALSE, dependencies=TRUE)}
if('limma' %in% rownames(installed.packages()) == FALSE) {BiocManager::install('limma', update=FALSE, ask=FALSE, dependencies=TRUE)}
if('maftools' %in% rownames(installed.packages()) == FALSE) {BiocManager::install('maftools', update=FALSE, ask=FALSE, dependencies=TRUE)}
if('patchwork' %in% rownames(installed.packages()) == FALSE) {BiocManager::install('patchwork', update=FALSE, ask=FALSE, dependencies=TRUE)}
if('pheatmap' %in% rownames(installed.packages()) == FALSE) {BiocManager::install('pheatmap', update=FALSE, ask=FALSE, dependencies=TRUE)}
if('plyr' %in% rownames(installed.packages()) == FALSE) {BiocManager::install('plyr', update=FALSE, ask=FALSE, dependencies=TRUE)}
if('png' %in% rownames(installed.packages()) == FALSE) {BiocManager::install('png', update=FALSE, ask=FALSE, dependencies=TRUE)}
if('preprocessCore' %in% rownames(installed.packages()) == FALSE) {BiocManager::install('preprocessCore', update=FALSE, ask=FALSE, dependencies=TRUE)}
if('readr' %in% rownames(installed.packages()) == FALSE) {BiocManager::install('readr', update=FALSE, ask=FALSE, dependencies=TRUE)}
if('reshape2' %in% rownames(installed.packages()) == FALSE) {BiocManager::install('reshape2', update=FALSE, ask=FALSE, dependencies=TRUE)}
if('rlist' %in% rownames(installed.packages()) == FALSE) {BiocManager::install('rlist', update=FALSE, ask=FALSE, dependencies=TRUE)}
if('rmarkdown' %in% rownames(installed.packages()) == FALSE) {BiocManager::install('rmarkdown', update=FALSE, ask=FALSE, dependencies=TRUE)}
if('rmdformats' %in% rownames(installed.packages()) == FALSE) {BiocManager::install('rmdformats', update=FALSE, ask=FALSE, dependencies=TRUE)}
if('rsnps' %in% rownames(installed.packages()) == FALSE) {BiocManager::install('rsnps', update=FALSE, ask=FALSE, dependencies=TRUE)}
if('rtracklayer' %in% rownames(installed.packages()) == FALSE) {BiocManager::install('rtracklayer', update=FALSE, ask=FALSE, dependencies=TRUE)}
if('scales' %in% rownames(installed.packages()) == FALSE) {BiocManager::install('scales', update=FALSE, ask=FALSE, dependencies=TRUE)}
if('stringr' %in% rownames(installed.packages()) == FALSE) {BiocManager::install('stringr', update=FALSE, ask=FALSE, dependencies=TRUE)}
if('zoo' %in% rownames(installed.packages()) == FALSE) {BiocManager::install('zoo', update=FALSE, ask=FALSE, dependencies=TRUE)}
if('ChIPQC' %in% rownames(installed.packages()) == FALSE) {BiocManager::install('shengqh/ChIPQC', update=FALSE, ask=FALSE, dependencies=TRUE)}
if('scRNABatchQC' %in% rownames(installed.packages()) == FALSE) {BiocManager::install('liuqivandy/scRNABatchQC', update=FALSE, ask=FALSE, dependencies=TRUE)}
if('scMRMA' %in% rownames(installed.packages()) == FALSE) {BiocManager::install('JiaLiVUMC/scMRMA', update=FALSE, ask=FALSE, dependencies=TRUE)}

