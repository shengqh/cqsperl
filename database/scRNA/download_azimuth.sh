mkdir -f /data/cqs/references/scrna/azimuth
cd /data/cqs/references/scrna/azimuth

wget http://seurat.nygenome.org/src/contrib/adiposeref.SeuratData_1.0.0.tar.gz
tar -xzvf adiposeref.SeuratData_1.0.0.tar.gz
rm adiposeref.SeuratData_1.0.0.tar.gz

echo 'Azimuth_ref => "/data/cqs/references/scrna/azimuth/adiposeref.SeuratData/inst/azimuth",'

#https://zenodo.org/records/7770308
mkdir -f /data/cqs/references/scrna/azimuth/liver
cd /data/cqs/references/scrna/azimuth/liver
wget https://zenodo.org/records/7770308/files/idx.annoy
wget https://zenodo.org/records/7770308/files/ref.Rds
