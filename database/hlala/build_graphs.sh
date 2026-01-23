cd /data/cqs/softwares

git clone https://github.com/DiltheyLab/HLA-LA.git

cd HLA-LA

mkdir -p graphs
cd graphs
wget http://www.well.ox.ac.uk/downloads/PRG_MHC_GRCh38_withIMGT.tar.gz
tar -xvzf PRG_MHC_GRCh38_withIMGT.tar.gz
rm PRG_MHC_GRCh38_withIMGT.tar.gz
singularity exec -c -e -B /panfs,/data,/nobackup -H `pwd` /data/cqs/softwares/singularity/hlala.20251209.sif \
  HLA-LA --action prepareGraph --PRG_graph_dir PRG_MHC_GRCh38_withIMGT
