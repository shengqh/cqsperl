#the file Homo_sapiens_assembly38_masked.str is missing in dragen references
#it will cause dragen dragen functional equivalence pipeline failed if dragen_functional_equivalence_mode is selected.

mkdir -p /nobackup/h_cqs/shengq2/gcloud/broad/dragen

cd /nobackup/h_cqs/shengq2/gcloud/broad/dragen

gsutil -m cp gs://gcp-public-data--broad-references/hg38/v0/dragen_reference/Homo_sapiens_assembly38_masked.fasta .
gsutil cp gs://gcp-public-data--broad-references/hg38/v0/dragen_reference/Homo_sapiens_assembly38_masked.fasta.fai .
gsutil cp gs://gcp-public-data--broad-references/hg38/v0/dragen_reference/Homo_sapiens_assembly38_masked.dict .

gatk ComposeSTRTableFile --output Homo_sapiens_assembly38_masked.str --reference Homo_sapiens_assembly38_masked.fasta

gsutil cp Homo_sapiens_assembly38_masked.str gs://fc-5a8938eb-1299-4afc-957f-afb53ef602b9/broad/dragen/
