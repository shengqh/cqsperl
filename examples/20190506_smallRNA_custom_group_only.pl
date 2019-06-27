#!/usr/bin/perl
use strict;
use warnings;
use CQS::PerformSmallRNA4;
use CQS::ClassFactory;

my $def = {

  #General options
  task_name  => "2868",
  email      => "quanhu.sheng.1\@vumc.org",
  target_dir => "/scratch/cqs/shengq2/temp/20190506_smallRNA_human_customonly",
  cqstools   => "/home/shengq2/cqstools/cqstools.exe",
  max_thread => 8,

  #preprocessing
  fastq_remove_N      => 1,
  remove_sequences    => "'CCACGTTCCCGTGG;ACAGTCCGACGATC'",
  min_read_length     => 16,
  run_cutadapt        => 1,
  adapter             => "TGGAATTCTCGGGTGCCAAGG",
  fastq_remove_random => 0,                                   #set 0 for TrueSeq, set 4 for nextflex

  #custom group
  search_nonhost_genome_custom_group_only => 1,
  bowtie1_custom_group_index         => "/scratch/cqs/zhaos/vickers/reference/bacteria/group5/bowtie_index_1.1.2/bacteriaDatabaseGroup5",
  custom_group_species_map           => "/scratch/cqs/zhaos/vickers/reference/bacteria/group5/20170425_Group5SpeciesAll.species.map",
  nonhost_genome_custom_group_name   => "Custom",

  #deseq2
  DE_pvalue                   => 0.05,
  DE_fold_change              => 1.5,
  DE_use_raw_pvalue           => 1,

  DE_library_key => "TotalReads",

  #Data
  files => {
    "B001" => ["/scratch/cqs/guoy1/2868/2868-CMS-251_1_sequence.txt.gz"],
    "B002" => ["/scratch/cqs/guoy1/2868/2868-CMS-82_1_sequence.txt.gz"],
    "B003" => ["/scratch/cqs/guoy1/2868/2868-CMS-83_1_sequence.txt.gz"],
    "D001" => ["/scratch/cqs/guoy1/2868/2868-CMS-170_1_sequence.txt.gz"],
    "D002" => ["/scratch/cqs/guoy1/2868/2868-CMS-70_1_sequence.txt.gz"],
    "D003" => ["/scratch/cqs/guoy1/2868/2868-CMS-98_1_sequence.txt.gz"],
  },
  groups => {
    B => [
      "B001", "B002", "B003"
    ],
    D => [
      "D001", "D002", "D003"
    ],
  },
  pairs => {
    B_vs_D => {
      groups => [ "D", "B" ],
    },
  },
};

my $config = performSmallRNA_hg19( $def, 1 );

1;

