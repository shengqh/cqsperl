setwd('/data/cqs/references/Tabula_Sapiens/')

library(Seurat)
library(SeuratData)
library(SeuratDisk)
library(hdf5r)

h5ad_files=list.files(pattern='*.h5ad.zip')
h5ad_file=h5ad_files[1]
for(h5ad_file in h5ad_files){
  rds_file=sub('.h5ad.zip$', '.rds', h5ad_file)
  if(file.exists(rds_file)){
    next
  }else{
    cat("process ", h5ad_file, "\n")
    unzipped_file=sub('.zip$', '', h5ad_file)
    if(!file.exists(unzipped_file)){
      cat("unzip ", h5ad_file, "\n")
      unzip(h5ad_file)
    }

    h5seurat_file <- sub('.h5ad$', '.h5seurat', unzipped_file)
    h5seurat_fix_file <- paste0(h5seurat_file, '.fixed')
    if(!file.exists(h5seurat_file)){
      cat("convert h5ad to h5seurat\n")
      Convert(unzipped_file, dest = 'h5seurat')

      if(file.exists(h5seurat_fix_file)){
        file.remove(h5seurat_fix_file)
      }
    }

    if(!file.exists(h5seurat_fix_file)){
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
      writeLines("fixed", h5seurat_fix_file)
    }

    cat("LoadH5Seurat\n")
    obj=LoadH5Seurat(h5seurat_file,assays='RNA')

    cat("saveRDS\n")
    saveRDS(obj, rds_file)
  }
}

