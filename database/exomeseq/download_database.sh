##download broad hg38

mkdir -p /data/cqs/reference/broad/hg38
cd /data/cqs/reference/broad/hg38
gsutil -m cp -r gs://gcp-public-data--broad-references/hg38/v0 .

mkdir -p /data/cqs/reference/broad/hg19
cd /data/cqs/reference/broad/hg19
gsutil -m cp -r gs://gcp-public-data--broad-references/hg19/v0 .


##download ucsc mm10
mkdir -p /data/cqs/references/ucsc/mm10_unsorted
mkdir -p /data/cqs/references/ucsc/mm10
cd /data/cqs/references/ucsc/mm10_unsorted
wget https://hgdownload.soe.ucsc.edu/goldenPath/mm10/bigZips/mm10.fa.gz
gunzip mm10.fa
cd /data/cqs/references/ucsc/mm10
perl /home/shengq2/program/cqsperl/database/exomeseq/reorder_fasta.pl
buildindex.pl -f mm10.fa


##download capture bed

mkdir /data/cqs/references/exomeseq

mkdir /data/cqs/references/exomeseq/IDT
cd /data/cqs/references/exomeseq/IDT
wget http://sfvideo.blob.core.windows.net/sitefinity/docs/default-source/supplementary-product-info/xgen-exome-research-panel-targetsae255a1532796e2eaa53ff00001c1b3c.bed
bedtools slop -i xgen-exome-research-panel-targetsae255a1532796e2eaa53ff00001c1b3c.bed -g ~/program/cqsperl/database/exomeseq/hg19.genome -b 50 | sed 's/^chr//g' > Exome-IDT-xGen-hg19-v1-slop50-nochr.bed

wget https://sfvideo.blob.core.windows.net/sitefinity/docs/default-source/supplementary-product-info/xgen-exome-research-panel-v2-targets-hg38.bed
bedtools slop -i xgen-exome-research-panel-v2-targets-hg38.bed -g /data/cqs/references/broad/hg38/v0/Homo_sapiens_assembly38.fasta.fai -b 50 > xgen-exome-research-panel-v2-targets-hg38.slop50.bed
singularity exec -c -B /gpfs52/data:/data  -e /data/cqs/softwares/singularity/cqs-gatk4.simg gatk BedToIntervalList -I /data/cqs/references/exomeseq/IDT/xgen-exome-research-panel-v2-targets-hg38.slop50.bed -O /data/cqs/references/exomeseq/IDT/xgen-exome-research-panel-v2-targets-hg38.slop50.bed.interval_list --SD /data/cqs/references/broad/hg38/v0/Homo_sapiens_assembly38.dict

wget https://sfvideo.blob.core.windows.net/sitefinity/docs/default-source/supplementary-product-info/xgen-exome-research-panel-v2-probes-hg3862a5791532796e2eaa53ff00001c1b3c.bed
bedtools slop -i xgen-exome-research-panel-v2-probes-hg3862a5791532796e2eaa53ff00001c1b3c.bed -g /data/cqs/softwares/cqsperl/database/exomeseq/hg38.genome -b 50 > xgen-exome-research-panel-v2-probes-hg3862a5791532796e2eaa53ff00001c1b3c.slop50.bed
singularity exec -c -B /gpfs52/data:/data  -e /data/cqs/softwares/singularity/cqs-gatk4.simg gatk BedToIntervalList -I /data/cqs/references/exomeseq/IDT/xgen-exome-research-panel-v2-probes-hg3862a5791532796e2eaa53ff00001c1b3c.slop50.bed -O /data/cqs/references/exomeseq/IDT/xgen-exome-research-panel-v2-probes-hg3862a5791532796e2eaa53ff00001c1b3c.slop50.bed.interval_list --SD /data/cqs/references/broad/hg38/v0/Homo_sapiens_assembly38.dict

