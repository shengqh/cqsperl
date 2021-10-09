#!/usr/bin/perl

use strict;
use warnings;

use CQS::FileUtils;
use CQS::SystemUtils;
use CQS::ConfigUtils;
use CQS::ClassFactory;
use CQS::PerformExomeSeq;

my $def = {
  task_name  => "Ciombor_ExomeSeq",
  target_dir => create_directory_or_die("/scratch/cqs/shengq2/test/20190610_Ciombior_ExomeSeq"),
  email      => "quanhu.sheng.1\@vumc.org",
  emailType => 'FAIL',

  perform_gatk4_pairedfastq2bam => 1,

  perform_gatk4_callvariants  => 0,
  gatk4_variant_filter_by_chromosome => 1,
  perform_gatk_callvariants   => 0,
  perform_muTect => 0,
  muTect_option       => "--min_qscore 20 --filter_reads_with_N_cigar",

  perform_muTect2 => 1,
  perform_cnv_gatk4_cohort => 0,

  covered_bed  => "/scratch/cqs_share/references/exomeseq/IDT/Exome-IDT-xGen-hg19-v1-slop50-nochr.bed",

  files => {
    "CW_67_WT" => ["/data/cqs/jennifer_pietenpol/20190905_3772_dedup/P_67B.dedup.1.fastq.gz", "/data/cqs/jennifer_pietenpol/20190905_3772_dedup/P_67B.dedup.2.fastq.gz"],
    'CW_67_Tumor' => [ '/data/cqs/pietenpol_lab/20210506_6213_LR_exomeseq_human/6213-LR-2_S1_L005_R1_001.fastq.gz', '/data/cqs/pietenpol_lab/20210506_6213_LR_exomeseq_human/6213-LR-2_S1_L005_R2_001.fastq.gz' ],
  },

  groups => {
    "CW_67" => ["CW_67_WT", "CW_67_Tumor"],
  },

  perform_IBS => 1,

};

my $config = performExomeSeq_gatk_hg38( $def, 1 );
#performTask($config, "muTect2_07_report");

1;
