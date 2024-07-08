mkdir -p /data/cqs/references/gencode/GRCh38.p13/bwa_methylation_index
cd /data/cqs/references/gencode/GRCh38.p13/bwa_methylation_index

ln -s ../GRCh38.primary_assembly.genome.fa GRCh38.primary_assembly.genome.fa

bwa index -a bwtsw GRCh38.primary_assembly.genome.fa

buildindex.pl -f GRCh38.primary_assembly.genome.fa

