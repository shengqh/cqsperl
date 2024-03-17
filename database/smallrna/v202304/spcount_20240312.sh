spcount_VER="20240312"

mkdir -p /workspace/shengq2/references/spcount.${spcount_VER}
cd /workspace/shengq2/references/spcount.${spcount_VER}

if [[ ! -s slurm.template ]]; then
  ln -s /home/shengq2/program/spcount/src/spcount/slurm.template slurm.template 
fi

if [[ ! -s ${spcount_VER}.taxonomy.txt ]]; then
  spcount dl_taxonomy -o ${spcount_VER}.taxonomy.txt
fi

if [[ ! -s ${spcount_VER}_assembly_summary.txt ]]; then
  spcount dl_assembly_summary -d refseq -o ${spcount_VER}_refseq_assembly_summary.txt
fi

#bacteria
#download bacteria, restrict to reference or representative only
#spcount dl_genome -i 2 -t ${spcount_VER}.taxonomy.txt -a ${spcount_VER}_refseq_assembly_summary.txt -n 500 -p ${spcount_VER}_bacteria -r -o .

#virus
#download virus, don't restrict to reference or representative only
spcount dl_genome -i 10239 -t ${spcount_VER}.taxonomy.txt -a ${spcount_VER}_refseq_assembly_summary.txt -n 20000 -p ${spcount_VER}_virus -o .
#spcount bowtie_index -i ${spcount_VER}_virus.index.txt -t 24

#fungi
#download fungi, restrict to reference or representative only
#spcount dl_genome -i 4751 -t ${spcount_VER}.taxonomy.txt -a ${spcount_VER}_refseq_assembly_summary.txt -n 100 -p ${spcount_VER}_fungi -r -o .
#spcount bowtie_index -i ${spcount_VER}_fungi.index.txt -t 24

#metazoa 33208, including human,mouse and so on, ignored
#spcount dl_genome -i 33208 -t ${spcount_VER}.taxonomy.txt -a ${spcount_VER}_refseq_assembly_summary.txt -n 100 -p ${spcount_VER}_metazoa -r -o .

#Embryophyta 3193, plants
#spcount dl_genome -i 3193 -t ${spcount_VER}.taxonomy.txt -a ${spcount_VER}_refseq_assembly_summary.txt -n 100 -p ${spcount_VER}_plants -r -o .


