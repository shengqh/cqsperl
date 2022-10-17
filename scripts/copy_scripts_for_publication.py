import argparse
import logging
import os
import os.path
from pathlib import Path

def copy_folder(logger, f_subfolder, t_subfolder):
  if not os.path.exists(t_subfolder):
    Path(t_subfolder).mkdir(parents=True, exist_ok=True)
  
  cmd = f"cp -p {f_subfolder}/*.pbs {f_subfolder}/*.sh {f_subfolder}/*fileList* {f_subfolder}/*.R {f_subfolder}/*.r  {f_subfolder}/*.define {f_subfolder}/*.design {f_subfolder}/*.rmd  {f_subfolder}/*.Rmd {t_subfolder}"
  print(cmd + "\n")
  os.system(cmd)   

  fd = [ f.name for f in os.scandir(f_subfolder) if f.is_dir() ] 
  for fd1 in fd:
    copy_folder(logger, f"{f_subfolder}/{fd1}", f"{t_subfolder}/{fd1}")
  
  fd = os.listdir(t_subfolder)
  if len(fd) == 0:
    os.rmdir(t_subfolder)     
  
def handle_folder(logger, source_folder, target_folder):
  if not os.path.exists(target_folder):
    Path(target_folder).mkdir(parents=True, exist_ok=True)
  
  cmd = f"cp -p {source_folder}/*.pl {target_folder}"
  print(cmd + "\n")
  os.system(cmd)   

  subfolders = [ f.name for f in os.scandir(source_folder) if f.is_dir() ]
  if "pbs" in subfolders:
    logger.info(f"Find one: {source_folder}")
    for subfolder in ["pbs", "result"]:
      f_subfolder = source_folder + "/" + subfolder
      t_subfolder = target_folder + "/" + subfolder
      copy_folder(logger, f_subfolder, t_subfolder)
  else:
    for subfolder in subfolders:
      handle_folder(logger, source_folder + "/" + subfolder, target_folder + "/" + subfolder)

parser = argparse.ArgumentParser(description="Extract exon fasta",
                                 formatter_class=argparse.ArgumentDefaultsHelpFormatter)

parser.add_argument('-i', '--input', action='store', nargs='?', help='Input folder', required=False)
parser.add_argument('-o', '--output', action='store', nargs='?', help="Output folder", required=False)

args = parser.parse_args()

logger = logging.getLogger('copy_scripts')
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(name)s - %(levelname)-8s - %(message)s')

handle_folder(logger, args.input, args.output)

