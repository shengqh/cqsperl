#zcat mgp.v5.indels.vcf.gz | head -1000 | grep "^#" | cut -f 1-8 \
#| grep -v "#contig" | grep -v "#source" \
#> mgp.v5.indels.pass.chr.vcf
# keep only passing and adjust chromosome name
#zcat mgp.v5.indels.vcf.gz | grep -v "^#" | cut -f 1-8 \
#| grep -w "PASS" | sed 's/^\([0-9MXY]\)/chr\1/' \
#>> mgp.v5.indels.pass.chr.vcf


/scratch/cqs_share/softwares/gatk-4.1.8.1/gatk SortVcf \
-SD /scratch/cqs_share/references/gencode/GRCm38.p6/GRCm38.primary_assembly.genome.dict \
-I mgp.v5.indels.pass.chr.vcf \
-O mgp.v5.indels.vcf
rm -fv mgp.v5.indels.vcf.idx

bgzip mgp.v5.indels.vcf
tabix mgp.v5.indels.vcf.gz
