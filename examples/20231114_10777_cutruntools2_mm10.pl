#!/usr/bin/perl
use strict;
use warnings;

use CQS::Global;
use CQS::FileUtils;
use CQS::ClassFactory;
use CQS::PerformCutruntools2;

my $def = {
  task_name        => "P10777_cutrun_mm10",
  email            => "quanhu.sheng.1\@vumc.org",
  target_dir       => create_directory_or_die("/nobackup/brown_lab/projects/20231114_10777_cutruntools2_mm10"),
  add_folder_index => 0,

  files => {
    'ha_fl_znf469' => [ '/gpfs52/data/jbrown_lab/2023/20231113_10777_cutrun/10777-JB-0002_S1_L005_R1_001.fastq.gz', '/gpfs52/data/jbrown_lab/2023/20231113_10777_cutrun/10777-JB-0002_S1_L005_R2_001.fastq.gz' ],
    'igg_dzf' => [ '/gpfs52/data/jbrown_lab/2023/20231113_10777_cutrun/10777-JB-0003_S1_L005_R1_001.fastq.gz', '/gpfs52/data/jbrown_lab/2023/20231113_10777_cutrun/10777-JB-0003_S1_L005_R2_001.fastq.gz' ],
    'ha_dzf_ZNF' => [ '/gpfs52/data/jbrown_lab/2023/20231113_10777_cutrun/10777-JB-0004_S1_L005_R1_001.fastq.gz', '/gpfs52/data/jbrown_lab/2023/20231113_10777_cutrun/10777-JB-0004_S1_L005_R2_001.fastq.gz' ],
  },

  perform_preprocessing => 1, #do fastqc
  perform_cutadapt => 0, #cutruntool2 will do adapter trimming
  is_paired_end => 1,
  cutruntools2_adaptor_type =>"Truseq", #Nextera or Truseq
  cutruntools2_fastq_sequence_length => 152, #check your fastq file to get the read length

  perform_bamplot => 0,
  gene_names => "EDN1 EGFL7 VWF PECAM1",
};

my $config = performCutruntools2_gencode_mm10($def, 1);
#my $config = performCutruntools2_gencode_hg38($def, 1);

1;
