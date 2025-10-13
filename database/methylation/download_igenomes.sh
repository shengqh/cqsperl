
mkdir -p /data/cqs/references/igenomes/Mus_musculus/UCSC/mm10/Sequence/BismarkIndex
cd /data/cqs/references/igenomes/Mus_musculus/UCSC/mm10/Sequence/BismarkIndex

awsvumc s3 cp s3://ngi-igenomes/igenomes/Mus_musculus/UCSC/mm10/Sequence/BismarkIndex/ . --recursive

mkdir -p /data/cqs/references/igenomes/Homo_sapiens/UCSC/hg38/Sequence/BismarkIndex
cd /data/cqs/references/igenomes/Homo_sapiens/UCSC/hg38/Sequence/BismarkIndex

awsvumc s3 cp s3://ngi-igenomes/igenomes/Homo_sapiens/UCSC/hg38/Sequence/BismarkIndex/ . --recursive
