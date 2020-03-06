cd /scratch/cqs_share/references/taxonomy
wget ftp://ftp.ncbi.nih.gov/pub/taxonomy/taxdump.tar.gz
tar -xzvf taxdump.tar.gz
rm taxdump.tar.gz

grep "scientific name" names.dmp > names_scientific.dmp
awk '{print $1,"\t",$3}' nodes.dmp > nodes_parent.txt
awk '{if($3==10239)print $1}' nodes.dmp > virus_level1.taxonomy


