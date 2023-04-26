mirbase_ver="22.1"
mkdir -p /data/cqs/references/mirbase/v${mirbase_ver}
cd /data/cqs/references/mirbase/v${mirbase_ver}
if [[ ! -s mature.fa ]]; then
  wget https://www.mirbase.org/ftp/CURRENT/mature.fa.gz
  gunzip mature.fa.gz

  python3 /home/shengq2/program/cqsperl/database/smallrna/v202304/prepare_mirna.py -i mature.fa -o mature.dna.fa
  buildindex.pl -f mature.dna.fa -b

  wget https://www.mirbase.org/ftp/CURRENT/genomes/hsa.gff3
  wget https://www.mirbase.org/ftp/CURRENT/genomes/mmu.gff3
  wget https://www.mirbase.org/ftp/CURRENT/genomes/rno.gff3
fi

trna_ver="20"
mkdir -p /data/cqs/references/GtRNAdb/v${trna_ver}
cd /data/cqs/references/GtRNAdb/v${trna_ver}

if [[ ! -s hg38-mature-tRNAs.fa ]]; then
  wget http://gtrnadb.ucsc.edu/genomes/eukaryota/Hsapi38/hg38-mature-tRNAs.fa
  python3 /home/shengq2/program/cqsperl/database/smallrna/v202304/prepare_trna.py -i hg38-mature-tRNAs.fa -o hg38-mature-tRNAs.dna.fa -b hg38-mature-tRNAs.dna.bed
fi

if [[ ! -s mm10-mature-tRNAs.fa ]]; then
  wget http://gtrnadb.ucsc.edu/genomes/eukaryota/Mmusc10/mm10-mature-tRNAs.fa
  python3 /home/shengq2/program/cqsperl/database/smallrna/v202304/prepare_trna.py -i mm10-mature-tRNAs.fa -o mm10-mature-tRNAs.dna.fa -b mm10-mature-tRNAs.dna.bed
fi

python3 /home/shengq2/program/cqsperl/database/smallrna/v202304/download_trna.py --tmp_dir /workspace/shengq2/smallrna/GtRNAdb.v20 --out_dir /data/cqs/references/GtRNAdb/v${trna_ver}

hg38_ver="43"
mkdir -p /data/cqs/references/gencode/GRCh38.p13
cd /data/cqs/references/gencode/GRCh38.p13
if [[ ! -s GRCh38.primary_assembly.genome.fa ]]; then
  wget ftp://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_${hg38_ver}/GRCh38.primary_assembly.genome.fa.gz
  gunzip GRCh38.primary_assembly.genome.fa.gz
fi

if [[ ! -s gencode.v${hg38_ver}.annotation.gtf ]]; then
  wget ftp://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_${hg38_ver}/gencode.v${hg38_ver}.annotation.gtf.gz
  gunzip gencode.v${hg38_ver}.annotation.gtf.gz
fi

mm10_ver="M25" #vm25 is the latest version of mm10
mkdir -p /data/cqs/references/gencode/GRCm38.p6
cd /data/cqs/references/gencode/GRCm38.p6
if [[ ! -s GRCm38.primary_assembly.genome.fa ]]; then
  wget ftp://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_mouse/release_${mm10_ver}/GRCm38.primary_assembly.genome.fa.gz
  gunzip GRCm38.primary_assembly.genome.fa.gz
fi

if [[ ! -s gencode.v${mm10_ver}.annotation.gtf ]]; then
  wget ftp://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_mouse/release_${mm10_ver}/gencode.v${mm10_ver}.annotation.gtf.gz
  gunzip gencode.v${mm10_ver}.annotation.gtf.gz
fi

smallrna_ver="202304"
mkdir -p /data/cqs/references/smallrna/v${smallrna_ver}
cd /data/cqs/references/smallrna/v${smallrna_ver}


# wget https://cqsweb.app.vumc.org/download1/annotateGenome/TIGER/SILVA_128.tar.gz
# tar -xzvf SILVA_128.tar.gz

# cqstools smallrna_database -f ~/program/cqsperl/database/smallrna/hg19_miRBase22_GtRNAdb2_gencode19_ncbi.bed.param
# bowtie-build hg19_miRBase22_GtRNAdb2_gencode19_ncbi.fasta hg19_miRBase22_GtRNAdb2_gencode19_ncbi

# cqstools smallrna_database -f ~/program/cqsperl/database/smallrna/hg38_miRBase22_GtRNAdb2_gencode33_ncbi.bed.param
# bowtie-build hg38_miRBase22_GtRNAdb2_gencode33_ncbi.fasta hg38_miRBase22_GtRNAdb2_gencode33_ncbi

# cqstools smallrna_database -f ~/program/cqsperl/database/smallrna/mm10_miRBase22_GtRNAdb2_gencode24_ncbi.bed.param
# bowtie-build mm10_miRBase22_GtRNAdb2_gencode24_ncbi.fasta mm10_miRBase22_GtRNAdb2_gencode24_ncbi

# cqstools smallrna_database -f ~/program/cqsperl/database/smallrna/rn6_miRBase22_GtRNAdb2_ensembl99_ncbi.bed.param
# bowtie-build rn6_miRBase22_GtRNAdb2_ensembl99_ncbi.fasta rn6_miRBase22_GtRNAdb2_ensembl99_ncbi
