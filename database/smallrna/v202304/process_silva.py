from Bio import SeqIO
import os

def process_file(fout, fcat, filename, chromosomes):
  fasta_sequences = SeqIO.parse(filename,'fasta')
  for fasta in fasta_sequences:
    if fasta.id in chromosomes:
      print(f"duplicated: {fasta.id}")
      continue
    
    description = fasta.description.split(' ')[1]
    category = "_".join(description.split(';')[0:2])
    fcat.write(f"{fasta.id}\t{category}\t{description}\n")

    chromosomes.add(fasta.id)

    fout.write(f">{fasta.description}\n")
    fout.write(f"{fasta.seq}\n")

local_dir = "/data/cqs/references/smallrna/v202211/SILVA_138.1/"

chromosomes = set()
with open(os.path.join(local_dir, "SILVA_138.1.rmdup.fasta"), "wt") as fout:
  with open(os.path.join(local_dir, "SILVA_138.1.category.map"), "wt") as fcat:
    fcat.write("Name\tCategory\tDescription\n")
    process_file(fout, fcat, os.path.join(local_dir,"SILVA_138.1_LSURef_NR99_tax_silva.fasta"), chromosomes)
    process_file(fout, fcat, os.path.join(local_dir,"SILVA_138.1_SSURef_NR99_tax_silva.fasta"), chromosomes)
