if [[ ! -s /data/cqs/reference/encode/hg38/hic ]]; then
  mkdir -p /data/cqs/reference/encode/hg38/hic
fi

cd /data/cqs/reference/encode/hg38/hic

wget https://www.encodeproject.org/files/ENCFF643CGH/@@download/ENCFF643CGH.tar.gz

wget https://www.encodeproject.org/files/GRCh38_no_alt_analysis_set_GCA_000001405.15/@@download/GRCh38_no_alt_analysis_set_GCA_000001405.15.fasta.gz

wget https://www.encodeproject.org/files/GRCh38_EBV.chrom.sizes/@@download/GRCh38_EBV.chrom.sizes.tsv

wget https://www.encodeproject.org/files/ENCFF132WAM/@@download/ENCFF132WAM.txt.gz

wget https://www.encodeproject.org/files/ENCFF984SUZ/@@download/ENCFF984SUZ.txt.gz

if [[ ! -s /data/cqs/reference/encode/mm10/hic ]]; then
  mkdir -p /data/cqs/reference/encode/mm10/hic
fi

cd /data/cqs/reference/encode/mm10/hic

wget https://www.encodeproject.org/files/ENCFF018NEO/@@download/ENCFF018NEO.tar.gz

wget https://www.encodeproject.org/files/mm10_no_alt.chrom.sizes/@@download/mm10_no_alt.chrom.sizes.tsv

wget https://www.encodeproject.org/files/ENCFF930KBK/


