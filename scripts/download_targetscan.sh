cd /scratch/cqs/references/targetscan/v7.2

if [[ ! -s miR_Family_Info.txt.zip ]]; then
  wget http://www.targetscan.org/vert_72/vert_72_data_download/miR_Family_Info.txt.zip
  wget http://www.targetscan.org/vert_72/vert_72_data_download/Conserved_Family_Info.txt.zip
  wget http://www.targetscan.org/vert_72/vert_72_data_download/Nonconserved_Family_Info.txt.zip
fi

for taxoid in 9606 10090
do
  echo $taxoid
  zcat miR_Family_Info.txt.zip | awk -v tid="$taxoid" -F "\t" '{ if (($3 == tid) || ($3 == "Species ID") ) { print } }' > ${taxoid}_miR_Family_Info.txt
  zcat Conserved_Family_Info.txt.zip | awk -v tid="$taxoid" -F "\t" '{ if (($5 == tid) || ($5 == "Species ID") ) { print } }' > ${taxoid}_Conserved_Family_Info.txt
  zcat Nonconserved_Family_Info.txt.zip | awk -v tid="$taxoid" -F "\t" '{ if (($5 == tid) || ($5 == "Species ID") ) { print } }' > ${taxoid}_Nonconserved_Family_Info.txt
  cat ${taxoid}_Conserved_Family_Info.txt > ${taxoid}_All_Family_Info.txt
  tail -n +2 ${taxoid}_Nonconserved_Family_Info.txt >> ${taxoid}_All_Family_Info.txt
done
