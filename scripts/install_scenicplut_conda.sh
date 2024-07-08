cd /nobackup/h_cqs/shengq2/temp

conda create --name scenicplus python=3.11 -y
conda activate scenicplus

#need to use cargo in scenicplus installation, so we have to install rust first
conda install rust

git clone https://github.com/aertslab/scenicplus
cd scenicplus
pip install .
cd ..
rm -rf scenicplus

conda install ant

cd /data/cqs/softwares
git clone https://github.com/mimno/Mallet.git
cd Mallet
ant

