cd /data/cqs/softwares/annovar
if [ ! -f prepare_annovar_user.pl ]; then
  wget http://www.openbioinformatics.org/annovar/download/prepare_annovar_user.pl
  chmod +x prepare_annovar_user.pl
fi

if [ ! -f index_annovar.pl ]; then
  wget https://github.com/WGLab/doc-ANNOVAR/files/6670482/index_annovar.txt 
  mv index_annovar.txt index_annovar.pl
  chmod +x index_annovar.pl
fi

cd /data/cqs/references/clinvar

wget ftp://ftp.ncbi.nlm.nih.gov/pub/clinvar/vcf_GRCh38/clinvar_20260510.vcf.gz
gunzip clinvar_20260510.vcf.gz
prepare_annovar_user.pl -dbtype clinvar2 clinvar_20260510.vcf -out hg38_clinvar_20260510_raw.txt

# We only need the CLNALLELEID     CLNDN   CLNDISDB        CLNREVSTAT      CLNSIG
cut -f 1-10 hg38_clinvar_20260510_raw.txt > hg38_clinvar_20260510_raw_cut.txt
# must use comment file, otherwise the final result will be missing the header line
index_annovar.pl hg38_clinvar_20260510_raw_cut.txt -out hg38_clinvar_20260510.txt -comment /nobackup/h_cqs/shengq2/program/cqsperl/database/annovar/comment_clinvar_20260510.txt

mv hg38_clinvar_20260510.txt* ../annovar/humandb/
rm -f clinvar_20260510.vcf* prepare_annovar_user.pl index_annovar.pl hg38_clinvar_20260510_raw.txt

# test

zcat /nobackup/h_cqs/shengq2/biovu/agd250k/eligible_v6_202504/primary-pass-msvcf-sites/agd250k_chr1.pass.vcf.gz | head -n 100000 | cut -f1-9 > agd250k_chr1.avinput.vcf

/data/cqs/softwares/annovar/convert2annovar.pl -format vcf4old agd250k_chr1.avinput.vcf | cut -f1-7 | awk '{gsub(",\\*", "", $0); print}'> agd250k_chr1.avinput

/data/cqs/softwares/annovar/table_annovar.pl agd250k_chr1.avinput /data/cqs/references/annovar/humandb -buildver hg38 -protocol clinvar_20251109 -operation f --remove --outfile agd250k_chr1.clinvar_20251109.annovar
/data/cqs/softwares/annovar/table_annovar.pl agd250k_chr1.avinput /data/cqs/references/annovar/humandb -buildver hg38 -protocol clinvar_20260510 -operation f --remove --outfile agd250k_chr1.clinvar_20260510.annovar

#grep 925987 agd250k_chr1.dbnsfp47a.annovar.hg38_multianno.txt agd250k_chr1.dbnsfp531a.annovar.hg38_multianno.txt
