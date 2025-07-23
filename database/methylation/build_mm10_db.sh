mkdir -p /data/cqs/references/ucsc/mm10/abismal_index
cd /data/cqs/references/ucsc/mm10/abismal_index

singularity exec -B /panfs,/data /data/cqs/softwares/singularity/cqs-dnmtools.20231214.sif dnmtools abismalidx -t 12 ../mm10.fa mm10.abismalidx

cd /data/cqs/references/ucsc/mm10

gatk BedToIntervalList -I Target_bases_covered_by_probes_Methyl_Twist_Mouse_CpG_Islands_MTE-92874077_mm10_230825155415.bed -O Target_bases_covered_by_probes_Methyl_Twist_Mouse_CpG_Islands_MTE-92874077_mm10_230825155415.interval -SD mm10.dict