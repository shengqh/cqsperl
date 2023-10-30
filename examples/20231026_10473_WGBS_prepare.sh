cd /nobackup/h_cqs/shengq2/methylation_data/

zcat /data/jbrown_lab/2023/20231006_Freiberg_10473_methylation/poolG_samples0374-0399/10473-AS-396b_S1_L005_R1_001.fastq.gz | head -n 100000 | gzip > A1_R1.fastq.gz
zcat /data/jbrown_lab/2023/20231006_Freiberg_10473_methylation/poolG_samples0374-0399/10473-AS-396b_S1_L005_R2_001.fastq.gz | head -n 100000 | gzip > A1_R2.fastq.gz

zcat /data/jbrown_lab/2023/20231006_Freiberg_10473_methylation/poolG_samples0374-0399/10473-AS-397b_S1_L005_R1_001.fastq.gz | head -n 100000 | gzip > A2_R1.fastq.gz
zcat /data/jbrown_lab/2023/20231006_Freiberg_10473_methylation/poolG_samples0374-0399/10473-AS-397b_S1_L005_R2_001.fastq.gz | head -n 100000 | gzip > A2_R2.fastq.gz

zcat /data/jbrown_lab/2023/20231006_Freiberg_10473_methylation/poolG_samples0374-0399/10473-AS-398b_S1_L005_R1_001.fastq.gz | head -n 100000 | gzip > B1_R1.fastq.gz
zcat /data/jbrown_lab/2023/20231006_Freiberg_10473_methylation/poolG_samples0374-0399/10473-AS-398b_S1_L005_R2_001.fastq.gz | head -n 100000 | gzip > B1_R2.fastq.gz

zcat /data/jbrown_lab/2023/20231006_Freiberg_10473_methylation/poolG_samples0374-0399/10473-AS-399b_S1_L005_R1_001.fastq.gz | head -n 100000 | gzip > B2_R1.fastq.gz
zcat /data/jbrown_lab/2023/20231006_Freiberg_10473_methylation/poolG_samples0374-0399/10473-AS-399b_S1_L005_R2_001.fastq.gz | head -n 100000 | gzip > B2_R2.fastq.gz
