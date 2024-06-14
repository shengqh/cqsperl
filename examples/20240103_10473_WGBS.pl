#!/usr/bin/perl
use strict;
use warnings;
use CQS::Global;
use CQS::FileUtils;
use CQS::SystemUtils;
use CQS::ConfigUtils;
use CQS::ClassFactory;
use CQS::PerformWGBS;
use File::Basename;

use Hash::Merge qw( merge );

my $def = {
  task_name           => "P10473",
  email               => "lk.stolze\@vumc.org",
  emailType           => "FAIL",
  target_dir          => "/nobackup/brown_lab/projects/20231214_10473_Methylation_hg38/",

  files => {
    'TC003_V1_Control' => ['/data/jbrown_lab/2023/20231006_Freiberg_10473_methylation/poolA_samples0001-0048/10473-AS-0001b_S1_L005_R1_001.fastq.gz', '/data/jbrown_lab/2023/20231006_Freiberg_10473_methylation/poolA_samples0001-0048/10473-AS-0001b_S1_L005_R2_001.fastq.gz' ],
    'TC002_V1_Control' => ['/data/jbrown_lab/2023/20231006_Freiberg_10473_methylation/poolA_samples0001-0048/10473-AS-0002b_S1_L005_R1_001.fastq.gz', '/data/jbrown_lab/2023/20231006_Freiberg_10473_methylation/poolA_samples0001-0048/10473-AS-0002b_S1_L005_R2_001.fastq.gz' ],
    'TE012_V1_PAD' => ['/data/jbrown_lab/2023/20231006_Freiberg_10473_methylation/poolA_samples0001-0048/10473-AS-0010b_S1_L005_R1_001.fastq.gz', '/data/jbrown_lab/2023/20231006_Freiberg_10473_methylation/poolA_samples0001-0048/10473-AS-0010b_S1_L005_R2_001.fastq.gz' ],
    'TP004_V1_PAD' => ['/data/jbrown_lab/2023/20231006_Freiberg_10473_methylation/poolA_samples0001-0048/10473-AS-0012b_S1_L005_R1_001.fastq.gz', '/data/jbrown_lab/2023/20231006_Freiberg_10473_methylation/poolA_samples0001-0048/10473-AS-0012b_S1_L005_R2_001.fastq.gz' ],
    'T1095_024_CLTI' => ['/data/jbrown_lab/2023/20231006_Freiberg_10473_methylation/poolB_samples0049-0068_0150-0178/10473-AS-0161b_S1_L005_R1_001.fastq.gz', '/data/jbrown_lab/2023/20231006_Freiberg_10473_methylation/poolB_samples0049-0068_0150-0178/10473-AS-0161b_S1_L005_R2_001.fastq.gz' ],
    'T1238_045_CLTI' => ['/data/jbrown_lab/2023/20231006_Freiberg_10473_methylation/poolB_samples0049-0068_0150-0178/10473-AS-0162b_S1_L005_R1_001.fastq.gz', '/data/jbrown_lab/2023/20231006_Freiberg_10473_methylation/poolB_samples0049-0068_0150-0178/10473-AS-0162b_S1_L005_R2_001.fastq.gz' ],
  },

  generate_md5 => 1,

  mds_legendPos => "topleft",
 
  #group definition
  groups_pattern => ".+_(.+)",

  control_group => "Control",

  #comparison
  pairs => {
    #control first, then treatment
    "PAD_vs_Control" => [ 'Control', 'PAD' ],
    "CLTI_vs_Control" => [ 'Control', 'CLTI' ],
  },

  methylDiff_difference => 25,
  methylDiff_qvalue => 0.01,

  #trim adapter
  perform_cutadapt => 1,
  adapter => "AGATCGGAAGAGC",
  min_read_length => 30,
  trim_polyA => 1,

  interval_list => "/nobackup/h_cqs/shengq2/program/collaborations/jonathan_brown/20231113_10473_DNAMethyl_hg38/covered_targets_Twist_Methylome_hg38_annotated_collapsed.intervals",
  #meta_file => "/data/cqs/shengq2/program/cqsperl/examples/20231027_10473_WGBS_real.meta.tsv",
  #use_tmp_folder => 1,

  add_folder_index => 0,  
  abismal_walltime => "48",
  perform_fastqc => 1,
  perform_paired_end_validation => 1,
};

my $config = performWGBS_gencode_hg38($def);

1;