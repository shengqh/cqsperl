cd /data/cqs/references/methylation/twist

gatk BedToIntervalList \
    -I covered_targets_Twist_Methylome_hg38_annotated_collapsed.bed \
    -O covered_targets_Twist_Methylome_hg38_annotated_collapsed.interval_list \
    -SD /data/cqs/references/gencode/GRCh38.p13/GRCh38.primary_assembly.genome.dict