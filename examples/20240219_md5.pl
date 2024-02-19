#!/usr/bin/perl
use strict;
use warnings;
use CQS::Global;
use CQS::FileUtils;
use CQS::SystemUtils;
use CQS::ConfigUtils;
use CQS::ClassFactory;
use Pipeline::Preprocession;

use Hash::Merge qw( merge );

my $def = {
  task_name           => "P10473",
  email               => "quanhu.sheng.1\@vumc.org",
  emailType           => "FAIL",
  target_dir          => "/nobackup/h_cqs/shengq2/temp/20240219_md5",

  files => {
    "A1" => [ "/data/jbrown_lab/2023/20231006_Freiberg_10473_methylation/poolA_samples0001-0048/10473-AS-0001b_S1_L005_R1_001.fastq.gz", "/data/jbrown_lab/2023/20231006_Freiberg_10473_methylation/poolA_samples0001-0048/10473-AS-0001b_S1_L005_R2_001.fastq.gz" ],
    "A2" => [ "/data/jbrown_lab/2023/20231006_Freiberg_10473_methylation/poolA_samples0001-0048/10473-AS-0002b_S1_L005_R1_001.fastq.gz", "/data/jbrown_lab/2023/20231006_Freiberg_10473_methylation/poolA_samples0001-0048/10473-AS-0002b_S1_L005_R2_001.fastq.gz" ],
    "B1" => [ "/data/jbrown_lab/2023/20231006_Freiberg_10473_methylation/poolA_samples0001-0048/10473-AS-0009b_S1_L005_R1_001.fastq.gz", "/data/jbrown_lab/2023/20231006_Freiberg_10473_methylation/poolA_samples0001-0048/10473-AS-0009b_S1_L005_R2_001.fastq.gz" ],
    "B2" => [ "/data/jbrown_lab/2023/20231006_Freiberg_10473_methylation/poolA_samples0001-0048/10473-AS-0010b_S1_L005_R1_001.fastq.gz", "/data/jbrown_lab/2023/20231006_Freiberg_10473_methylation/poolA_samples0001-0048/10473-AS-0010b_S1_L005_R2_001.fastq.gz" ],
  },

  is_paired_end => 1,
  generate_md5 => 1,
  perform_fastqc => 0,
  perform_paired_end_validation => 0,
};

my $config = performPreprocessing($def, 1);

1;
