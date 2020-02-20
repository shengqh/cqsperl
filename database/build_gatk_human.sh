cd /scratch/cqs_share/references/broad

aws2 s3 cp s3://broad-references/hg38/ ./ --recursive

cqstools gtf_buildmap -i gencode.v27.primary_assembly.annotation.gtf -o gencode.v27.primary_assembly.annotation.gtf.map
buildindex.pl -f Homo_sapiens_assembly38.fasta -b -w -B -s --sjdbGTFfile gencode.v27.primary_assembly.annotation.gtf --sjdbGTFfileVersion gencodev27 --thread 16

aws2 s3 cp s3://broad-references/hg19/ ./ --recursive

wget ftp://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_19/gencode.v19.annotation.gtf.gz
gunzip gencode.v19.annotation.gtf.gz
mv gencode.v19.annotation.gtf.tmp
sed 's/^chr//; s/^M/MT/' gencode.v19.annotation.gtf.tmp > gencode.v19.annotation.gtf
rm gencode.v19.annotation.gtf.tmp
cqstools gtf_buildmap -i gencode.v19.annotation.gtf -o gencode.v19.annotation.gtf.map
buildindex.pl -f Homo_sapiens_assembly19.fasta -b -w -B -s --sjdbGTFfile gencode.v19.annotation.gtf --sjdbGTFfileVersion gencodeV19 --thread 16
