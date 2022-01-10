import os
import hashlib

root_dir = '/data1/shengq2/1000g'

md5_file=os.path.join(root_dir, "phased-manifest_July2021.tsv")

md5_succeed_file = md5_file + ".succeed"

succeed = []
if os.path.exists(md5_succeed_file):
  with open(md5_succeed_file, "rt") as fin:
    for line in fin:
      succeed.append(line.rstrip())

with open(md5_file, "rt") as fin:
  for line in fin:
    parts = line.rstrip().split('\t')
    if parts[0] in succeed:
      continue

    print(parts)

    dfile = os.path.join(root_dir, parts[0])
    if os.path.exists(dfile):
      file_hash = hashlib.md5()
      with open(dfile, "rb") as f:
        chunk = f.read(8192)
        while chunk:
          file_hash.update(chunk)
          chunk = f.read(8192)

      dmd5 = file_hash.hexdigest()
      if dmd5 != parts[2]:
        print("FAILED: %s\n" % parts[0])
      else:
        succeed.append(parts[0])
  
with open(md5_succeed_file, "wt") as fout:
  for line in succeed:
    fout.write(line + "\n")


