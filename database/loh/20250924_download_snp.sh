mkdir -p /data/cqs/references/loh
cd /data/cqs/references/loh

wget -O hg38-00-common_all.vcf.gz ftp://ftp.ncbi.nlm.nih.gov/snp/organisms/human_9606/VCF/00-common_all.vcf.gz
wget -O hg38-00-common_all.vcf.gz.tbi ftp://ftp.ncbi.nlm.nih.gov/snp/organisms/human_9606/VCF/00-common_all.vcf.gz.tbi

# Now convert the chromosome names from "1" to "chr1"
zcat hg38-00-common_all.vcf.gz | sed 's/^/chr/' | sed 's/^chr#/#/' | bgzip > hg38-00-common_all.chr.vcf.gz
tabix -p vcf hg38-00-common_all.chr.vcf.gz