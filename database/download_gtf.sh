cd /scratch/cqs_share/references/gencode/GRCh38.p13
wget ftp://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_36/gencode.v36.annotation.gtf.gz
gunzip gencode.v36.annotation.gtf.gz
cqstools gtf_buildmap -i gencode.v36.annotation.gtf -o gencode.v36.annotation.gtf.map
python /scratch/cqs_share/softwares/ngsperl/lib/Chipseq/tssGeneBodyBed.py -i gencode.v36.annotation.gtf -o gencode.v36.annotation
