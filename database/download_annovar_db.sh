cd /scratch/cqs_share/references/annovar/humandb

for hg in hg19 hg38
do
  for db in refGene avsnp150 1000g2015aug gnomad211_genome clinvar_20190305 exac03 esp6500siv2 gwasCatalog
  do
    annotate_variation.pl -downdb -webfrom annovar -buildver $hg $db .
  done
done
