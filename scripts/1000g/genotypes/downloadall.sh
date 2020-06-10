chrs=(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22)
rm dbsnp.vcf
for i in "${chrs[@]}"
    do
	wget ftp://ftp-trace.ncbi.nih.gov/1000genomes/ftp/release/20130502/ALL.chr${i}.phase3_shapeit2_mvncall_integrated_v5.20130502.genotypes.vcf.gz
	gunzip ALL.chr${i}.phase3_shapeit2_mvncall_integrated_v5.20130502.genotypes.vcf.gz
	cut -f1-8 ALL.chr${i}.phase3_shapeit2_mvncall_integrated_v5.20130502.genotypes.vcf | grep -v "#" >> g1000_20130502.vcf
	rm ALL.chr${i}.phase3_shapeit2_mvncall_integrated_v5.20130502.genotypes.vcf
    done
