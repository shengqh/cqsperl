from Bio import SeqIO
import os
import re
import shutil

pirna_names = {}
pirna_lines = []
with open('/data/cqs/references/smallrna/piRNA.1.7.6/pirnadb.v1_7_6.hg38.gtf', "rt") as fin:
  for line in fin:
    if line.startswith('#'):
      continue
    parts = line.split('\t')
    name = parts[8].replace('piRNA_code "', '').replace('"; piRNA_version "1.7.6";', '').strip()

    chrom = "chrM" if parts[0] == "chrMT" else parts[0]
    pirna_lines.append(f"{chrom}\t{int(parts[3]) - 1}\t{parts[4]}\tpiRNA:{name}\t1000\t{parts[6]}\n")
    pirna_names[name] = 1

def append_bed(source_bed, target_bed, fasta_fai, erv_lines):
  tmp_file = target_bed + ".tmp" 
  with open(tmp_file, "wt") as fout:
    with open(source_bed, "rt") as fin:
      for line in fin:
        fout.write(line)
    
    for line in erv_lines:
      fout.write(line)

  os.system(f"bedtools sort -i {tmp_file} -g {fasta_fai} > {target_bed}")
  os.unlink(tmp_file)

fasta_fai = '/data/cqs/references/smallrna/hg38_miRBase22_GtRNAdb2_gencode33_ncbi.fasta.fai'

append_bed('/data/cqs/references/smallrna/hg38_miRBase22_GtRNAdb2_gencode33_ncbi.bed', 
           '/data/cqs/references/smallrna/v20230308/hg38_miRBase22_GtRNAdb2_gencode33_ncbi.bed', 
           fasta_fai,
           pirna_lines)

append_bed('/data/cqs/references/smallrna/hg38_miRBase22_GtRNAdb2_gencode33_ncbi.bed.miss0', 
           '/data/cqs/references/smallrna/v20230308/hg38_miRBase22_GtRNAdb2_gencode33_ncbi.bed.miss0', 
           fasta_fai,
           pirna_lines)

with open("/data/cqs/references/smallrna/hg38_miRBase22_GtRNAdb2_gencode33_ncbi.bed.info", "rt") as fin:
  with open("/data/cqs/references/smallrna/v20230308/hg38_miRBase22_GtRNAdb2_gencode33_ncbi.bed.info", "wt") as fout:
    fout.write(fin.readline())
    for line in fin:
      fout.write(line)
    fout.write(f"piRNA\t{len(pirna_names)}\n")
