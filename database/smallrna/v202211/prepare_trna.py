from Bio import SeqIO
import os
import re

def process_trna(input_fa, output_dna_fa, output_bed):
  with open(output_dna_fa, "wt") as ffasta, open(output_bed, "wt") as fbed:
    fasta_sequences = SeqIO.parse(input_fa,'fasta')
    for fasta in fasta_sequences:
      ffasta.write(f">{fasta.description}\n")
      dna=str(fasta.seq).replace('U','T')
      ffasta.write(f"{dna}\n")

      id = re.sub(".*_tRNA", "tRNA", fasta.id)

      res = re.search('(chr\S+?):(\d+)-(\d+)\s.(.).', fasta.description)
      chrom = res.group(1)
      start_pos = int(res.group(2))
      end_pos = res.group(3)
      strand = res.group(4)

      fbed.write(f"{chrom}\t{start_pos-1}\t{end_pos}\t{id}\t1000\t{strand}\n")  

for species in ["hg38", "mm10"]:
  input_fa = f"/data/cqs/references/smallrna/v202211/GtRNAdb.v19/{species}-mature-tRNAs.fa"
  output_dna_fa = f"/data/cqs/references/smallrna/v202211/GtRNAdb.v19/{species}-mature-tRNAs.dna.fa"
  output_bed = f"/data/cqs/references/smallrna/v202211/GtRNAdb.v19/{species}-mature-tRNAs.bed"
  process_trna(input_fa, output_dna_fa, output_bed)
