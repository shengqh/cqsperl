cd /data/cqs/references/ucsc

wget -qO- http://hgdownload.cse.ucsc.edu/goldenpath/hg38/database/cpgIslandExt.txt.gz   | gunzip -c   | awk 'BEGIN{ OFS="\t"; }{ print $2, $3, $4, $5 }'   > hg38_cpg_islands.bed

wget -qO- http://hgdownload.cse.ucsc.edu/goldenpath/mm10/database/cpgIslandExt.txt.gz   | gunzip -c   | awk 'BEGIN{ OFS="\t"; }{ print $2, $3, $4, $5 }'   > mm10_cpg_islands.bed

wget -qO- http://hgdownload.cse.ucsc.edu/goldenpath/mm39/database/cpgIslandExt.txt.gz   | gunzip -c   | awk 'BEGIN{ OFS="\t"; }{ print $2, $3, $4, $5 }'   > mm39_cpg_islands.bed
