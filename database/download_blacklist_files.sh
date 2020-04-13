if [[ ! -d /scratch/cqs_share/references/blacklist_files ]]; then
  mkdir /scratch/cqs_share/references/blacklist_files
fi
cd /scratch/cqs_share/references/blacklist_files

wget https://github.com/Boyle-Lab/Blacklist/raw/master/lists/hg19-blacklist.v2.bed.gz
gunzip hg19-blacklist.v2.bed.gz

wget https://github.com/Boyle-Lab/Blacklist/raw/master/lists/hg38-blacklist.v2.bed.gz
gunzip hg38-blacklist.v2.bed.gz

wget https://github.com/Boyle-Lab/Blacklist/raw/master/lists/mm10-blacklist.v2.bed.gz
gunzip mm10-blacklist.v2.bed.gz
