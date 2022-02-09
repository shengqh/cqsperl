input='/data/cqs/references/smallrna/SILVA_128.rmdup.category.map'
output='/data/cqs/references/smallrna/SILVA_128.rmdup.category.l2.map'
with open(input, "rt") as fin:
  with open(output, "wt") as fout:
    fout.write(fin.readline())
    for line in fin:
      parts=line.rstrip().split('\t')
      descs = parts[2].split(';')
      if len(descs) >= 2:
        parts[1] = descs[0] + "_" + descs[1]
      fout.write('\t'.join(parts) + "\n")

