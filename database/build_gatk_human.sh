cd /scratch/cqs_share/references/broad

aws2 s3 cp s3://broad-references/hg38/ ./ --recursive

cqstools gtf_buildmap -i gencode.v27.primary_assembly.annotation.gtf -o gencode.v27.primary_assembly.annotation.gtf.map
buildindex.pl -f Homo_sapiens_assembly38.fasta -b -w -B -s --sjdbGTFfile gencode.v27.primary_assembly.annotation.gtf --sjdbGTFfileVersion gencodev27 --thread 16

aws2 s3 cp s3://broad-references/hg19/ ./ --recursive

wget ftp://ftp.ensembl.org/pub/release-75/gtf/homo_sapiens/Homo_sapiens.GRCh37.75.gtf.gz
gunzip Homo_sapiens.GRCh37.75.gtf.gz
cqstools gtf_buildmap -i Homo_sapiens.GRCh37.75.gtf -o Homo_sapiens.GRCh37.75.gtf.map
buildindex.pl -f Homo_sapiens_assembly19.fasta -b -w -B -s --sjdbGTFfile Homo_sapiens.GRCh37.75.gtf --sjdbGTFfileVersion GRCh37v75 --thread 16
