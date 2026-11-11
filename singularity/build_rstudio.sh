#singularity build --disable-cache rstudio.4.3.0.sif docker://rocker/rstudio:4.3.0
cd /data/cqs/softwares/singularity

singularity build --disable-cache cqs_rstudio.20261111.sif docker://shengqh/cqs_rstudio:20261111

