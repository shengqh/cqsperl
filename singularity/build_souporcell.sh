if [[ ! -s Singularity.2.5 ]]; then
  wget https://github.com/wheaton5/souporcell/raw/master/Singularity.2.5
fi

singularity build --disable-cache --fakeroot souporcell.2.5.sif Singularity.2.5

rm Singularity.2.5

