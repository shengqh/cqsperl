
cd /data/cqs/references/dbsnp

if [[ ! -s dbSNP154.hg38.vcf ]]; then
## 05/09/2021: 2020-05-26 13:48 -- dbSNP154
wget https://ftp.ncbi.nih.gov/snp/archive/b154/VCF/GCF_000001405.25.gz ./
wget https://ftp.ncbi.nih.gov/snp/archive/b154/VCF/GCF_000001405.25.gz.tbi ./     
wget https://ftp.ncbi.nih.gov/snp/archive/b154/VCF/GCF_000001405.38.gz ./         
wget https://ftp.ncbi.nih.gov/snp/archive/b154/VCF/GCF_000001405.38.gz.tbi ./    
wget https://raw.githubusercontent.com/Shicheng-Guo/AnnotationDatabase/master/GCF_000001405.25_GRCh37.p13_assembly_report.txt ./
wget https://raw.githubusercontent.com/Shicheng-Guo/AnnotationDatabase/master/GCF_000001405.38_GRCh38.p12_assembly_report.txt ./
awk -v RS="(\r)?\n" 'BEGIN { FS="\t" } !/^#/ { if ($10 != "na") print $7,$10; else print $7,$5 }' GCF_000001405.25_GRCh37.p13_assembly_report.txt > dbSNP-to-UCSC-GRCh37.p13.map
awk -v RS="(\r)?\n" 'BEGIN { FS="\t" } !/^#/ { if ($10 != "na") print $7,$10; else print $7,$5 }' GCF_000001405.38_GRCh38.p12_assembly_report.txt > dbSNP-to-UCSC-GRCh38.p12.map
#sed -i '{s/chrX/23/g}' dbSNP-to-UCSC-GRCh37.p13.map
#sed -i '{s/chrY/24/g}' dbSNP-to-UCSC-GRCh37.p13.map
#sed -i '{s/chrM/25/g}' dbSNP-to-UCSC-GRCh37.p13.map
#sed -i '{s/chr//g}' dbSNP-to-UCSC-GRCh37.p13.map
bcftools annotate --threads 48 --rename-chrs dbSNP-to-UCSC-GRCh37.p13.map GCF_000001405.25.gz -o dbSNP154.hg19.vcf
bcftools annotate --threads 48 --rename-chrs dbSNP-to-UCSC-GRCh38.p12.map GCF_000001405.38.gz -o dbSNP154.hg38.vcf
fi

if [[ ! -s dbSNP154.hg38.vcf.gz.tbi ]]; then
  bgzip dbSNP154.hg19.vcf
  tabix dbSNP154.hg19.vcf.gz
  bgzip dbSNP154.hg38.vcf
  tabix dbSNP154.hg38.vcf.gz
fi

if [[ -s dbSNP154.hg38.vcf.gz.tbi ]]; then
  rm GCF_000001405.25.gz GCF_000001405.25.gz.tbi GCF_000001405.38.gz GCF_000001405.38.gz.tbi GCF_000001405.25_GRCh37.p13_assembly_report.txt GCF_000001405.38_GRCh38.p12_assembly_report.txt dbSNP-to-UCSC-GRCh37.p13.map dbSNP-to-UCSC-GRCh38.p12.map
fi
