cd /scratch/cqs/shengq2/source
wget http://research-pub.gene.com/gmap/src/gmap-gsnap-2021-12-17.tar.gz
tar -xzvf gmap-gsnap-2021-12-17.tar.gz
cd gmap-2021-12-17
./configure --prefix=/data/cqs/softwares/local/
make
make install

#docker 
#pegi3s/gmap-gsnap