wget https://raw.githubusercontent.com/AstraZeneca-NGS/reference_data/master/hg38/bed/Exome-IDT_V1.bed
mv Exome-IDT_V1.bed Exome-IDT_V1.hg38.bed
bedtools slop -i Exome-IDT_V1.hg38.bed -g /data/cqs/references/broad/hg38/v0/Homo_sapiens_assembly38.fasta.fai -b 50 > Exome-IDT_V1.hg38.slop50.bed
singularity exec -c -B /gpfs52/data:/data  -e /data/cqs/softwares/singularity/cqs-gatk4.simg gatk BedToIntervalList -I /data/cqs/references/exomeseq/IDT/Exome-IDT_V1.hg38.slop50.bed -O /data/cqs/references/exomeseq/IDT/Exome-IDT_V1.hg38.slop50.bed.interval_list --SD /data/cqs/references/broad/hg38/v0/Homo_sapiens_assembly38.dict


mkdir /data/cqs/references/exomeseq/Twist
cd /data/cqs/references/exomeseq/Twist
wget https://www.twistbioscience.com/sites/default/files/resources/2019-06/Twist_Exome_Target_hg19.bed
bedtools slop -i Twist_Exome_Target_hg19.bed -g /data/cqs/softwares/cqsperl/database/exomeseq/hg19.genome -b 50 | sed 's/^chr//g' | grep -v "Un_gl000228" > Twist_Exome_Target_hg19-slop50-nochr.bed

singularity exec -B /gpfs52/data:/data  -e /data/cqs/softwares/singularity/cqs-gatk4.simg gatk BedToIntervalList -I /data/cqs/references/exomeseq/Twist/Twist_Exome_Target_hg19-slop50-nochr.bed -O /data/cqs/references/exomeseq/Twist/Twist_Exome_Target_hg19-slop50-nochr.bed.interval_list --SD /data/cqs/references/broad/hg19/v0/Homo_sapiens_assembly19.dict

#cut -f 2,3 /data/cqs/softwares/cqsperl/database/exomeseq/Homo_sapiens_assembly38.dict | sed "s/SN://g" |sed "s/LN://g" | grep -v "VN:" | grep -v "_" | grep -v "HLA" | grep -v "chrEBV" > /data/cqs/softwares/cqsperl/database/exomeseq/hg38.genome
wget https://www.twistbioscience.com/sites/default/files/resources/2018-09/Twist_Exome_Target_hg38.bed
bedtools slop -i Twist_Exome_Target_hg38.bed -g /data/cqs/softwares/cqsperl/database/exomeseq/hg38.genome -b 50 > Twist_Exome_Target_hg38.slop50.bed

singularity exec -c -B /gpfs52/data:/data  -e /data/cqs/softwares/singularity/cqs-gatk4.simg gatk BedToIntervalList -I /data/cqs/references/exomeseq/Twist/Twist_Exome_Target_hg38.slop50.bed -O /data/cqs/references/exomeseq/Twist/Twist_Exome_Target_hg38.slop50.bed.interval_list --SD /data/cqs/references/broad/hg38/v0/Homo_sapiens_assembly38.dict

#cut -f 2,3 /data/cqs/references/ucsc/mm10/mm10.dict | sed "s/SN://g" |sed "s/LN://g" | grep -v "VN:" > /data/cqs/softwares/cqsperl/database/exomeseq/mm10.genome
wget https://www.twistbioscience.com/sites/default/files/resources/2020-04/Twist_Mouse_Exome_Target_Rev1_7APR20.bed

bedtools slop -i Twist_Mouse_Exome_Target_Rev1_7APR20.bed -g /data/cqs/softwares/cqsperl/database/exomeseq/mm10.genome -b 50 > Twist_Mouse_Exome_Target_Rev1_7APR20.ucsc_mm10.slop50.bed
singularity exec -c -B /gpfs52/data:/data  -e /data/cqs/softwares/singularity/cqs-gatk4.simg gatk BedToIntervalList -I /data/cqs/references/exomeseq/Twist/Twist_Mouse_Exome_Target_Rev1_7APR20.ucsc_mm10.slop50.bed -O /data/cqs/references/exomeseq/Twist/Twist_Mouse_Exome_Target_Rev1_7APR20.ucsc_mm10.slop50.bed.interval_list --SD /data/cqs/references/ucsc/mm10/mm10.dict

##download dbsnp for mm10

