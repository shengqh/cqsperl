wget http://origin-download.mono-project.com/sources/libgdiplus/libgdiplus-2.10.tar.bz2
bzip2 -d libgdiplus-2.10.tar.bz2
tar -xvf libgdiplus-2.10.tar
cd libgdiplus-2.10
./configure --prefix=/scratch/cqs/shengq1/local
make
make install

