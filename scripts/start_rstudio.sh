cd /scratch/cqs/shengq2/rstudio

if [[ ! -s tmp ]]; then
  mkdir tmp
fi

if [[ ! -s rstudio-server ]]; then
  mkdir rstudio-server
fi

#singularity exec -e -H /scratch/cqs/shengq2/rstudio --bind=/scratch/,/data,/scratch/cqs/shengq2/rstudio/rstudio-server:/var/run/rstudio-server,/scratch/cqs/shengq2/rstudio/tmp:/tmp/rstudio-server /scratch/cqs_share/softwares/singularity/rstudio.simg env PASSWORD='xyz' RSTUDIO_SESSION_TIMEOUT='0' rserver --auth-none=0  --auth-pam-helper-path=pam-helper --www-address=127.0.0.1 --www-port=7575
singularity exec -e -H /scratch/cqs/shengq2/rstudio --bind=/scratch/,/data,/scratch/cqs/shengq2/rstudio/rstudio-server:/var/run/rstudio-server,/scratch/cqs/shengq2/rstudio/tmp:/tmp/rstudio-server /scratch/cqs_share/softwares/singularity/rstudio.simg env PASSWORD='xyz' RSTUDIO_SESSION_TIMEOUT='0' rserver --auth-none=1  --auth-pam-helper-path=pam-helper --www-address=127.0.0.1 --www-port=7575

#Run following command in your windows prompt (replace shengq2 with your username)
#ssh -Nf -l shengq2 -L 7575:localhost:7575 cqs1.accre.vanderbilt.edu

#open http://localhost:7575/ in your windows web browser
