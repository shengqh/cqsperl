import os.path
import subprocess
import gzip

def run_command(command, shell=True):
  print(command)
  subprocess.run(command, shell=shell)

def remove_feature_chr_bgzipped(vcf_file, is_gzipped=True):
  done_file = f"{vcf_file}.done"
  if os.path.exists(done_file):
    return

  lines = []
  tmp_file = vcf_file + ".tmp"
  with gzip.open(vcf_file, "rt") as fin:
    with open(tmp_file, "wt") as fout:
      for line in fin:
        if line.startswith("chr"):
          line = line[3:]
        fout.write(line)

  ungz_file = vcf_file.replace(".gz","")

  run_command(f"mv {vcf_file} {ungz_file}.old.gz", shell=True)
  run_command(f"mv {vcf_file}.tbi {ungz_file}.old.gz.tbi", shell=True)

  run_command(f"mv {tmp_file} {ungz_file}", shell=True)
  if is_gzipped:
    run_command(f"bgzip {ungz_file}", shell=True)
    run_command(f"tabix {vcf_file}", shell=True)

  if os.path.exists(f"{vcf_file}.tbi"):
    run_command(f"touch {done_file}", shell=True)
    run_command(f"rm {ungz_file}.old.gz {ungz_file}.old.gz.tbi", shell=True)
  
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

  run_command(f"mv {gtf_file} {gtf_file}.old", shell=True)
  run_command(f"mv {gtf_file}.idx {gtf_file}.old.idx", shell=True)

  run_command(f"mv {tmp_file} {gtf_file}", shell=True)
  run_command(f"singularity exec /data/cqs/softwares/singularity/gatk.4.0.0.0.sif gatk IndexFeatureFile -F {gtf_file}", shell=True)

  if os.path.exists(f"{gtf_file}.idx"):
    run_command(f"touch {done_file}", shell=True)
    run_command(f"rm {gtf_file}.old {gtf_file}.old.idx", shell=True)

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

  run_command(f"mv {gtf_file} {gtf_file}.old", shell=True)
  run_command(f"mv {gtf_file}.idx {gtf_file}.old.idx", shell=True)

  with open(gtf_file, "wt") as fout:
    for line in lines:
      fout.write(line + "\n")

  run_command(f"singularity exec /data/cqs/softwares/singularity/gatk.4.0.0.0.sif gatk IndexFeatureFile -F {gtf_file}", shell=True)
  if os.path.exists(f"{gtf_file}.idx"):
    run_command(f"touch {done_file}", shell=True)
    run_command(f"rm {gtf_file}.old {gtf_file}.old.idx", shell=True)

  print("done")

root_dir="/data/cqs/references/broad/funcotator/funcotator_dataSources.v1.8.hg19.20230908s.no_chr"

#although we tried to fix the chromosome issue, it didn't work, so use 1.6 instead

#default is no_chr, don't need to remove chr
#remove_feature_chr(f"{root_dir}/clinvar/hg19/clinvar_20230717.vcf")

remove_table_chr(f"{root_dir}/clinvar_hgmd/hg19/clinvar_hgmd.tsv", 2)

remove_feature_chr_bgzipped(f"{root_dir}/dbsnp/hg19/hg19_All_20180423.vcf.gz")

remove_feature_chr(f"{root_dir}/gencode/hg19/gencode.v43lift37.annotation.REORDERED.gtf")

remove_table_chr(f"{root_dir}/oreganno/hg19/oreganno.tsv", 1)



