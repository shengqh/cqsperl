setwd('/data/cqs/references/Tabula_Sapiens')

library(Seurat)
library(SeuratData)
library(SeuratDisk)
library(hdf5r)

h5ad_file <- 'TabulaSapiens.h5ad'
Convert(h5ad_file, dest = 'h5seurat')

h5seurat_file <- 'TabulaSapiens.h5seurat'

#https://github.com/mojaveazure/seurat-disk/issues/109
f <- H5File$new(h5seurat_file, "r+")
groups <- f$ls(recursive = TRUE)

for (name in groups$name[grepl("categories$", groups$name)]) {
  names <- strsplit(name, "/")[[1]]
  names <- c(names[1:length(names) - 1], "levels")
  new_name <- paste(names, collapse = "/")
  f[[new_name]] <- f[[name]]
}

for (name in groups$name[grepl("codes$", groups$name)]) {
  names <- strsplit(name, "/")[[1]]
  names <- c(names[1:length(names) - 1], "values")
  new_name <- paste(names, collapse = "/")
  f[[new_name]] <- f[[name]]
  grp <- f[[new_name]]
  grp$write(args = list(1:grp$dims), value = grp$read() + 1)
}

f$close_all()

obj=LoadH5Seurat(h5seurat_file,assays='RNA')

saveRDS(obj,'TabulaSapiens.rds')
