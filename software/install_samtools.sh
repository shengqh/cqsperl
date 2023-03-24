cd /scratch/cqs/shengq2/source

version="1.17"

wget https://github.com/samtools/htslib/releases/download/${version}/htslib-${version}.tar.bz2
tar -xzvf htslib-${version}.tar.bz2
cd htslib-${version}
./configure --prefix=/data/cqs/softwares/local/
make
make install

wget https://github.com/samtools/samtools/releases/download/${version}/samtools-${version}.tar.bz2
tar -xzvf samtools-${version}.tar.bz2
cd samtools-${version}
./configure --prefix=/data/cqs/softwares/local/
make
make install

wget https://github.com/samtools/bcftools/releases/download/${version}/bcftools-${version}.tar.bz2
tar -xzvf bcftools-${version}.tar.bz2
cd bcftools-${version}
./configure --prefix=/data/cqs/softwares/local/
make
make install
