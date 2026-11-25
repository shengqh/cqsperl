cd /data/cqs/softwares/singularity
rm -f report.sif

singularity build --disable-cache report.20250415.sif docker://shengqh/report:20250415
ln -s report.20250415.sif report.sif
