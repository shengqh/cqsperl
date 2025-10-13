
# The twist mm10 bed file has a few chromosomes not in the mm10 reference genome downloaded from AWS iGenomes
# chr4_GL456216_random
# chr4_GL456350_random
# chr4_JH584293_random
# chr4_JH584294_random
# chr4_JH584295_random
# We need to build our own Bismark index for mm10 in order to use nextflow nf-core/methylseq pipeline

module load bismark/0.24.1

mkdir -p /data/cqs/references/igenomes/Mus_musculus/UCSC/mm10/Sequence/WholeGenomeFasta
cd /data/cqs/references/igenomes/Mus_musculus/UCSC/mm10/Sequence/WholeGenomeFasta

ln -s ../../../../../../ucsc/mm10/mm10.fa genome.fa
ln -s ../../../../../../ucsc/mm10/mm10.fa.fai genome.fa.fai
ln -s ../../../../../../ucsc/mm10/mm10.dict genome.dict

mkdir -p /data/cqs/references/igenomes/Mus_musculus/UCSC/mm10/Sequence/BismarkIndex
cd /data/cqs/references/igenomes/Mus_musculus/UCSC/mm10/Sequence/BismarkIndex

ln -s ../WholeGenomeFasta/genome.fa .
ln -s ../WholeGenomeFasta/genome.fa.fai .
ln -s ../WholeGenomeFasta/genome.dict .

bismark_genome_preparation --verbose --parallel 8 .
