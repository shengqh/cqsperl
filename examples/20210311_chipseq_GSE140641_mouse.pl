#!/usr/bin/perl
use strict;
use warnings;

use CQS::ClassFactory;
use CQS::FileUtils;
use Data::Dumper;
use CQS::PerformChIPSeq;

my $def = {
  task_name  => "GSE140641",
  email      => "quanhu.sheng.1\@vumc.org",
  target_dir => create_directory_or_die("/scratch/cqs/shengq2/test/20200715_chipseq_GSE140641_mouse"),

  sra_to_fastq => 1,
  is_restricted_data => 0,
  is_paired_end    => 0,

  #add_folder_index => 1,

  perform_cutadapt => 0,
  adapter          => "AGATCGGAAGAGCACACGTCTGAACTCCAGTCAC",    #trueseq adapter
  min_read_length  => 30,

  #mapping
  aligner       => "bowtie2",

  #peak calling
  peak_caller => "macs",

  files => {
    H3K27ac_activated => ["GSM4176113"],
    input => ["GSM4176111"],
  },
  treatments => {
    H3K27ac_activated => ["H3K27ac_activated"],
  },
  controls => {
    H3K27ac_activated => ["input"],
  },
  perform_chipqc     => 1,

  perform_report => 1,
  perform_activeGene => 0,
};

my $config = performChIPSeq_gencode_mm10($def, 1);
#performTask($config, "report");

1;
