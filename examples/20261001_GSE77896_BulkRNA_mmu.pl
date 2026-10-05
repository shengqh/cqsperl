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
  task_name => "GSE77896_bulkRNA",

  #email which will be used for notification if you run through cluster
  email => "quanhu.sheng.1\@vumc.org",

  #target dir which will be automatically created and used to save code and result
  target_dir => create_directory_or_die("/nobackup/h_cqs/shengq2/test/20261001_GSE77896_BulkRNA_mmu"),

  #source files
  files => {
    "Control_1" => ["GSM2061062"],
  },

  is_paired_end    => 0,
  
  sra_to_fastq           => 1,
  sra_to_fastq_prefetch  => 1,
  sra_to_fastq_sh_direct => 0,
  is_restricted_data     => 0,

  perform_cutadapt => 1,
  cutadapt_option  => "-q 20 -a AGATCGGAAGAGC",
  min_read_length  => 30,

  groups_pattern => "(.+)_",

  #pairs          => {
  #  "Pdx1_vs_Control" => ["Control", "Pdx1_het"],
  #  "Oc1_vs_Control" => ["Control", "Oc1_het"],
  #  "Pdx1_Oc1_vs_Control" => ["Control", "Pdx1_Oc1_dblhet"],
  #  "Pdx1_Oc1_vs_Pdx1" => ["Pdx1_het", "Pdx1_Oc1_dblhet"],
  #  "Pdx1_Oc1_vs_Oc1" => ["Oc1_het", "Pdx1_Oc1_dblhet"],
  #},
  #sratools_docker_command => 'singularity exec -c -e -B /v5000,/panfs,/data,/dors,/nobackup,/tmp,/home/ramirm8 -H `pwd`  /data/cqs/softwares/singularity/sra-tools.3.3.0.sif ',

};

my $config = performRNASeq_gencode_mm10( $def, 0 );
performTask($config, "sra2fastq");

1;
