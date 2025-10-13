module load bismark/0.24.1

mkdir -p /data/cqs/references/igenomes/Homo_sapiens/NCBI/GRCh38/Sequence/WholeGenomeFasta
cd /data/cqs/references/igenomes/Homo_sapiens/NCBI/GRCh38/Sequence/WholeGenomeFasta

#GRCh38.p13 and GRCh38.p14 have identical genome sequence file.
ln -s ../../../../../../gencode/GRCh38.p13/GRCh38.primary_assembly.genome.fa genome.fa
ln -s ../../../../../../gencode/GRCh38.p13/GRCh38.primary_assembly.genome.fa.fai genome.fa.fai
ln -s ../../../../../../gencode/GRCh38.p13/GRCh38.primary_assembly.genome.dict genome.dict

mkdir -p /data/cqs/references/igenomes/Homo_sapiens/NCBI/GRCh38/Sequence/BismarkIndex
cd /data/cqs/references/igenomes/Homo_sapiens/NCBI/GRCh38/Sequence/BismarkIndex

ln -s ../WholeGenomeFasta/genome.fa .
ln -s ../WholeGenomeFasta/genome.fa.fai .
ln -s ../WholeGenomeFasta/genome.dict .

bismark_genome_preparation --verbose --parallel 32 .
