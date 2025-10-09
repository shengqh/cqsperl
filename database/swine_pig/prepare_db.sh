mkdir -p /data/cqs/references/swine_pig/ncbi/GCF_000003025.6
cd /data/cqs/references/swine_pig/ncbi/GCF_000003025.6

wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/003/025/GCF_000003025.6_Sscrofa11.1/GCF_000003025.6_Sscrofa11.1_genomic.fna.gz
gunzip GCF_000003025.6_Sscrofa11.1_genomic.fna.gz

#20251008
wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/003/025/GCF_000003025.6_Sscrofa11.1/GCF_000003025.6_Sscrofa11.1_genomic.gtf.gz
gunzip GCF_000003025.6_Sscrofa11.1_genomic.gtf.gz
mv GCF_000003025.6_Sscrofa11.1_genomic.gtf genomic.v106.gtf

gtf_buildmap.py -i genomic.v106.gtf -o genomic.v106.gtf.map -k gene

buildindex.pl -f GCF_000003025.6_Sscrofa11.1_genomic.fna -s --sjdbGTFfile genomic.v106.gtf --sjdbGTFfileVersion v106 --thread 32
