cd /data/cqs/softwares/singularity/

singularity build --disable-cache sra-tools.3.2.1.sif docker://ncbi/sra-tools:3.2.1

#3.3.0 deprecated output as one file which it not compatible with our pipeline, we will keep using 3.2.1
#singularity build --disable-cache sra-tools.3.3.0.sif docker://ncbi/sra-tools:3.3.0
