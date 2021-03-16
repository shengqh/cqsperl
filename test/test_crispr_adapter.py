overrepresent_sequence="GATGCACATCTGCTTTATATATCTTGTGGCACCGAGTCGGAGATCGGAAG"
library="/scratch/h_vangard_1/wangj52/Bill/Caleb-MV411-CRISPR_screen/MAGeCK/numbered_brunello_validation_library.txt"

with open(library, "rt") as fin:
  for line in fin:
    parts=line.rstrip().split('\t')
    if parts[1] in overrepresent_sequence:
      print(parts)