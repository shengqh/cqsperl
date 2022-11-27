import os
import os.path
from urllib.request import urlopen, urlretrieve
from bs4 import BeautifulSoup
from Bio import SeqIO

class trna_species:
  def __init__(self, tag):
    address = link["href"]
    self.long_name = link.text
    parts = address.split('/')
    self.short_name = parts[2]
    self.category = parts[1]
    self.local_files = []
    self.local_mature_file = None
    self.url = "http://gtrnadb.ucsc.edu/" + address
  
  def __str__(self):
    return(f"{self.category}:{self.short_name}:{self.url}")

def get_html(url):
  page = urlopen(url)
  html_bytes = page.read()
  result = html_bytes.decode("utf-8")
  return(result)

def get_links(url):
  html = get_html(url)
  soup = BeautifulSoup(html, "html.parser")
  tags = soup.find_all('a')
  result = [link for link in tags if "href" in link.attrs]
  return(result)

def print_links(links):
  for link in links:
    address = link["href"]
    text = link.text
    print(f"{text}: {address}")  

trna_root = "/workspace/shengq2/smallrna/GtRNAdb.v19/"

url = "http://gtrnadb.ucsc.edu/browse.html"
links = get_links(url)

links = [link for link in links if link["href"].startswith("genomes") ]
#print(links[0])

all_trnas = []
for link in links:
  trna = trna_species(link)
  
  #the file link was broken
  if trna.short_name == "Sfrug1":
    continue

  all_trnas.append(trna)

all_trnas.sort(key=lambda x:(x.category, x.short_name))

index = 0
for trna in all_trnas:
  index += 1
  local_dir = os.path.join(trna_root, trna.category, trna.short_name)
  if os.path.exists(local_dir):
    files = os.listdir(local_dir)
    if len(files) > 0:
      trna.local_files = files
      continue

  if not os.path.exists(local_dir):
    os.makedirs(local_dir)
  
  print(f"{index}/{len(all_trnas)}:{trna}")

  species_links = get_links(trna.url)
  species_seq_link = [link for link in species_links if link.text.startswith("FASTA Seqs")][0]
  species_seq_url = trna.url + species_seq_link["href"]
  print("  " + species_seq_url)
  
  fa_links = get_links(species_seq_url)
  fa_links = [fl for fl in fa_links if fl.text.endswith("tRNAs.fa")]

  for fl in fa_links:
    fl_link = trna.url + fl["href"]
    local_file = os.path.join(local_dir, fl["href"])
    trna.local_files.append(local_file)
    if not os.path.exists(local_file):
      print(f"  downloading {fl_link} ...")
      urlretrieve(fl_link, local_file)
  
with open(os.path.join(trna_root, "trna.meta.txt"), "wt") as fout:
  fout.write("category\tshort_name\tlong_name\tfiles\n")
  for trna in all_trnas:
    mature_file = [lf for lf in trna.local_files if "-mature-" in lf]
    if len(mature_file) > 0:
      trna.local_mature_file = os.path.join(trna_root, trna.category, trna.short_name, mature_file[0])
      fout.write(f"{trna.category}\t{trna.short_name}\t{trna.long_name}\t{mature_file[0]}\n")

print("writing combined database ...")
with open("/data/cqs/references/smallrna/v202211/GtRNAdb.v19/GtRNAdb.v19.mature.fa", "wt") as fout:
  with open("/data/cqs/references/smallrna/v202211/GtRNAdb.v19/GtRNAdb.v19.category.map", "wt") as fcat:
    fcat.write("Id\tSpecies\n")

    chromosomes = set()
    for trna in all_trnas:
      if trna.local_mature_file != None:
        fasta_sequences = SeqIO.parse(trna.local_mature_file,'fasta')
        for fasta in fasta_sequences:
          if fasta.id in chromosomes:
            continue

          fout.write(f">{fasta.description}\n")
          dna=str(fasta.seq).replace('U','T')
          fout.write(f"{dna}\n")
          fcat.write(f"{fasta.id}\t{trna.category}\n")

          chromosomes.add(fasta.id)
