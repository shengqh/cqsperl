import argparse
import logging
from Bio.SeqIO.FastaIO import FastaIterator

parser = argparse.ArgumentParser(description="Extract exon fasta",
                                 formatter_class=argparse.ArgumentDefaultsHelpFormatter)

parser.add_argument('-i', '--input', action='store', nargs='?', help='Input fasta file', required=False)
parser.add_argument('-g', '--gtf', action='store', nargs='?', help='Input GTF file', required=True)
parser.add_argument('-o', '--output', action='store', nargs='?', help="Output fasta file", required=False)

min_length = 30

args = parser.parse_args()

logger = logging.getLogger('exon_fasta')
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(name)s - %(levelname)-8s - %(message)s')

logger.info("reading " + args.input + " ...")
chr_map = {}
with open(args.input) as handle:
  for record in FastaIterator(handle):
    logger.info(record.id + " ...")
    chr_map[record.id] = record.seq

last_chr = ""
logger.info("reading " + args.gtf + " ...")
keys = set()
with open(args.gtf, "rt") as fin, open(args.output, "wt") as fout, open(args.output + ".namemap", "wt") as fnm:
  fnm.write("id\ttrans_exon\n")
  icount = 0
  for line in fin:
    if line.startswith('##'):
      continue

    parts = line.split('\t')
    if last_chr != parts[0]:
      last_chr = parts[0]
      logger.info(last_chr)

    if parts[2] != "exon":
      continue

    start = int(parts[3]) - 1
    end = int(parts[4])
    seqlen = end - start

    if seqlen < min_length:
      continue

    key = f"{parts[0]}:{start}-{parts[4]}"

    if key not in keys:
      keys.add(key)
      seq = chr_map[parts[0]]
      exon_seq = seq[start:int(parts[4])]
      fout.write(f">{key}\n{exon_seq}\n")

    value = parts[8]
    values = value.split('; ')
    trans_exon = ""
    for v in values:
      if v.startswith("transcript_name"):
        trans_exon = v.split(' ', 1)[1]
        trans_exon = trans_exon[1:(len(trans_exon)-1)]
      elif v.startswith("exon_number"):
        trans_exon = trans_exon + ":" + v.split(' ', 1)[1]
        break

    fnm.write(f"{key}\t{trans_exon}\n")
