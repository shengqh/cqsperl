mkdir -p /data/cqs/references/broad/hg38/joint_genotyping/intervals
cd /data/cqs/references/broad/hg38/joint_genotyping/intervals

if [[ ! -s hg38.even.handcurated.20k.intervals ]]; then
  wget https://storage.googleapis.com/gcp-public-data--broad-references/hg38/v0/hg38.even.handcurated.20k.intervals
fi

for chr in chr1 chr2 chr3 chr4 chr5 chr6 chr7 chr8 chr9 chr10 chr11 chr12 chr13 chr14 chr15 chr16 chr17 chr18 chr19 chr20 chr21 chr22 chrX chrY; do
  echo $chr
  grep -w $chr hg38.even.handcurated.20k.intervals > hg38.even.handcurated.20k.$chr.intervals
done
