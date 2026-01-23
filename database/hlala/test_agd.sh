cd /nobackup/h_cqs/shengq2/biovu/AGD5000/data
singularity exec -c -e -B /panfs,/data,/nobackup -H `pwd` /data/cqs/softwares/singularity/hlala.20251209.sif \
  HLA-LA.pl -BAM 100022391.cram \
  --graph PRG_MHC_GRCh38_withIMGT \
  --sampleID 100022391 \
  --maxThreads 24 \
  -workingDir hlala \
  -customGraphDir /data/cqs/softwares/HLA-LA/graphs \
  -samtools_T /nobackup/h_cqs/shengq2/biovu/dragen/ica/hg38.fa
