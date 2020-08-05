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
    "Normal_06-18798" => ["/data/cqs/ramirema/ciombor_kristen_data/Plate_1_2/2585-KL-122-GCAATATT-GACTGAGT_S68_R1_001.fastq.gz", "/data/cqs/ramirema/ciombor_kristen_data/Plate_1_2/2585-KL-122-GCAATATT-GACTGAGT_S68_R2_001.fastq.gz"],
    "Tumor_06-18798" => ["/data/cqs/ramirema/ciombor_kristen_data/Plate_1_2/2585-KL-30-CCGGTTCC-TCCATTGC_S1_L001_R1.fastq.gz", "/data/cqs/ramirema/ciombor_kristen_data/Plate_1_2/2585-KL-30-CCGGTTCC-TCCATTGC_S1_L001_R2.fastq.gz"],
  },

  groups => {
    "ID_06-18798" => ["Normal_06-18798", "Tumor_06-18798"],
  },

  perform_IBS => 1,

};

my $config = performExomeSeq_gatk_hg38( $def, 1 );

1;
