#mirbase
cd /scratch/cqs_share/references/mirbase/v22
ftp://mirbase.org/pub/mirbase/CURRENT/mature.fa.gz
gunzip mature.fa.gz
buildindex.pl -f mature.fa -b

wget ftp://mirbase.org/pub/mirbase/CURRENT/genomes/hsa.gff3
cp /home/shengq2/program/cqsperl/database/smallrna/hsa_hg19_liftOver.bed .
wget ftp://mirbase.org/pub/mirbase/CURRENT/genomes/mmu.gff3
wget ftp://mirbase.org/pub/mirbase/CURRENT/genomes/rno.gff3

#hg19
cd /scratch/cqs_share/references/gencode/GRCh37.p13
wget ftp://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_19/gencode.v19.chr_patch_hapl_scaff.annotation.gtf.gz
gunzip gencode.v19.chr_patch_hapl_scaff.annotation.gtf.gz
wget ftp://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_19/GRCh37.p13.genome.fa.gz
gunzip GRCh37.p13.genome.fa.gz

#hg38
cd /scratch/cqs_share/references/gencode/GRCh38.p13
wget ftp://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_33/gencode.v33.annotation.gtf.gz
gunzip gencode.v33.annotation.gtf.gz
wget ftp://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_33/GRCh38.primary_assembly.genome.fa.gz
gunzip GRCh38.primary_assembly.genome.fa.gz

#mm10
cd /scratch/cqs_share/references/gencode/GRCm38.p6
wget ftp://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_mouse/release_M24/gencode.vM24.annotation.gtf.gz
gunzip gencode.vM24.annotation.gtf.gz
wget ftp://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_mouse/release_M24/GRCm38.primary_assembly.genome.fa.gz
gunzip GRCm38.primary_assembly.genome.fa.gz

#rn6
cd /scratch/cqs_share/references/ensembl/Rnor_6.0
wget ftp://ftp.ensembl.org/pub/release-99/gtf/rattus_norvegicus/Rattus_norvegicus.Rnor_6.0.99.gtf.gz
gunzip Rattus_norvegicus.Rnor_6.0.99.gtf.gz
wget ftp://ftp.ensembl.org/pub/release-99/fasta/rattus_norvegicus/dna/Rattus_norvegicus.Rnor_6.0.dna.toplevel.fa.gz
gunzip Rattus_norvegicus.Rnor_6.0.dna.toplevel.fa.gz

#smallrna
cd /scratch/cqs_share/references/smallrna

wget https://cqsweb.app.vumc.org/download1/annotateGenome/TIGER/GtRNAdb2.tar.gz
tar -xzvf GtRNAdb2.tar.gz
wget https://cqsweb.app.vumc.org/download1/annotateGenome/TIGER/SILVA_128.tar.gz
tar -xzvf SILVA_128.tar.gz
wget https://cqsweb.app.vumc.org/download1/annotateGenome/TIGER/group1.tar.gz
tar -xzvf group1.tar.gz
wget https://cqsweb.app.vumc.org/download1/annotateGenome/TIGER/group2.tar.gz
tar -xzvf group2.tar.gz
wget https://cqsweb.app.vumc.org/download1/annotateGenome/TIGER/group4.tar.gz
tar -xzvf group4.tar.gz
wget https://cqsweb.app.vumc.org/download1/annotateGenome/TIGER/rn5.tar.gz
tar -xzvf rn5.tar.gz
rm *.tar.gz

cqstools smallrna_database -f ~/program/cqsperl/database/smallrna/hg19_miRBase22_GtRNAdb2_gencode19_ncbi.bed.param
bowtie-build hg19_miRBase22_GtRNAdb2_gencode19_ncbi.fasta hg19_miRBase22_GtRNAdb2_gencode19_ncbi

cqstools smallrna_database -f ~/program/cqsperl/database/smallrna/hg38_miRBase22_GtRNAdb2_gencode33_ncbi.bed.param
bowtie-build hg38_miRBase22_GtRNAdb2_gencode33_ncbi.fasta hg38_miRBase22_GtRNAdb2_gencode33_ncbi

cqstools smallrna_database -f ~/program/cqsperl/database/smallrna/mm10_miRBase22_GtRNAdb2_gencode24_ncbi.bed.param
bowtie-build mm10_miRBase22_GtRNAdb2_gencode24_ncbi.fasta mm10_miRBase22_GtRNAdb2_gencode24_ncbi

cqstools smallrna_database -f ~/program/cqsperl/database/smallrna/rn6_miRBase22_GtRNAdb2_ensembl99_ncbi.bed.param
bowtie-build rn6_miRBase22_GtRNAdb2_ensembl99_ncbi.fasta rn6_miRBase22_GtRNAdb2_ensembl99_ncbi
