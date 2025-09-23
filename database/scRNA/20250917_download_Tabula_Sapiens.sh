mkdir -p /data/cqs/references/Tabula_Sapiens
cd /data/cqs/references/Tabula_Sapiens

if [[ ! -s TabulaSapiens.v2.rds ]]; then
  if [[ ! -s TabulaSapiens.v2.h5ad ]]; then
    #https://cellxgene.cziscience.com/e/53d208b0-2cfd-4366-9866-c3c6114081bc.cxg/ #most recent version on 20250917.
    echo wget -O TabulaSapiens.v2.h5ad https://datasets.cellxgene.cziscience.com/946fa48d-a0ac-4e5b-80fc-1d96cb5083a7.h5ad
    wget -O TabulaSapiens.v2.h5ad https://datasets.cellxgene.cziscience.com/946fa48d-a0ac-4e5b-80fc-1d96cb5083a7.h5ad
  fi

  if [[ ! -s TabulaSapiens.v2.h5seurat ]]; then
    echo h5ad to h5seurat
    R -e "source('/nobackup/h_cqs/shengq2/program/ngsperl/lib/scRNA/scRNA_func.r');h5ad_to_h5seurat('TabulaSapiens.v2.h5ad')"
  fi

  echo h5seurat to rds
  R -e "library(Seurat);library(SeuratDisk);obj=LoadH5Seurat('TabulaSapiens.v2.h5seurat',assays='RNA');saveRDS(obj,'TabulaSapiens.v2.rds')"

  if [[ -s TabulaSapiens.v2.rds ]]; then
    # keep TabulaSapiens.v2.h5ad and delete h5seurat
    rm TabulaSapiens.v2.h5seurat
  fi
fi