mkdir /data/cqs/references/dbsnp
cd /data/cqs/references/dbsnp
wget https://ftp.ncbi.nih.gov/snp/pre_build152/organisms/archive/mouse_10090/VCF/00-All.vcf.gz 
zcat 00-All.vcf.gz | awk '{if($0 !~ /^#/) print "chr"$0; else print $0}' | gzip > mouse_10090_b150_GRCm38.p4.vcf.gz
tabix -p vcf mouse_10090_b150_GRCm38.p4.vcf.gz
rm 00-All.vcf.gz

##download vep_data

singularity exec -B /data -e /data/cqs/softwares/singularity/ensembl-vep.104.3.simg perl /opt/vep/src/ensembl-vep/INSTALL.pl -a cfp -s homo_sapiens -y GRCh38 -g all -c /data/cqs/references/vep_data

##run vep
#singularity exec -e /data/cqs/softwares/singularity/ensembl-vep.104.3.simg vep --offline --vcf --dir_cache /data/cqs/references/vep_data --species homo_sapiens --assembly GRCh38 -o output.vcf -i input.vcf.gz 

## download encode data
cd /data/cqs/softwares/encode/atac-seq-pipeline/scripts/
mkdir -p /data/cqs/references/encode-pipeline-genome-data/hg19
./download_genome_data.sh hg19 /data/cqs/references/encode-pipeline-genome-data/hg19
mkdir -p /data/cqs/references/encode-pipeline-genome-data/hg38
./download_genome_data.sh hg38 /data/cqs/references/encode-pipeline-genome-data/hg38

##Roche exomeseq
cd /data/cqs/references/exomeseq/Roche
bedtools slop -i HyperExome_hg38_capture_targets.bed -g /data/cqs/references/broad/hg38/v0/Homo_sapiens_assembly38.fasta.fai -b 50 > HyperExome_hg38_capture_targets.slop50.bed
singularity exec -c -B /data  -e /data/cqs/softwares/singularity/cqs-gatk4.simg gatk BedToIntervalList -I /data/cqs/references/exomeseq/Roche/HyperExome_hg38_capture_targets.slop50.bed -O /data/cqs/references/exomeseq/Roche/HyperExome_hg38_capture_targets.slop50.bed.interval_list --SD /data/cqs/references/broad/hg38/v0/Homo_sapiens_assembly38.dict
bedtools slop -i HyperExome_hg19_capture_targets.bed -g  /data/cqs/softwares/cqsperl/database/exomeseq/hg19.genome -b 50 | sed 's/^chr//g' > HyperExome_hg19_capture_targets.slop50.nochr.bed
singularity exec -c -B /data  -e /data/cqs/softwares/singularity/cqs-gatk4.simg gatk BedToIntervalList -I /data/cqs/references/exomeseq/Roche/HyperExome_hg19_capture_targets.slop50.nochr.bed -O /data/cqs/references/exomeseq/Roche/HyperExome_hg19_capture_targets.slop50.nochr.bed.interval_list --SD /data/cqs/references/broad/hg19/v0/Homo_sapiens_assembly19.dict


# Twist 2.0
cd /data/cqs/references/exomeseq/Twist
wget https://www.twistbioscience.com/sites/default/files/resources/2022-12/hg38_exome_v2.0.2_targets_sorted_validated.re_annotated.bed
bedtools slop -i hg38_exome_v2.0.2_targets_sorted_validated.re_annotated.bed -g /data/cqs/softwares/cqsperl/database/exomeseq/hg38.genome -b 50 > hg38_exome_v2.0.2_targets_sorted_validated.re_annotated.padding50.bed
singularity exec -c -B /panfs,/data  -e /data/cqs/softwares/singularity/cqs-gatk4.simg gatk BedToIntervalList -I /data/cqs/references/exomeseq/Twist/hg38_exome_v2.0.2_targets_sorted_validated.re_annotated.padding50.bed -O /data/cqs/references/exomeseq/Twist/hg38_exome_v2.0.2_targets_sorted_validated.re_annotated.padding50.bed.interval_list --SD /data/cqs/references/broad/hg38/v0/Homo_sapiens_assembly38.dict
