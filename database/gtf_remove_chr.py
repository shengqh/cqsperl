import os.path
import subprocess
import gzip

def remove_feature_chr_bgzipped(vcf_file):
  done_file = f"{vcf_file}.done"
  if os.path.exists(done_file):
    return

  lines = []
  tmp_file = gtf_file + ".tmp"
  with gzip.open(vcf_file, "rt"):
    with open(tmp_file, "wt") as fout:
      for line in fin:
        if line.startswith("chr"):
          line = line[3:]
        fout.write(line)

  ungz_file = vcf_file.replace(".gz","")

  subprocess.run(f"mv {vcf_file} {ungz_file}.old.gz", shell=True)
  subprocess.run(f"mv {tmp_file} {ungz_file}", shell=True)

  if is_gzipped:
    subprocess.run(f"mv {vcf_file}.tbi {ungz_file}.old.gz.tbi", shell=True)
    subprocess.run(f"bgzip {ungz_file}", shell=True)
    subprocess.run(f"tabix {vcf_file}", shell=True)

  subprocess.run(f"touch {done_file}", shell=True)
  
  print("done")

def remove_feature_chr(gtf_file):
  done_file = f"{gtf_file}.done"
  if os.path.exists(done_file):
    return

  print(f"processing {gtf_file} ...")

  lines = []

  tmp_file = gtf_file + ".tmp"
  with open(gtf_file, "rt") as fin:
    with open(tmp_file, "wt") as fout:
      for line in fin:
        if line.startswith("chr"):
          line = line[3:]
        fout.write(line)

  subprocess.run(f"mv {gtf_file} {gtf_file}.old", shell=True)
  subprocess.run(f"mv {gtf_file}.idx {gtf_file}.old.idx", shell=True)

  subprocess.run(f"mv {tmp_file} {gtf_file}", shell=True)
  subprocess.run(f"gatk IndexFeatureFile -I {gtf_file}", shell=True)

  subprocess.run(f"touch {done_file}", shell=True)
  
  print("done")


def remove_table_chr(gtf_file, column_index):
  done_file = f"{gtf_file}.done"
  if os.path.exists(done_file):
    return

  lines = []

  with open(gtf_file, "rt") as fin:
    for line in fin:
      line = line.rstrip()
      parts = line.split('\t', column_index + 1)
      if parts[column_index].startswith("chr"):
        parts[column_index] = parts[column_index][3:]
        line = "\t".join(parts)
      lines.append(line)

  subprocess.run(f"mv {gtf_file} {gtf_file}.old", shell=True)
  subprocess.run(f"mv {gtf_file}.idx {gtf_file}.old.idx", shell=True)

  with open(gtf_file, "wt") as fout:
    for line in lines:
      fout.write(line + "\n")

  subprocess.run(f"gatk IndexFeatureFile -I {gtf_file}", shell=True)
  subprocess.run(f"touch {done_file}", shell=True)
  
  print("done")

#gtf_file = "/data/cqs/references/broad/funcotator_dataSources.v1.7.20200521s.no_chr_hg19/gencode/hg19/gencode.v34lift37.annotation.REORDERED.gtf"

root_dir="/data/cqs/references/broad/funcotator_dataSources.v1.7.20200521s.no_chr_hg19"

remove_feature_chr(f"{root_dir}/clinvar/hg19/clinvar_20180401.vcf")

remove_table_chr(f"{root_dir}/clinvar_hgmd/hg19/clinvar_hgmd.tsv", 2)

#remove_feature_chr_bgzipped(f"{root_dir}/dbsnp/hg19/hg19_All_20180423.vcf.gz")

remove_feature_chr(f"{root_dir}/gencode/hg19/gencode.v34lift37.annotation.REORDERED.gtf")

remove_table_chr(f"{root_dir}/oreganno/hg19/oreganno.tsv", 1)



