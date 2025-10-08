
mkdir -p /data/cqs/references/gencode/GRCh38.p13/abismal_index_1.4.2
cd /data/cqs/references/gencode/GRCh38.p13/abismal_index_1.4.2

ln -s ../GRCh38.primary_assembly.genome.fa .
ln -s ../GRCh38.primary_assembly.genome.fa.fai .
ln -s ../GRCh38.primary_assembly.genome.dict .

singularity exec -c -e -B /panfs,/data,/dors,/nobackup,/tmp -H `pwd`  /data/cqs/softwares/singularity/cqs-dnmtools.20231214.sif dnmtools abismalidx -t 32 GRCh38.primary_assembly.genome.fa  GRCh38.primary_assembly.genome
