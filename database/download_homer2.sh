##download capture bed

mkdir /scratch/cqs_share/softwares/homer2
cd /scratch/cqs_share/softwares/homer2
wget http://homer.ucsd.edu/homer/configureHomer.pl
perl configureHomer.pl -install homer 
perl configureHomer.pl -install hg19
perl configureHomer.pl -install hg38
perl configureHomer.pl -install mm10

