import re

with open("/data/cqs/references/hg38/hg38_hapmap.txt", "rt") as fin:
  with open("/data/cqs/references/hg38/hg38_nochr_hapmap.txt.tmp", "wt") as fout:
    for line in fin:
      parts = line.split('\t')
      if parts[0] == "@SQ":
        parts[1] = parts[1].replace("SN:chr", "SN:")
      elif parts[0].startswith("chr"):
        for idx in range(len(parts)):
          parts[idx] = re.sub("^chr","",parts[idx])
      fout.write("\t".join(parts))

print("done")