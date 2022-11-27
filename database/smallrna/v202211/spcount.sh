cd /data/cqs/references/spcount.20221124

if [[ ! -s 20221124.taxonomy.txt ]]; then
  spcount dl_taxonomy -o 20221124.taxonomy.txt
fi

if [[ ! -s 20221124_assembly_summary.txt ]]; then
  spcount dl_assembly_summary -d refseq -o 20221124_refseq_assembly_summary.txt
fi

#download bacteria, restrict to reference or representative only
spcount dl_genome -i 2 -t 20221124.taxonomy.txt -a 20221124_refseq_assembly_summary.txt -n 500 -p 20221124_bacteria -r -o .

#download virus, don't restrict to reference or representative only
spcount dl_genome -i 10239 -t 20221124.taxonomy.txt -a 20221124_refseq_assembly_summary.txt -n 20000 -p 20221124_virus -o .

#download fungi, don't restrict to reference or representative only
spcount dl_genome -i 4751 -t 20221124.taxonomy.txt -a 20221124_refseq_assembly_summary.txt -n 10000 -p 20221124_fungi -o .

 