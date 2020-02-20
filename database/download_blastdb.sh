cd /scratch/cqs_share/references/blastdb

#gsutil ls gs://blast-db/

gsutil -m cp gs://blast-db/2020-02-15-09-34-58/nt.* .

#wget https://raw.githubusercontent.com/jrherr/bioinformatics_scripts/master/perl_scripts/update_blastdb.pl

#perl update_blastdb.pl nt
