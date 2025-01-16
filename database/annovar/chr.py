with open('/data/cqs/references/annovar/humandb/hg38_gnomad41_genome.txt', "rt") as fin:
  header = fin.readline().strip()
  header_parts = header.split("\t", 6)
  new_header = "\t".join(header_parts[0:6])
  last_chr = ""
  last_fout = None
  for line in fin:
    parts = line.split("\t", 6)
    
    if len(parts[3]) != 1:
      continue
    
    if len(parts[4]) != 1:
      continue

    if parts[3] == '-' or parts[4] == '-':
      continue

    if parts[0] != last_chr:
      if last_fout is not None:
        last_fout.close()
      last_fout = open('/data/cqs/references/annovar/humandb/hg38_gnomad41_genome_snv_AF_only_chr/' + parts[0] + '.txt', "wt")
      last_chr = parts[0]
      print(f"processing {parts[0]}")
      last_fout.write(new_header + "\n")

    last_fout.write("\t".join(parts[0:6]) + "\n")
  last_fout.close()
