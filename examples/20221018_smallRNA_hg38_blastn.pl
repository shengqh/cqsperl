#!/usr/bin/perl
use strict;
use warnings;

use CQS::PerformSmallRNA;
use CQS::ClassFactory;

my $def = {

	#General options
	task_name => "6092_ES_ARMseq",
	email     => "quanhu.sheng.1\@vumc.org",
	emailType => "FAIL",
	target_dir =>"/data/cqs/shengq2/temp/20221018_smallRNA_hg38_blastn",
  max_thread => 8,
  is_paired_end => 0,

  #Default software parameter (don't change it except you really know it)
  remove_sequences => "",
  #next flex
  fastq_remove_random => 0,
   
  blast_top_reads => 1,
  search_host_genome => 0,
  search_nonhost_genome => 0,
  search_nonhost_library => 0,
  search_refseq_genome => 0,

	#Data
  files => {
    "HDL_96_AlkB" => ["/data/cqs/example_data/smallrnaseq/6092-ES-3_S1_L005_R1_001.fastq.gz"],
    "HDL_97_AlkB" => ["/data/cqs/example_data/smallrnaseq/6092-ES-4_S1_L005_R1_001.fastq.gz"],
    "HDL_98_AlkB" => ["/data/cqs/example_data/smallrnaseq/6092-ES-5_S1_L005_R1_001.fastq.gz"],
    "HDL_96_Unt" => ["/data/cqs/example_data/smallrnaseq/6092-ES-13_S1_L005_R1_001.fastq.gz"],
    "HDL_97_Unt" => ["/data/cqs/example_data/smallrnaseq/6092-ES-14_S1_L005_R1_001.fastq.gz"],
    "HDL_98_Unt" => ["/data/cqs/example_data/smallrnaseq/6092-ES-15_S1_L005_R1_001.fastq.gz"],
  },
};

my $config = performSmallRNA_hg38( $def, 1 );

1;

