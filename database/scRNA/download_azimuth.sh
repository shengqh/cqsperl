mkdir -p /data/cqs/references/scrna/azimuth
cd /data/cqs/references/scrna/azimuth

R -f /nobackup/h_cqs/shengq2/program/cqsperl/database/scRNA/download_azimuth.r

#https://zenodo.org/records/7770308
mkdir -p /data/cqs/references/scrna/azimuth/liverref.SeuratData/azimuth
cd /data/cqs/references/scrna/azimuth/liverref.SeuratData/azimuth

if [ ! -s "idx.annoy" ]; then
  wget https://zenodo.org/records/7770308/files/idx.annoy
fi

if [ ! -s "idx.annoy.dna" ]; then
  wget https://zenodo.org/records/7770308/files/ref.Rds
fi
