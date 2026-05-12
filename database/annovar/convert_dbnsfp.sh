cd /data/cqs/references/annovar/dbnsfp

# Download the latest dbNSFP v5.3.1a through website (it might change)
wget https://dist.genos.us/academic/e55b09/dbNSFP5.3.1a_grch38.gz

python /nobackup/h_cqs/shengq2/program/cqsperl/database/annovar/convert.dbnsfp.py dbNSFP5.3.1a_grch38.gz hg38_dbnsfp531a.raw.txt
perl index_annovar.pl hg38_dbnsfp531a.raw.txt -out hg38_dbnsfp531a.txt

rm -f hg38_dbnsfp531a.raw.txt index_annovar.pl

mv hg38_dbnsfp531a.txt* ../humandb/

# test

zcat /nobackup/h_cqs/shengq2/biovu/agd250k/eligible_v6_202504/primary-pass-msvcf-sites/agd250k_chr1.pass.vcf.gz | head -n 100000 | cut -f1-9 > agd250k_chr1.avinput.vcf

/data/cqs/softwares/annovar/convert2annovar.pl -format vcf4old agd250k_chr1.avinput.vcf | cut -f1-7 | awk '{gsub(",\\*", "", $0); print}'> agd250k_chr1.avinput

/data/cqs/softwares/annovar/table_annovar.pl agd250k_chr1.avinput /data/cqs/references/annovar/humandb -buildver hg38 -protocol dbnsfp47a -operation f --remove --outfile agd250k_chr1.dbnsfp47a.annovar
/data/cqs/softwares/annovar/table_annovar.pl agd250k_chr1.avinput /data/cqs/references/annovar/humandb -buildver hg38 -protocol dbnsfp531a -operation f --remove --outfile agd250k_chr1.dbnsfp531a.annovar

grep 925987 agd250k_chr1.dbnsfp47a.annovar.hg38_multianno.txt agd250k_chr1.dbnsfp531a.annovar.hg38_multianno.txt
