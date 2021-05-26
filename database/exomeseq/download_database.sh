##download broad hg38

mkdir -p /data/cqs/reference/broad/hg38
cd /data/cqs/reference/broad/hg38
gsutil -m cp -r gs://gcp-public-data--broad-references/hg38/v0 .

mkdir -p /data/cqs/reference/broad/hg19
cd /data/cqs/reference/broad/hg19
gsutil -m cp -r gs://gcp-public-data--broad-references/hg19/v0 .

##download capture bed

mkdir /data/cqs/references/exomeseq

mkdir /data/cqs/references/exomeseq/IDT
cd /data/cqs/references/exomeseq/IDT
wget http://sfvideo.blob.core.windows.net/sitefinity/docs/default-source/supplementary-product-info/xgen-exome-research-panel-targetsae255a1532796e2eaa53ff00001c1b3c.bed
bedtools slop -i xgen-exome-research-panel-targetsae255a1532796e2eaa53ff00001c1b3c.bed -g ~/program/cqsperl/database/exomeseq/hg19.genome -b 50 | sed 's/^chr//g' > Exome-IDT-xGen-hg19-v1-slop50-nochr.bed

mkdir /data/cqs/references/exomeseq/Twist
cd /data/cqs/references/exomeseq/Twist
wget https://www.twistbioscience.com/sites/default/files/resources/2019-06/Twist_Exome_Target_hg19.bed
bedtools slop -i Twist_Exome_Target_hg19.bed -g /data/cqs/softwares/cqsperl/database/exomeseq/hg19.genome -b 50 | sed 's/^chr//g' | grep -v "Un_gl000228" > Twist_Exome_Target_hg19-slop50-nochr.bed

singularity exec -c -B /gpfs52/data:/data  -e /data/cqs/softwares/singularity/cqs-gatk4.simg gatk BedToIntervalList -I /data/cqs/references/exomeseq/Twist/Twist_Exome_Target_hg19-slop50-nochr.bed -O /data/cqs/references/exomeseq/Twist/Twist_Exome_Target_hg19-slop50-nochr.bed.interval_list --SD /data/cqs/references/broad/hg19/v0/Homo_sapiens_assembly19.dict

#cut -f 2,3 /data/cqs/softwares/cqsperl/database/exomeseq/Homo_sapiens_assembly38.dict | sed "s/SN://g" |sed "s/LN://g" | grep -v "VN:" | grep -v "_" | grep -v "HLA" | grep -v "chrEBV" > /data/cqs/softwares/cqsperl/database/exomeseq/hg38.genome
wget https://www.twistbioscience.com/sites/default/files/resources/2018-09/Twist_Exome_Target_hg38.bed
bedtools slop -i Twist_Exome_Target_hg38.bed -g /data/cqs/softwares/cqsperl/database/exomeseq/hg38.genome -b 50 > Twist_Exome_Target_hg38.slop50.bed

singularity exec -c -B /gpfs52/data:/data  -e /data/cqs/softwares/singularity/cqs-gatk4.simg gatk BedToIntervalList -I /data/cqs/references/exomeseq/Twist/Twist_Exome_Target_hg38.slop50.bed -O /data/cqs/references/exomeseq/Twist/Twist_Exome_Target_hg38.slop50.bed.interval_list --SD /data/cqs/references/broad/hg38/v0/Homo_sapiens_assembly38.dict

##download dbsnp for mm10

mkdir /data/cqs/references/dbsnp
cd /data/cqs/references/dbsnp
wget https://ftp.ncbi.nih.gov/snp/pre_build152/organisms/archive/mouse_10090/VCF/00-All.vcf.gz 
zcat 00-All.vcf.gz | awk '{if($0 !~ /^#/) print "chr"$0; else print $0}' | gzip > mouse_10090_b150_GRCm38.p4.vcf.gz
tabix -p vcf mouse_10090_b150_GRCm38.p4.vcf.gz
rm 00-All.vcf.gz

