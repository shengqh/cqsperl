#!/usr/bin/perl
use strict;
use warnings;

use CQS::FileUtils;
use CQS::SystemUtils;
use CQS::ConfigUtils;
use CQS::ClassFactory;
use CQS::PerformExomeSeq;

my $def = {
  task_name => "Exomeseq_human_gatk_b37",

  target_dir => "/scratch/cqs/shengq2/temp/Exomeseq_human_gatk_b37",
  email      => "quanhu.sheng.1\@vumc.org",
  files      => {
    "sample1" => [ "/gpfs23/scratch/cqs/pipeline_example/dnaseq_data/human/sample1_R1.fastq.gz", "/gpfs23/scratch/cqs/pipeline_example/dnaseq_data/human/sample1_R2.fastq.gz" ],
    "sample2" => [ "/gpfs23/scratch/cqs/pipeline_example/dnaseq_data/human/sample2_R1.fastq.gz", "/gpfs23/scratch/cqs/pipeline_example/dnaseq_data/human/sample2_R2.fastq.gz" ],
    "sample3" => [ "/gpfs23/scratch/cqs/pipeline_example/dnaseq_data/human/sample3_R1.fastq.gz", "/gpfs23/scratch/cqs/pipeline_example/dnaseq_data/human/sample3_R2.fastq.gz" ],
  },
  merge_fastq => 0,

  is_paired        => 1,
  perform_cutadapt => 1,
  adapter          => "AGATCGGAAGAGC",
  min_read_length  => 30,

  covered_bed                 => "/scratch/cqs/references/exomeseq/IDT/xgen-exome-research-panel-targetsae255a1532796e2eaa53ff00001c1b3c.nochr.bed",
  perform_gatk_callvariants   => 1,
  gatk_callvariants_vqsr_mode => 0,

  filter_variants_by_allele_frequency            => 0,
  filter_variants_by_allele_frequency_percentage => 0.9,
  filter_variants_by_allele_frequency_maf        => 0.3,

  #annotation_genes            => "LDLR APOB PCSK9 LDLRAP1 STAP1 LIPA ABCG5 ABCGB APOE LPA PNPLA5 CH25H INSIG2 SIRT1",

  perform_vep        => 1,

  perform_cnv_gatk4_cohort => 1,

  perform_cnv_cnMOPs => 0,
  cnv_xhmm_preprocess_intervals => 0,
  perform_cnv_xhmm              => 0,
};

my $config = performExomeSeq_gatk_b37( $def, 1 );
1;

