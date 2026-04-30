#singularity build --disable-cache rstudio.4.3.0.sif docker://rocker/rstudio:4.3.0
cd /nobackup/h_cqs/softwares/singularity_images

singularity build --disable-cache cqs_rstudio.20260410.sif docker://shengqh/cqs_rstudio:20260410

