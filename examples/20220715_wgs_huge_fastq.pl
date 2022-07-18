#!/usr/bin/perl
use strict;
use warnings;

use CQS::FileUtils;
use CQS::SystemUtils;
use CQS::ConfigUtils;
use CQS::ClassFactory;
use Pipeline::Preprocession;
use Pipeline::PipelineUtils;
use CQS::PerformWholeGenomeSeq;
use Data::Dumper;

my $def = {
  task_name => "test",
  email => "quanhu.sheng.1\@vumc.org",
  "email-type" => "FAIL",
  target_dir => "/scratch/cqs/shengq2/temp/20220715_wgs_hg38_huge_fastq",

  bwa_option => "-K 100000000 -v 3",
  max_thread => 8,
  bwa_walltime => 24, 
  bwa_memory => "40gb", 
  mark_duplicates_memory => "80gb",

  #once you get all gvcf file, you can set those triggers to 1
  perform_gvcf_to_genotype => 0,
  perform_filter_and_merge => 0,

  files => {
    'S1_L1' => [ '/gpfs23/scratch/cqs/shengq2/dnaseq/example_data/S1_L1_1.fq.gz', '/gpfs23/scratch/cqs/shengq2/dnaseq/example_data/S1_L1_2.fq.gz' ],
    'S1_L2' => [ '/gpfs23/scratch/cqs/shengq2/dnaseq/example_data/S1_L2_1.fq.gz', '/gpfs23/scratch/cqs/shengq2/dnaseq/example_data/S1_L2_2.fq.gz' ],
  },

  perform_split_fastq => "by_scatter",
  aligner_scatter_count => 10, # based on your fastq file size, suggest to cut to about 5G per sample.

  is_paired_end => 1,

  perform_paired_end_validation => 1,

  use_tmp_folder => 1,#for normal task, we want to copy source file to computer node to avoid the struggle of /scratch storege
  use_tmp_folder_fastqc => 0, #we don't want to copy all files to compute node for fastqQC as default
  use_tmp_folder_paired_end_validation => 0, #we don't want to copy all files to compute node for paired end validation as default
};

my $config = performWholeGenomeSeq_gatk_hg38($def, 1);

1;

