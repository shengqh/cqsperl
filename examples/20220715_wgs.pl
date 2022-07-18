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

my $mem = "10gb"; # for test only, suggest to 80G for real project
my $aligner_scatter_count = 2; # for test only, suggest to 50 for real project

my $def = {
  task_name => "wgs_cost",
  email => "quanhu.sheng.1\@vumc.org",
  "email-type" => "FAIL",
  target_dir => "/scratch/cqs/shengq2/temp/20220715_wgs_mm10",

  bwa_option => "-K 100000000 -v 3",
  max_thread => 8,
  aligner_scatter_count => $aligner_scatter_count,
  bwa_walltime => 48,
  bwa_memory => $mem,
  mark_duplicates_memory => $mem,

  perform_gvcf_to_genotype => 0,
  perform_filter_and_merge => 0,

  files => {
    'S1_L1' => [ '/gpfs23/scratch/cqs/shengq2/dnaseq/example_data/S1_L1_1.fq.gz', '/gpfs23/scratch/cqs/shengq2/dnaseq/example_data/S1_L1_2.fq.gz' ],
    'S1_L2' => [ '/gpfs23/scratch/cqs/shengq2/dnaseq/example_data/S1_L2_1.fq.gz', '/gpfs23/scratch/cqs/shengq2/dnaseq/example_data/S1_L2_2.fq.gz' ],
  },
};

#performWholeGenomeSeq_gatk_hg38($def);
performWholeGenomeSeq_gencode_mm10($def);

1;

