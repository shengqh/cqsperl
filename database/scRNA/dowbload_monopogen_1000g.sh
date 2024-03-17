mkdir -p /data/cqs/references/1000g
cd /data/cqs/references/1000g

wget -r -np -R "index.html*" -R "robots.txt*" -e robots=off --no-parent http://ftp.1000genomes.ebi.ac.uk/vol1/ftp/data_collections/1000G_2504_high_coverage/working/20201028_3202_phased/

#once download, run the following command to create symbolic link
#ln -s CCDG_14151_B01_GRM_WGS_2020-08-05_chrX.filtered.eagle2-phased.v2.vcf.gz CCDG_14151_B01_GRM_WGS_2020-08-05_chrX.filtered.shapeit2-duohmm-phased.vcf.gz
#ln -s CCDG_14151_B01_GRM_WGS_2020-08-05_chrX.filtered.eagle2-phased.v2.vcf.gz.tbi CCDG_14151_B01_GRM_WGS_2020-08-05_chrX.filtered.shapeit2-duohmm-phased.vcf.gz.tbi