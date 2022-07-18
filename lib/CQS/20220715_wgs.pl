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

my $def = {
  task_name => "wgs_cost",
  email => "quanhu.sheng.1\@vumc.org",
  "email-type" => "FAIL",
  target_dir => "/scratch/cqs/shengq2/dnaseq/20201023_wgs_cost_pipeline",

  bwa_option => "-K 100000000 -v 3",
  max_thread => 8,
  #aligner_scatter_count => 50,
  bwa_walltime => 48,
  bwa_memory => "80gb",
  mark_duplicates_memory => "80gb",

  perform_gvcf_to_genotype => 0,
  perform_filter_and_merge => 0,

  files => {
    'S1_L1' => [ '/gpfs23/scratch/cqs/shengq2/dnaseq/example_data/S1_L1_1.fq.gz', '/gpfs23/scratch/cqs/shengq2/dnaseq/example_data/S1_L1_2.fq.gz' ],
    'S1_L2' => [ '/gpfs23/scratch/cqs/shengq2/dnaseq/example_data/S1_L2_1.fq.gz', '/gpfs23/scratch/cqs/shengq2/dnaseq/example_data/S1_L2_2.fq.gz' ],
  },
};

performWholeGenomeSeq_gatk_hg38($def);

1;

