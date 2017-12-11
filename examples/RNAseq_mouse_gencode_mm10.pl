#!/usr/bin/perl
use strict;
use warnings;

use CQS::ClassFactory;
use CQS::FileUtils;
use CQS::SystemUtils;
use CQS::ConfigUtils;
use CQS::PerformRNAseq;

my $def = {

  #define task name, this name will be used as prefix of a few result, such as read count table file name.
  task_name => "RNAseq_mouse",

  #email which will be used for notification if you run through cluster
  email => "quanhu.sheng.1\@vanderbilt.edu",

  #target dir which will be automatically created and used to save code and result
  target_dir => "/scratch/cqs/shengq2/temp/RNAseq_mouse",

  #source files
  files => {
    "729_AF_7" =>
      [ "/scratch/VANGARD/20171127_Dylan_RNA_Seq_human_cell/project1/729-AF-7_S43_R1_001.fastq.gz", "/scratch/VANGARD/20171127_Dylan_RNA_Seq_human_cell/project1/729-AF-7_S43_R2_001.fastq.gz" ],
    "729_AF_8" =>
      [ "/scratch/VANGARD/20171127_Dylan_RNA_Seq_human_cell/project1/729-AF-8_S44_R1_001.fastq.gz", "/scratch/VANGARD/20171127_Dylan_RNA_Seq_human_cell/project1/729-AF-8_S44_R2_001.fastq.gz" ],
  },

  #group information for visualization and comparison
  groups => {
    "group1" => ["729_AF_7"],
    "group2" => ["729_AF_8"],
  },

  #Comparison information, in each comparison, the first one is control. For example, in comparison "DMSO_vs_FED", "FED" is control.
  pairs => {
    "group2_vs_group1" => [ "group1", "group2" ],
  },
};

performRNASeq_gencode_mm10($def);

1;
