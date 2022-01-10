if [[ ! -e /data/cqs/references/broad/hg38/v0/hapmap.chromosomes ]]; then
  mkdir /data/cqs/references/broad/hg38/v0/hapmap.chromosomes
fi

cd /data/cqs/references/broad/hg38/v0/hapmap.chromosomes
if [[ ! -s hapmap_3.3.hg38.vcf.gz ]]; then
  ln -s ../hapmap_3.3.hg38.vcf.gz hapmap_3.3.hg38.vcf.gz
fi
if [[ ! -s hapmap_3.3.hg38.vcf.gz.tbi ]]; then
  ln -s ../hapmap_3.3.hg38.vcf.gz.tbi hapmap_3.3.hg38.vcf.gz.tbi
fi

chrs=( chr1 chr2 chr3 chr4 chr5 chr6 chr7 chr8 chr9 chr10 chr11 chr12 chr13 chr14 chr15 chr16 chr17 chr18 chr19 chr20 chr21 chr22 chrX )
for chr in "${chrs[@]}"
do
	echo "$chr"
  bcftools filter hapmap_3.3.hg38.vcf.gz -r $chr > hapmap_3.3.hg38.${chr}.vcf
  bgzip hapmap_3.3.hg38.${chr}.vcf
  tabix hapmap_3.3.hg38.${chr}.vcf.gz
done

