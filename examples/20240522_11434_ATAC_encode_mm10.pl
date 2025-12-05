#!/usr/bin/perl
use strict;
use warnings;

use CQS::ClassFactory;
use CQS::FileUtils;
use CQS::PerformEncodeATACSeq;

my $def = {
  email => "quanhu.sheng.1\@vumc.org",
  emailType => "FAIL",
  is_paired => 1,
  task_name => "Phoebe-ATACseq",
  target_dir => "/nobackup/h_cqs/shengq2/temp/ENCODE-pipeline",

  perform_cutadapt => 1,
  min_read_length => 30,
  #adapter => "AGATCGGAAGAGC", #Illumina
#  adapter => "CTGTCTCTTATA", #Nextera
  #adapter => "TGGAATTCTCGG", #smallRNA
#  cutadapt_option => "-q 20",
  cutadapt_option  => "-O 1 -n 3 -q 20 -a CTGTCTCTTATACACATCT -A AGATGTGTATAAGAGACAG",
  trim_polyA => 1,

  files => {
    "WT-US_1"        => ["/nobackup/h_vangard_1/wangj52/Brent/Phoebe-ATACseq/fastq/13622-PN-0001_01_S1_L005_R1_001.fastq.gz","/nobackup/h_vangard_1/wangj52/Brent/Phoebe-ATACseq/fastq/13622-PN-0001_01_S1_L005_R2_001.fastq.gz"],
    "WT-US_2"        => ["/nobackup/h_vangard_1/wangj52/Brent/Phoebe-ATACseq/fastq/13622-PN-0001_02_S1_L005_R1_001.fastq.gz","/nobackup/h_vangard_1/wangj52/Brent/Phoebe-ATACseq/fastq/13622-PN-0001_02_S1_L005_R2_001.fastq.gz"],
    "WT-US_3"        => ["/nobackup/h_vangard_1/wangj52/Brent/Phoebe-ATACseq/fastq/13622-PN-0001_03_S1_L005_R1_001.fastq.gz","/nobackup/h_vangard_1/wangj52/Brent/Phoebe-ATACseq/fastq/13622-PN-0001_03_S1_L005_R2_001.fastq.gz"],
    "KO-US_1"        => ["/nobackup/h_vangard_1/wangj52/Brent/Phoebe-ATACseq/fastq/13622-PN-0001_04_S1_L005_R1_001.fastq.gz","/nobackup/h_vangard_1/wangj52/Brent/Phoebe-ATACseq/fastq/13622-PN-0001_04_S1_L005_R2_001.fastq.gz"],
    "KO-US_2"        => ["/nobackup/h_vangard_1/wangj52/Brent/Phoebe-ATACseq/fastq/13622-PN-0001_05_S1_L005_R1_001.fastq.gz","/nobackup/h_vangard_1/wangj52/Brent/Phoebe-ATACseq/fastq/13622-PN-0001_05_S1_L005_R2_001.fastq.gz"],
    "KO-US_3"        => ["/nobackup/h_vangard_1/wangj52/Brent/Phoebe-ATACseq/fastq/13622-PN-0001_06_S1_L005_R1_001.fastq.gz","/nobackup/h_vangard_1/wangj52/Brent/Phoebe-ATACseq/fastq/13622-PN-0001_06_S1_L005_R2_001.fastq.gz"],
    "WT-30_1"        => ["/nobackup/h_vangard_1/wangj52/Brent/Phoebe-ATACseq/fastq/13622-PN-0001_07_S1_L005_R1_001.fastq.gz","/nobackup/h_vangard_1/wangj52/Brent/Phoebe-ATACseq/fastq/13622-PN-0001_07_S1_L005_R2_001.fastq.gz"],
    "WT-30_2"        => ["/nobackup/h_vangard_1/wangj52/Brent/Phoebe-ATACseq/fastq/13622-PN-0001_08_S1_L005_R1_001.fastq.gz","/nobackup/h_vangard_1/wangj52/Brent/Phoebe-ATACseq/fastq/13622-PN-0001_08_S1_L005_R2_001.fastq.gz"],
    "WT-30_3"        => ["/nobackup/h_vangard_1/wangj52/Brent/Phoebe-ATACseq/fastq/13622-PN-0001_09_S1_L005_R1_001.fastq.gz","/nobackup/h_vangard_1/wangj52/Brent/Phoebe-ATACseq/fastq/13622-PN-0001_09_S1_L005_R2_001.fastq.gz"],
    "KO-30_1"        => ["/nobackup/h_vangard_1/wangj52/Brent/Phoebe-ATACseq/fastq/13622-PN-0001_10_S1_L005_R1_001.fastq.gz","/nobackup/h_vangard_1/wangj52/Brent/Phoebe-ATACseq/fastq/13622-PN-0001_10_S1_L005_R2_001.fastq.gz"],
    "KO-30_2"        => ["/nobackup/h_vangard_1/wangj52/Brent/Phoebe-ATACseq/fastq/13622-PN-0001_11_S1_L005_R1_001.fastq.gz","/nobackup/h_vangard_1/wangj52/Brent/Phoebe-ATACseq/fastq/13622-PN-0001_11_S1_L005_R2_001.fastq.gz"],
    "KO-30_3"        => ["/nobackup/h_vangard_1/wangj52/Brent/Phoebe-ATACseq/fastq/13622-PN-0001_12_S1_L005_R1_001.fastq.gz","/nobackup/h_vangard_1/wangj52/Brent/Phoebe-ATACseq/fastq/13622-PN-0001_12_S1_L005_R2_001.fastq.gz"],
    "WT-60_1"        => ["/nobackup/h_vangard_1/wangj52/Brent/Phoebe-ATACseq/fastq/13622-PN-0001_13_S1_L005_R1_001.fastq.gz","/nobackup/h_vangard_1/wangj52/Brent/Phoebe-ATACseq/fastq/13622-PN-0001_13_S1_L005_R2_001.fastq.gz"],
    "WT-60_2"        => ["/nobackup/h_vangard_1/wangj52/Brent/Phoebe-ATACseq/fastq/13622-PN-0001_14_S1_L005_R1_001.fastq.gz","/nobackup/h_vangard_1/wangj52/Brent/Phoebe-ATACseq/fastq/13622-PN-0001_14_S1_L005_R2_001.fastq.gz"],
    "WT-60_3"        => ["/nobackup/h_vangard_1/wangj52/Brent/Phoebe-ATACseq/fastq/13622-PN-0001_15_S1_L005_R1_001.fastq.gz","/nobackup/h_vangard_1/wangj52/Brent/Phoebe-ATACseq/fastq/13622-PN-0001_15_S1_L005_R2_001.fastq.gz"],
    "KO-60_1"        => ["/nobackup/h_vangard_1/wangj52/Brent/Phoebe-ATACseq/fastq/13622-PN-0001_16_S1_L005_R1_001.fastq.gz","/nobackup/h_vangard_1/wangj52/Brent/Phoebe-ATACseq/fastq/13622-PN-0001_16_S1_L005_R2_001.fastq.gz"],
    "KO-60_2"        => ["/nobackup/h_vangard_1/wangj52/Brent/Phoebe-ATACseq/fastq/13622-PN-0001_17_S1_L005_R1_001.fastq.gz","/nobackup/h_vangard_1/wangj52/Brent/Phoebe-ATACseq/fastq/13622-PN-0001_17_S1_L005_R2_001.fastq.gz"],
    "KO-60_3"        => ["/nobackup/h_vangard_1/wangj52/Brent/Phoebe-ATACseq/fastq/13622-PN-0001_18_S1_L005_R1_001.fastq.gz","/nobackup/h_vangard_1/wangj52/Brent/Phoebe-ATACseq/fastq/13622-PN-0001_18_S1_L005_R2_001.fastq.gz"],
  },

  groups_pattern => '(.+)_',

  #encode options
  encode_atac_walltime => "48",
  encode_atac_mem => "120G",
  caper_backend => "local", #or slurm
  perform_croo_qc => 1,
  perform_NFR_filter => 1,
  
  
  perform_diffbind        => 1,
    design_table            => {
    Tissue      => "ATACseq",
    "ATACseq" => {
    	Factor    => "ATAC",	
      "WT_US_1" => {
        Condition => "WT_US",
        Replicate => "1"
      },
      "WT_US_2" => {
        Condition => "WT_US",
        Replicate => "2"
      },
      "WT_US_3" => {
        Condition => "WT_US",
        Replicate => "3"
      },
      "KO_US_1" => {
        Condition => "KO_US",
        Replicate => "1"
      },
      "KO_US_2" => {
        Condition => "KO_US",
        Replicate => "2"
      },
      "KO_US_3" => {
        Condition => "KO_US",
        Replicate => "3"
      },
       "WT_30_1" => {
        Condition => "WT_30",
        Replicate => "1"
      },
      "WT_30_2" => {
        Condition => "WT_30",
        Replicate => "2"
      },
      "WT_30_3" => {
        Condition => "WT_30",
        Replicate => "3"
      },
      "KO_30_1" => {
        Condition => "KO_30",
        Replicate => "1"
      },
      "KO_30_2" => {
        Condition => "KO_30",
        Replicate => "2"
      },
      "KO_30_3" => {
        Condition => "KO_30",
        Replicate => "3"
      },
      "WT_60_1" => {
        Condition => "WT_60",
        Replicate => "1"
      },
      "WT_60_2" => {
        Condition => "WT_60",
        Replicate => "2"
      },
      "WT_60_3" => {
        Condition => "WT_60",
        Replicate => "3"
      },
      "KO_60_1" => {
        Condition => "KO_60",
        Replicate => "1"
      },
      "KO_60_2" => {
        Condition => "KO_60",
        Replicate => "2"
      },
      "KO_60_3" => {
        Condition => "KO_60",
        Replicate => "3"
      },

      "Comparison" => [
         [ "KO_vs_WT_US", "WT_US", "KO_US" ],
         [ "KO_vs_WT_30", "WT_30", "KO_30" ],
         [ "KO_vs_WT_60", "WT_60", "KO_60" ],
         [ "T30_vs_US_KO", "KO_US", "KO_30" ],
         [ "T60_vs_US_KO", "KO_US", "KO_60" ],
         [ "T30_vs_US_WT", "WT_US", "WT_30" ],
         [ "T60_vs_US_WT", "WT_US", "WT_60" ],
       ],
      "MinOverlap" => {
         "WT_US" => 2,
         "KO_US" => 2,
         "WT_30" => 2,
         "KO_30" => 2,
         "WT_60" => 2,
         "KO_60" => 2,
      },
      
    },
  },

};

my $config = PerformEncodeATACSeq_gencode_mm10($def, 1);

1;
