cd /scratch/cqs_share/references/annovar/humandb

for hg in hg19 hg38
do
  for db in refGene avsnp150 1000g2015aug gnomad211_genome clinvar_20190305 exac03 esp6500siv2 gwasCatalog
  do
    annotate_variation.pl -downdb -webfrom annovar -buildver $hg $db .
  done
done

cd /scratch/cqs_share/references/annovar/mousedb

annotate_variation.pl -downdb -webfrom annovar -buildver mm10 refGene .
annotate_variation.pl --buildver mm10 --downdb seq ./mm10_seq
retrieve_seq_from_fasta.pl ./mm10_refGene.txt -seqdir ./mm10_seq -format refGene -outfile ./mm10_refGeneMrna.fa
rm -rf mm10_seq
