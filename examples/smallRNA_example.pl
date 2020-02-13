#!/usr/bin/perl
use strict;
use warnings;
use CQS::PerformSmallRNA;
use CQS::ClassFactory;

my $def = {

  #General options
  task_name  => "smallRNA_example",
  email      => "quanhu.sheng.1\@vumc.org",
  emailType => 'FAIL',
  target_dir => "/scratch/cqs/shengq2/temp/smallRNA_example_v5",
  max_thread => 8,

  #Default software parameter (don't change it except you really know it)
  remove_sequences => "'CCACGTTCCCGTGG;ACAGTCCGACGATC'",

  #next flex
  fastq_remove_random => 4,

  #Data
  files => {
    "SC030" => ["/data/stein_lab/mjo_sRNA_data/rawdata_20200114_4385/4385-QW-1-1-TTAGGC_S1_R1_001.fastq.gz"],
    "SR021" => ["/data/stein_lab/mjo_sRNA_data/rawdata_20200114_4385/4385-QW-1-2-TGACCA_S2_R1_001.fastq.gz"],
    "SR023" => ["/data/stein_lab/mjo_sRNA_data/rawdata_20200114_4385/4385-QW-1-3-ACAGTG_S3_R1_001.fastq.gz"],
    "SR028" => ["/data/stein_lab/mjo_sRNA_data/rawdata_20200114_4385/4385-QW-1-4-GCCAAT_S4_R1_001.fastq.gz"],
  },
  
  search_not_identical => 0,
  perform_report => 1,
};

performSmallRNA_hg19( $def, 1 );
#performSmallRNA_hg38( $def, 1 );
#performSmallRNA_mm19( $def, 1 );
#performSmallRNA_rn6( $def, 1 );

1;

