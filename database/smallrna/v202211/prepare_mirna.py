from Bio import SeqIO
import os
import re

def rna_to_dna(input_fa, output_dna_fa):
  with open(output_dna_fa, "wt") as ffasta:
    fasta_sequences = SeqIO.parse(input_fa,'fasta')
    for fasta in fasta_sequences:
      ffasta.write(f">{fasta.description}\n")
      dna=str(fasta.seq).replace('U','T')
      ffasta.write(f"{dna}\n")

rna_to_dna("/data/cqs/references/smallrna/v202211/miRBase.v22.1/mature.fa", "/data/cqs/references/smallrna/v202211/miRBase.v22.1/mature.dna.fa")
