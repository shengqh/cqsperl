cd /scratch/cqs/shengq2/dnaseq/example_data

for sf in S1_L1 S1_L2
do
  echo processing $sf ...

  if [[ ! -s ${sf}.bam ]]; then
    bwa mem -R "@RG\tID:${sf}\tPU:${sf}\tLB:${sf}\tSM:${sf}\tPL:ILLUMINA" /data/cqs/references/gencode/GRCh38.p13/bwa_index_0.7.17/GRCh38.primary_assembly.genome.fa ${sf}_1.fq.gz ${sf}_2.fq.gz | samtools sort -o ${sf}.bam -
    samtools index ${sf}.bam
  fi

  if [[ ! -s ${sf}.cram ]]; then
    samtools view -T /data/cqs/references/gencode/GRCh38.p13/bwa_index_0.7.17/GRCh38.primary_assembly.genome.fa -C -o ${sf}.cram ${sf}.bam
    samtools index ${sf}.cram
  fi

done

