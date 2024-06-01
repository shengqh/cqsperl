cd /data/cqs/softwares/
git clone https://github.com/stephenfloor/extract-transcript-regions.git

cd /data/cqs/references/gencode/GRCm38.p6
python /data/cqs/softwares/extract-transcript-regions/extract_transcript_regions.py -i gencode.vM25.annotation.gtf -o gencode.vM25.annotation --gtf