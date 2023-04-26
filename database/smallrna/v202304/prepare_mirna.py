import argparse
import logging
import os
import re
from Bio import SeqIO

def rna_to_dna(input_fa, output_dna_fa):
  with open(output_dna_fa, "wt") as ffasta:
    fasta_sequences = SeqIO.parse(input_fa,'fasta')
    for fasta in fasta_sequences:
      ffasta.write(f">{fasta.description}\n")
      dna=str(fasta.seq).replace('U','T')
      ffasta.write(f"{dna}\n")

parser = argparse.ArgumentParser(description="Prepare miRBase",
                                 formatter_class=argparse.ArgumentDefaultsHelpFormatter)

parser.add_argument('-i', '--input', action='store', nargs='?', help='Input fasta file', required=False)
parser.add_argument('-o', '--output', action='store', nargs='?', help="Output fasta file", required=False)

args = parser.parse_args()

logger = logging.getLogger('mirbase')
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(name)s - %(levelname)-8s - %(message)s')

logger.info(f"processing {args.input} ...")
rna_to_dna(args.input, args.output)
logger.info("done")
