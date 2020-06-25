#!/usr/bin/perl
use strict;
use warnings;

use CQS::PerformSmallRNA;
use CQS::ClassFactory;
use CQS::FileUtils;

my $def = {

  #General options
  task_name  => "smRNA_test",
  email      => "quanhu.sheng.1\@vumc.org",
  emailType  => "FAIL",
  target_dir => "/scratch/cqs/shengq2/temp/example_smRNA",
  max_thread => 8,

  #Default software parameter (don't change it except you really know it)
  remove_sequences => "'CCACGTTCCCGTGG;ACAGTCCGACGATC'",
  #next flex
  fastq_remove_random => 4,
  #Data
  files => {
    "Cell_DKO1_1" => ["/data/cqs/liux37/JimPatton/4893_RA_1_smRNA/4893-RA-1_1_S1_L001_R1_001.fastq.gz"],
    "Cell_DKO1_2" => ["/data/cqs/liux37/JimPatton/4893_RA_1_smRNA/4893-RA-1_2_S1_L001_R1_001.fastq.gz"],
    "Cell_DKO1_3" => ["/data/cqs/liux37/JimPatton/4893_RA_1_smRNA/4893-RA-1_3_S1_L001_R1_001.fastq.gz"],
    "Cell_Mettl3_1" => ["/data/cqs/liux37/JimPatton/4893_RA_1_smRNA/4893-RA-1_4_S1_L001_R1_001.fastq.gz"],
    "Cell_Mettl3_2" => ["/data/cqs/liux37/JimPatton/4893_RA_1_smRNA/4893-RA-1_5_S1_L001_R1_001.fastq.gz"],
    "Cell_Mettl3_3"  => ["/data/cqs/liux37/JimPatton/4893_RA_1_smRNA/4893-RA-1_6_S1_L001_R1_001.fastq.gz"],
    "Cell_Alkbh_1"  => ["/data/cqs/liux37/JimPatton/4893_RA_1_smRNA/4893-RA-1_7_S1_L001_R1_001.fastq.gz"],
    "Cell_Alkbh_2"  => ["/data/cqs/liux37/JimPatton/4893_RA_1_smRNA/4893-RA-1_8_S1_L001_R1_001.fastq.gz"],
    "Cell_Alkbh_3"  => ["/data/cqs/liux37/JimPatton/4893_RA_1_smRNA/4893-RA-1_9_S1_L001_R1_001.fastq.gz"],
    "EV_DKO1_1"  => ["/data/cqs/liux37/JimPatton/4893_RA_1_smRNA/4893-RA-1_10_S1_L001_R1_001.fastq.gz"],
    "EV_DKO1_2"  => ["/data/cqs/liux37/JimPatton/4893_RA_1_smRNA/4893-RA-1_11_S1_L001_R1_001.fastq.gz"],
    "EV_DKO1_3"  => ["/data/cqs/liux37/JimPatton/4893_RA_1_smRNA/4893-RA-1_12_S1_L001_R1_001.fastq.gz"],
    "EV_Mettl3_1"  => ["/data/cqs/liux37/JimPatton/4893_RA_1_smRNA/4893-RA-1_13_S1_L001_R1_001.fastq.gz"],
    "EV_Mettl3_2"  => ["/data/cqs/liux37/JimPatton/4893_RA_1_smRNA/4893-RA-1_14_S1_L001_R1_001.fastq.gz"],
    "EV_Mettl3_3"  => ["/data/cqs/liux37/JimPatton/4893_RA_1_smRNA/4893-RA-1_15_S1_L001_R1_001.fastq.gz"],
    "EV_Alkbh_1"  => ["/data/cqs/liux37/JimPatton/4893_RA_1_smRNA/4893-RA-1_16_S1_L001_R1_001.fastq.gz"],
    "EV_Alkbh_2"  => ["/data/cqs/liux37/JimPatton/4893_RA_1_smRNA/4893-RA-1_17_S1_L001_R1_001.fastq.gz"],
    "EV_Alkbh_3"  => ["/data/cqs/liux37/JimPatton/4893_RA_1_smRNA/4893-RA-1_18_S1_L001_R1_001.fastq.gz"],
  },
  
  groups => {
    "Cell_DKO1" => ["Cell_DKO1_1", "Cell_DKO1_2", "Cell_DKO1_3"],
    "Cell_Mettl3" => ["Cell_Mettl3_1", "Cell_Mettl3_2", "Cell_Mettl3_3"],
    "Cell_Alkbh" => ["Cell_Alkbh_1", "Cell_Alkbh_2", "Cell_Alkbh_3"],
    "EV_DKO1" => ["EV_DKO1_1", "EV_DKO1_2", "EV_DKO1_3"],
    "EV_Mettl3" => ["EV_Mettl3_1", "EV_Mettl3_2", "EV_Mettl3_3"],
    "EV_Alkbh" => ["EV_Alkbh_1", "EV_Alkbh_2", "EV_Alkbh_3"],
  },
  pairs => {
    "Cell_Mettl3_vs_Cell_DKO1" => ["Cell_DKO1", "Cell_Mettl3"],
    "Cell_Alkbh_vs_Cell_DKO1" => ["Cell_DKO1", "Cell_Alkbh"],
    "EV_Mettl3_vs_EV_DKO1" => ["EV_DKO1", "EV_Mettl3"],
    "EV_Alkbh_vs_EV_DKO1" => ["EV_DKO1", "EV_Alkbh"],
  },
  
  search_not_identical => 0,
  blast_unmapped_reads => 0,
  search_refseq_genome => 0,
};

my $config = performSmallRNA_hg19($def, 1 );

1;
