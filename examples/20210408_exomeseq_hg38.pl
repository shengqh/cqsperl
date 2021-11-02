#!/usr/bin/perl
use strict;
use warnings;

use CQS::FileUtils;
use CQS::SystemUtils;
use CQS::ConfigUtils;
use CQS::ClassFactory;
use CQS::PerformExomeSeq;

my $def = {
  task_name => "exomeseq_hg38",

  target_dir => "/scratch/cqs/shengq2/temp/exomeseq_hg38",
  email      => "quanhu.sheng.1\@vumc.org",
  files      => {
    'S1' => [ '/data/cqs/example_data/exomeseq/S1-AGTGTTGC-ATGTAACG_S329_R2_001.fastq.gz', '/data/cqs/example_data/exomeseq/S1-AGTGTTGC-ATGTAACG_S329_R1_001.fastq.gz' ],
    'S2' => [ '/data/cqs/example_data/exomeseq/S2-TTACCTGG-GATTCTGA_S330_R1_001.fastq.gz', '/data/cqs/example_data/exomeseq/S2-TTACCTGG-GATTCTGA_S330_R2_001.fastq.gz' ],
    'S3' => [ '/data/cqs/example_data/exomeseq/S3-TCTATCCT-GAGAGGTT_S331_R1_001.fastq.gz', '/data/cqs/example_data/exomeseq/S3-TCTATCCT-GAGAGGTT_S331_R2_001.fastq.gz' ],
    'S4' => [ '/data/cqs/example_data/exomeseq/S4-TTCTACAT-TTGTATCA_S332_R1_001.fastq.gz', '/data/cqs/example_data/exomeseq/S4-TTCTACAT-TTGTATCA_S332_R2_001.fastq.gz' ],
  },
  merge_fastq => 0,

  is_paired_end    => 1,
  perform_cutadapt => 0,
  cutadapt_option  => "-n 2 -O 1 -q 20 -a AGATCGGAAGAGCACACGTC -A AGATCGGAAGAGCGTCGTGT",
  min_read_length  => 30,

  covered_bed                 => "/scratch/cqs_share/references/exomeseq/Twist/Twist_Exome_Target_hg38.slop50.bed",

  perform_gatk_callvariants   => 1,
  gatk_callvariants_vqsr_mode => 1,

  filter_variants_by_allele_frequency            => 1,
  filter_variants_by_allele_frequency_percentage => 0.9,
  filter_variants_by_allele_frequency_maf        => 0.3,

  #annotation_genes            => "LDLR APOB PCSK9 LDLRAP1 STAP1 LIPA ABCG5 ABCGB APOE LPA PNPLA5 CH25H INSIG2 SIRT1",

  perform_cnv_gatk4_cohort => 1,

  perform_vep        => 0,
  perform_cnv_cnMOPs => 0,
  cnv_xhmm_preprocess_intervals => 0,
  perform_cnv_xhmm              => 0,

  use_tmp_folder => 1,
};

my $config = performExomeSeq_gatk_hg38( $def, 1 );
1;

