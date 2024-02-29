mdkir -p /data/cqs/references/broad/hg38/v0/cnv
cd /data/cqs/references/broad/hg38/v0/cnv
gsutil -m cp gs://gatk-test-data/cnv/somatic/somatic-hg38_af-only-gnomad.hg38.AFgt0.02.interval_list .

mkdir -p /data/cqs/references/broad/hg19/v0/cnv
cd /data/cqs/references/broad/hg19/v0/cnv
gsutil -m cp gs://gatk-test-data/cnv/somatic/common_snps.interval_list .