cd /data/cqs/references/broad/hg38/v0
gsutil -m cp -r gs://gcp-public-data--broad-references/hg38/v0/scattered_calling_intervals/ .
ls /data/cqs/references/broad/hg38/v0/scattered_calling_intervals/*/* > hg38_wgs_scattered_calling_intervals.txt

cd /data/cqs/references/broad/hg19/v0
gsutil -m cp -r gs://gcp-public-data--broad-references/hg19/v0/scattered_calling_intervals/ .
ls /data/cqs/references/broad/hg19/v0/scattered_calling_intervals/*/* > hg19_wgs_scattered_calling_intervals.txt
