Sys.setenv('R_REMOTES_NO_ERRORS_FROM_WARNINGS' = 'true')
if('BiocManager' %in% rownames(installed.packages()) == FALSE) {install.packages('BiocManager', update=FALSE, ask=FALSE, dependencies=TRUE)}
#if('hdf5r' %in% rownames(installed.packages()) == FALSE) {BiocManager::install('hdf5r', update=FALSE, ask=FALSE, dependencies=TRUE)}
if('remotes' %in% rownames(installed.packages()) == FALSE) {BiocManager::install('remotes', update=FALSE, ask=FALSE, dependencies=TRUE)}

BiocManager::install('shengqh/cutoff', update=FALSE, ask=FALSE, dependencies=TRUE)

BiocManager::install('chris-mcginnis-ucsf/DoubletFinder', update=FALSE, ask=FALSE, dependencies=TRUE)

BiocManager::install('liuqivandy/scRNABatchQC', update=FALSE, ask=FALSE, dependencies=TRUE)
