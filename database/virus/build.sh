cd /workspace/shengq2/references/virus

date_string=`date +%Y%m%d`

spcount dl_taxonomy -o ${date_string}.taxonomy.txt

spcount dl_assembly_summary -d refseq -o ${date_string}_refseq_assembly_summary.txt

spcount dl_assembly_summary -d genbank -o ${date_string}_genbank_assembly_summary.txt

spcount dl_genome -i 10239 -t ${date_string}.taxonomy.txt -n 50000 -a ${date_string}_refseq_assembly_summary.txt -p ${date_string}_refseq_virus_all -o .

# #build 10x reference
# cd /data/cqs/references/gencode/GRCh38.p13.virus

# cat ../GRCh38.p13/GRCh38.primary_assembly.genome.fa /data/cqs/references/virus/fasta/${date_string}_refseq_virus_all.fa > GRCh38.p13.${date_string}_refseq_virus.fa

# #https://github.com/alexdobin/STAR/issues/835
# #It's OK to have only human annotations.
# ln -s ../GRCh38.p13/gencode.v43.annotation.gtf gencode.v43.annotation.gtf

# # grep -v "^#" /workspace/shengq2/references/spcount/fasta/${date_string}_refseq_virus_all.gtf > virus.gtf
# # cat ../GRCh38.p13/gencode.v43.annotation.gtf virus.gtf > GRCh38.p13.${date_string}_refseq_virus.gtf
# # rm virus.gtf

# #cellranger mkgtf didn't change anything, so ignored.
# #cellranger mkgtf GRCh38.p13.${date_string}_refseq_virus.gtf GRCh38.p13.${date_string}_refseq_virus.cellranger.gtf

# cellranger mkref --genome hg38_${date_string}_refseq_virus --fasta GRCh38.p13.${date_string}_refseq_virus.fa --genes gencode.v43.annotation.gtf
