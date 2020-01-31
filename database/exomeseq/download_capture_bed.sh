mkdir /scratch/cqs_share/references/exomeseq

mkdir /scratch/cqs_share/references/exomeseq/IDT
cd /scratch/cqs_share/references/exomeseq/IDT
wget http://sfvideo.blob.core.windows.net/sitefinity/docs/default-source/supplementary-product-info/xgen-exome-research-panel-targetsae255a1532796e2eaa53ff00001c1b3c.bed
bedtools slop -i xgen-exome-research-panel-targetsae255a1532796e2eaa53ff00001c1b3c.bed -g ~/program/cqsperl/database/exomeseq/hg19.genome -b 50 | sed 's/^chr//g' > Exome-IDT-xGen-hg19-v1-slop50-nochr.bed

mkdir /scratch/cqs_share/references/exomeseq/Twist
cd /scratch/cqs_share/references/exomeseq/Twist
cut -f 2,3 ~/program/cqsperl/database/exomeseq/Homo_sapiens_assembly38.dict | sed "s/SN://g" |sed "s/LN://g" | grep -v "VN:" | grep -v "_" | grep -v "HLA" | grep -v "chrEBV" > hg38.genome
wget https://www.twistbioscience.com/sites/default/files/resources/2019-06/Twist_Exome_Target_hg38.bed
bedtools slop -i Twist_Exome_Target_hg38.bed -g hg38.genome -b 50 > Twist_Exome_Target_hg38.slop50.bed

