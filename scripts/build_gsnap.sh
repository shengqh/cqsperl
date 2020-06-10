#./configure --prefix=/scratch/cqs/shengq1/local/ --disable-simd
./configure --with-simd-level=sse42 --prefix=/scratch/cqs/shengq1/local/
#./configure --prefix=/scratch/cqs/shengq1/local/
make
make install
cd /scratch/cqs/shengq1/local/bin/
rm gsnap
ln -s gsnap.sse42 gsnap
