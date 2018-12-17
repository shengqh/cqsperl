#!/usr/bin/perl
use strict;
use warnings;

use CQS::FileUtils;
use CQS::SystemUtils;
use CQS::ConfigUtils;
use CQS::ClassFactory;
use CQS::PerformExomeSeq;

my $def = {
  task_name => "Exomeseq_mouse_gencode_mm10",

  target_dir => "/scratch/cqs/shengq2/temp/Exomeseq_mouse_gencode_mm10",
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

  covered_bed                 => "/scratch/cqs/shengq2/references/sureselect/S0276129_Mouse_All_Exon_V1/S0276129_mm10_All_Exon_V1_M.chr.bed",
  perform_gatk_callvariants   => 1,
  gatk_callvariants_vqsr_mode => 0,

  filter_variants_by_allele_frequency            => 0,
  filter_variants_by_allele_frequency_percentage => 0.9,
  filter_variants_by_allele_frequency_maf        => 0.3,

  #annotation_genes            => "LDLR APOB PCSK9 LDLRAP1 STAP1 LIPA ABCG5 ABCGB APOE LPA PNPLA5 CH25H INSIG2 SIRT1",

  perform_vep        => 0,
};

my $config = performExomeSeq_gencode_mm10( $def, 1 );
1;

