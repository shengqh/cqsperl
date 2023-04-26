import argparse
import logging
import os
import re
from Bio import SeqIO

def process_trna(input_fa, output_dna_fa, output_bed):
  with open(output_dna_fa, "wt") as ffasta, open(output_bed, "wt") as fbed:
    fasta_sequences = SeqIO.parse(input_fa,'fasta')
    for fasta in fasta_sequences:
      ffasta.write(f">{fasta.description}\n")
      dna=str(fasta.seq).replace('U','T')
      ffasta.write(f"{dna}\n")

      id = re.sub(".*_tRNA", "tRNA", fasta.id)

      res = re.search('(chr\S+?):(\d+)-(\d+)\s.(.).', fasta.description)
      chrom = res.group(1)
      start_pos = int(res.group(2))
      end_pos = res.group(3)
      strand = res.group(4)

      fbed.write(f"{chrom}\t{start_pos-1}\t{end_pos}\t{id}\t1000\t{strand}\n")  

parser = argparse.ArgumentParser(description="Prepare tRNA",
                                 formatter_class=argparse.ArgumentDefaultsHelpFormatter)

parser.add_argument('-i', '--input', action='store', nargs='?', help='Input RNA fasta file', required=False)
parser.add_argument('-o', '--output', action='store', nargs='?', help="Output DNA fasta file", required=False)
parser.add_argument('-b', '--bed', action='store', nargs='?', help="Output bed file", required=False)

args = parser.parse_args()

logger = logging.getLogger('GtRNAdb')
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(name)s - %(levelname)-8s - %(message)s')

logger.info(f"processing {args.input} ...")
process_trna(args.input, args.output, args.bed)
logger.info("done")
