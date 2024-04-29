from Bio import SeqIO
import os
import re
import shutil

erv_lines = []
with open('/data/cqs/references/smallrna/v202211/HERVd.20221123/HERVd.erv.bed', "rt") as fin:
  for line in fin:
    parts = line.split('\t')
    parts = parts[0:6]
    names = parts[3].replace(',',"_").split(':')
    name = f"{names[1]}:{names[2]}"
    parts[3] = name
    erv_lines.append("\t".join(parts) + "\n")

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

fasta_fai = '/data/cqs/references/smallrna/v202211_trna_cca/hg38_miRBase22_GtRNAdb19CCA_gencode42.fasta.fai'

append_bed('/data/cqs/references/smallrna/v202211_trna_cca/hg38_miRBase22_GtRNAdb19CCA_gencode42.bed', 
           '/data/cqs/references/smallrna/v202211_trna_cca/hg38_miRBase22_GtRNAdb19CCA_gencode42_HERVd.bed', 
           fasta_fai,
           erv_lines)

shutil.copyfile("/data/cqs/references/smallrna/v202211_trna_cca/hg38_miRBase22_GtRNAdb19CCA_gencode42.bed.fa",
                '/data/cqs/references/smallrna/v202211_trna_cca/hg38_miRBase22_GtRNAdb19CCA_gencode42_HERVd.bed.fa')

append_bed('/data/cqs/references/smallrna/v202211_trna_cca/hg38_miRBase22_GtRNAdb19CCA_gencode42.bed.miss0', 
           '/data/cqs/references/smallrna/v202211_trna_cca/hg38_miRBase22_GtRNAdb19CCA_gencode42_HERVd.bed.miss0', 
           fasta_fai,
           erv_lines)

append_bed('/data/cqs/references/smallrna/v202211_trna_cca/hg38_miRBase22_GtRNAdb19CCA_gencode42.bed.miss1', 
           '/data/cqs/references/smallrna/v202211_trna_cca/hg38_miRBase22_GtRNAdb19CCA_gencode42_HERVd.bed.miss1', 
           fasta_fai,
           [])

with open("/data/cqs/references/smallrna/v202211_trna_cca/hg38_miRBase22_GtRNAdb19CCA_gencode42_HERVd.bed.info", "wt") as fout:
  with open("/data/cqs/references/smallrna/v202211_trna_cca/hg38_miRBase22_GtRNAdb19CCA_gencode42.bed.info", "rt") as fin:
    fout.write(fin.readline())
    fout.write(f"ERV\t{len(erv_lines)}\n")
    for line in fin:
      fout.write(line)
