module load GCC/10.2.0
module load X11/.20201008
module load cairo/.1.16.0
module load libreadline/.8.0
module load PCRE2/.10.35
module load XZ/.5.2.5
module load OpenBLAS/0.3.12

R_VER="R-4.3.0"
cd /nobackup/h_cqs/shengq2/source
wget https://cran.r-project.org/src/base/R-4/${R_VER}.tar.gz
tar -xzvf ${R_VER}.tar.gz
cd ${R_VER}
./configure --with-ICU --with-jpeglib --with-libpng --with-lapack --with-blas --with-tcltk --with-recommended-packages --enable-R-profiling --enable-memory-profiling --with-cairo --prefix=/data/cqs/softwares/${R_VER} LDFLAGS="-I/data/cqs/softwares/local/include -L/data/cqs/softwares/local/lib -fPIC" --enable-R-static-lib
make
make install

