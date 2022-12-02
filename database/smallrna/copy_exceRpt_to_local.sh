#copy all default files and folders from singularity image to local folder, then we can mount the root of the references instead of individual databases

singularity exec /data/cqs/softwares/singularity/excerpt_latest.sif cp /exceRpt_DB/randomBits.dat .

singularity exec /data/cqs/softwares/singularity/excerpt_latest.sif cp /exceRpt_DB/STAR_Parameters_Endogenous_smallRNA.in .

singularity exec /data/cqs/softwares/singularity/excerpt_latest.sif cp /exceRpt_DB/STAR_Parameters_Exogenous.in .   

singularity exec /data/cqs/softwares/singularity/excerpt_latest.sif cp -r /exceRpt_DB/UniVec .

singularity exec /data/cqs/softwares/singularity/excerpt_latest.sif cp -r /exceRpt_DB/adapters .

