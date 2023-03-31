setfacl -R -m g:h_cqs:r-x /scratch/cqs_share
setfacl -R -m g:brown_lab:r-x /scratch/cqs_share

#grant one folder for user
setfacl -m u:amanchk:r-x /scratch/cqs_share
setfacl -m u:amanchk:r-x /scratch/cqs_share/tmp
setfacl -R -m u:amanchk:r-x /scratch/cqs_share/tmp/20221201_scRNA_GSE192391_download
