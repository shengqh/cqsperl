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
  task_name => "rnaseq_2392_human",

  #email which will be used for notification if you run through cluster
  email => "quanhu.sheng.1\@vumc.org",

  #target dir which will be automatically created and used to save code and result
  target_dir => "/nobackup/h_cqs/shengq2/temp/20261001_GSE_rnaseq_hg38",

  #source files
  files => {
    "adult_aorta_cell_3"     => ["GSM3580599"],
    "adult_aorta_cell_2"     => ["GSM3580600"],
    "adult_aorta_cell_1"     => ["GSM3580601"],
    "adult_aorta_cell_4"     => ["GSM3580602"],
    "term_myometrial_cell_1" => ["GSM3580624"],
    "term_myometrial_cell_5" => ["GSM3580625"],
    "term_myometrial_cell_3" => ["GSM3580626"],
    "term_myometrial_cell_4" => ["GSM3580627"],
    "term_myometrial_cell_2" => ["GSM3580628"],
    "term_tissue_4"          => ["GSM3580629"],
    "term_tissue_5"          => ["GSM3580630"],
    "term_tissue_3"          => ["GSM3580631"],
    "term_tissue_1"          => ["GSM3580632"],
    "term_tissue_2"          => ["GSM3580633"],
  },

  sra_to_fastq           => 1,
  sra_to_fastq_prefetch  => 1,
  sra_to_fastq_sh_direct => 0,
  is_restricted_data     => 0,

  perform_cutadapt => 1,
  cutadapt_option  => "-q 20 -a AGATCGGAAGAGC -A AGATCGGAAGAGC",
  is_paired_end    => 1,
  min_read_length  => 30,

  groups_pattern => "(.+)_",
  _pairs         => {
    "adult_aorta_cell_vs_term_myometrial_cell" => [ "adult_aorta_cell", "term_myometrial_cell" ],
    "adult_aorta_cell_vs_term_tissue"          => [ "adult_aorta_cell", "term_tissue" ],
  },

  DE_fold_change => 2,
  DE_pvalue      => 0.01,
};

my $config = performRNASeq_gencode_hg38( $def, 1 );

1;
