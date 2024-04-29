def modify_fasta_file(input_file, output_file):
  with open(input_file, 'r') as f_in, open(output_file, 'w') as f_out:
    for line in f_in:
      line = line.strip()
      if line.startswith('>'):
        f_out.write(line + '\n')
      else:
        f_out.write(line + 'CCA\n')

# Example usage
input_file = '/data/cqs/references/smallrna/v202211/GtRNAdb.v19/hg38-mature-tRNAs.dna.fa'
output_file = '/data/cqs/references/smallrna/v202211_trna_cca/hg38-mature-tRNAs-CCA.dna.fa'
modify_fasta_file(input_file, output_file)

