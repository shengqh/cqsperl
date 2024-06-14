source /data/cqs/softwares/cqsperl/scripts/binds.sh

rimg=/data/cqs/softwares/singularity/cqs_bioconductor.3_19_R_4_4_0.20240510.sif

rver=$(singularity exec -c -e -B $mybinds $rimg R --version | grep "R version" | cut -d ' ' -f3)

rlib=/nobackup/h_cqs/rlibs_$rver/$USER

mkdir -p $rlib

ROOT_DIR=/nobackup/h_cqs/rstudioserver/$USER

mkdir -p $ROOT_DIR

cd $ROOT_DIR
mkdir -p tmp
mkdir -p run
mkdir -p lib

PASSWORD='xyz' RSTUDIO_SESSION_TIMEOUT='0' singularity exec -c -B $mybinds \
    -B ${ROOT_DIR}/run:/var/run/rstudio-server \
    -B ${ROOT_DIR}/lib:/var/lib/rstudio-server \
    -B ${ROOT_DIR}/tmp:/tmp/rstudio-server \
    --env LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib/jvm/java-11-openjdk-amd64/lib/server \
    --env R_LIBS="$rlib" \
    $rimg \
    rserver --auth-none=0 \
    --server-user $USER \
    --auth-pam-helper-path=pam-helper \
    --www-address=127.0.0.1 \
    --secure-cookie-key-file /tmp/${USER}/rstudio-server/r4.4/${USER}_secure-cookie-key \
    --www-port=8787

