#!/bin/bash
## qcimg2pdf.sh
echo "Usage: $0 -o output_prefix";

if [[ $# -eq 0 || $# -gt 2 ]]
then
  echo "No/wrong ($#) arguments detected "
  echo "Run it where you have *fastqc directories or parent directory";
  exit 1 #exit shell script
fi

while getopts o: option
do
case $option in
o)
outprefix=$OPTARG
;;
esac
echo $outprefix;

if [[ $outprefix != "" ]];then
  findatsubdir=true
  for j in `ls -d1 *`
  do
    if [[ $j == *_fastqc ]];then
      findatsubdir=false
      echo $j ;
        convert \( -scale 500x500 $j/Images/per_base_quality.png $j/Images/per_base_sequence_content.png +append \) \( -scale 500x500 $j/Images/per_sequence_quality.png $j/Images/per_sequence_gc_content.png +append\) \( -scale 500x500 $j/Images/per_tile_quality.png $j/Images/adapter_content.png +append \)  -append -font Helvetica -pointsize 12 -gravity northwest -draw "translate +5,+5 text 550,28 'Directory=$i' text 550,40 '`grep -A5 Filename $j/fastqc_data.txt | awk '{ sub(/\t\n/, "\n", $0); sub(/\t/, "=", $0); print $0 }'`'" ../QC.$j.pdf
    fi
  done

  if $findatsubdir ; then
    isfirst=true
    for i in `ls -d1 *`;
    do
      if [ -d $i ]; then
        cd $i
        for j in `ls -d1 *_fastqc`;
        do
          echo $i"/"$j ;
          convert \( -scale 500x500 $j/Images/per_base_quality.png $j/Images/per_base_sequence_content.png +append \) \( -scale 500x500 $j/Images/per_sequence_quality.png $j/Images/per_sequence_gc_content.png +append \) \( -scale 500x500 $j/Images/per_tile_quality.png $j/Images/adapter_content.png +append \)  -append -font Helvetica -pointsize 12 -gravity northwest -draw "translate +5,+5 text 550,28 'Directory=$i' text 550,40 '`grep -A5 Filename $j/fastqc_data.txt | awk '{ sub(/\t\n/, "\n", $0); sub(/\t/, "=", $0); print $0 }'`'" ../QC.$i.$j.pdf
          if $isfirst ; then
	    printf 'Sample\tFile\tReads\n' > ../$outprefix.FastQC.reads.tsv
            isfirst=false
          fi
          grep 'Total Sequences' $j/fastqc_data.txt  | awk -v OFS='\t' -v SAMPLENAME=$i -v QCNAME=$j '{print SAMPLENAME, QCNAME, $3}' >> ../$outprefix.FastQC.reads.tsv
        done
        cd ..
      fi
    done
  fi

  convert QC.*.pdf $outprefix.FastQC.pdf
  rm *_fastqc.pdf
else
  echo "use correct arguments with only -o "
  exit 1 #exit shell script
fi

done
