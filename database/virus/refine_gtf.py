import os
import hashlib

old_gtf = '/data/cqs/references/gencode/GRCh38.p13.virus/GRCh38.p13.20240723_refseq_virus.gtf'
new_gtf = '/data/cqs/references/gencode/GRCh38.p13.virus/GRCh38.p13.20240723_refseq_virus.filtered.gtf'

dup_genes = []
genes_dict = {}
with open(old_gtf, "rt") as fin:
  for line in fin:
    parts = line.split('\t')
    if (len(parts) < 9):
      continue

    if parts[2] == 'gene':
      gene_id = parts[8].split(';', 1)[0].split('"')[1]
      chrom_gene_id = parts[0] + ":" + gene_id
      if chrom_gene_id in genes_dict:
        dup_genes.append(chrom_gene_id)
      else:
        genes_dict[chrom_gene_id] = 1

print("duplicated genes:")
print(dup_genes)