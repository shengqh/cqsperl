#gsutil -u ravi-shah-projects cp gs://regev-lab/resources/cellranger/refdata-cellranger-GRCh38_premrna-3.0.0.tar.gz gs://vumc_shengq2_rv/

cd /data/cqs/references/cumulus/

if [[ ! -s refdata-cellranger-GRCh38_premrna-3.0.0/genes/genes.gtf ]]; then
  if [[ -s /workspace/shengq2/references/refdata-cellranger-GRCh38_premrna-3.0.0.tar.gz ]]; then
    cp refdata-cellranger-GRCh38_premrna-3.0.0.tar.gz .
    tar -xzvf refdata-cellranger-GRCh38_premrna-3.0.0.tar.gz
    rm refdata-cellranger-GRCh38_premrna-3.0.0.tar.gz
  else
    gsutil cp gs://vumc_shengq2_rv/refdata-cellranger-GRCh38_premrna-3.0.0.tar.gz .
    tar -xzvf refdata-cellranger-GRCh38_premrna-3.0.0.tar.gz
    mv refdata-cellranger-GRCh38_premrna-3.0.0.tar.gz /workspace/shengq2/references/
  fi
fi

