
if [[ ! -s nextgenmap.v0.5.5.sif ]]; then
  #singularity build --disable-cache nextgenmap.v0.5.5.sif docker://shengqh/cqs_nextgenmap:20240518
  singularity build --disable-cache nextgenmap.v0.5.5.sif docker://taniguti/nextgenmap:latest
  
fi

if [[ ! -s slamdunk.v0.4.3.sif ]]; then
  singularity build --disable-cache slamdunk.v0.4.3.sif docker://tobneu/slamdunk:v0.4.3
fi

