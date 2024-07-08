mkdir -p /data/cqs/references/Tabula_Sapiens
cd /data/cqs/references/Tabula_Sapiens

if [[ ! -s TabulaSapiens.rds ]]; then
  if [[ ! -s TabulaSapiens.h5ad.zip ]]; then
    echo wget -O TabulaSapiens.h5ad.zip https://figshare.com/ndownloader/files/40067134
    wget -O TabulaSapiens.h5ad.zip https://figshare.com/ndownloader/files/40067134
  fi

  if [[ ! -s TabulaSapiens.h5ad ]]; then
    unzip TabulaSapiens.h5ad.zip
  fi

  if [[ ! -s TabulaSapiens.h5seurat ]]; then
    echo h5ad to h5seurat
    #R -e "library(Seurat);library(SeuratData);library(SeuratDisk);library(hdf5r);Convert('TabulaSapiens.h5ad',dest='h5seurat')"
    R -e "source('/nobackup/h_cqs/shengq2/program/ngsperl/lib/scRNA/scRNA_func.r');h5ad_to_h5seurat('TabulaSapiens.h5ad')"
  fi

  echo h5seurat to rds
  R -e "library(Seurat);library(SeuratDisk);obj=LoadH5Seurat('TabulaSapiens.h5seurat',assays='RNA');saveRDS(obj,'TabulaSapiens.rds')"

  if [[ -s TabulaSapiens.rds ]]; then
    #rm TabulaSapiens.h5ad.zip
    rm TabulaSapiens.h5ad
    rm TabulaSapiens.h5seurat
  fi
fi

if [[ ! -s TS_Liver.rds ]]; then
  if [[ ! -s TS_Liver.h5ad.zip ]]; then
    wget -O TS_Liver.h5ad.zip https://figshare.com/ndownloader/files/34701985
  fi

  if [[ ! -s TS_Liver.h5ad ]]; then
    unzip TS_Liver.h5ad.zip
  fi

  if [[ ! -s TS_Liver.h5seurat ]]; then
    echo h5ad to h5seurat
    R -e "library(Seurat);library(SeuratData);library(SeuratDisk);library(hdf5r);Convert('TS_Liver.h5ad',dest='h5seurat')"
  fi

  R -e "library(Seurat);library(SeuratDisk);obj=LoadH5Seurat('TS_Liver.h5seurat',assays='RNA');saveRDS(obj,'TS_Liver.rds')"

  if [[ -s TS_Liver.rds ]]; then
    #rm TS_Liver.h5ad.zip
    rm TS_Liver.h5ad
    rm TS_Liver.h5seurat
  fi
fi
