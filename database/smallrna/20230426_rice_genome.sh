mkdir -p /data/cqs/references/smallrna/rice
cd /data/cqs/references/smallrna/rice
wget https://ftp.ensemblgenomes.ebi.ac.uk/pub/plants/release-56/fasta/oryza_sativa/dna/Oryza_sativa.IRGSP-1.0.dna.toplevel.fa.gz
gunzip Oryza_sativa.IRGSP-1.0.dna.toplevel.fa.gz
buildindex.pl -f Oryza_sativa.IRGSP-1.0.dna.toplevel.fa -b

wget https://ftp.ensemblgenomes.ebi.ac.uk/pub/plants/release-56/gtf/oryza_sativa/Oryza_sativa.IRGSP-1.0.56.gtf.gz
gunzip Oryza_sativa.IRGSP-1.0.56.gtf.gz
