#!/usr/bin/perl
use strict;
use warnings;

use CQS::ClassFactory;
use CQS::FileUtils;
use CQS::PerformChIPSeq;

my $def = {
  task_name        => "Bill_April_ChIPseq_public",
  email            => "quanhu.sheng.1\@vumc.org",
  emailType        => "FAIL",
  target_dir       => create_directory_or_die("/scratch/cqs/shengq2/temp/20191213_April-ChIP_public_byDXZ"),

  sra_to_fastq => 1,
  is_restricted_data => 0,
  is_paired_end    => 0,
  add_folder_index => 1,

  #if you not very sure whether the cutadapt work or not, set perform_cutadapt_test to 1 and have a quick test
  perform_cutadapt_test => 0,

  #Nextra
  perform_cutadapt => 0,
  cutadapt_option  => "-O 1 -n 3 -q 20 -a CTGTCTCTTATA -A CTGTCTCTTATA",
  min_read_length  => 30,

  files => {
    "input"       => ["GSM1423726"],
    "MCF10A_HC20_MYC-ERVD_OHT"       => ["GSM1429415"],
    "MCF10A_HC20_MYC-ERVD_control"       => ["GSM1429416"],
  },
  treatments => {
    "MCF10A_HC20_MYC-ERVD_OHT"         => ["MCF10A_HC20_MYC-ERVD_OHT"],
    "MCF10A_HC20_MYC-ERVD_control"         => ["MCF10A_HC20_MYC-ERVD_control"],
  },
  controls => {
    "MCF10A_HC20_MYC-ERVD_OHT"         => ["input"],
    "MCF10A_HC20_MYC-ERVD_control"         => ["input"],
  },

  #mapping
  aligner => "bowtie2",

  #peak calling
  peak_caller     => "macs2",
  macs2_genome    => "hs",
  macs2_peak_type => "narrow",
  macs2_option    => "-B -q 0.05 -g hs -f BAM",

  #macs2_peak_type => "broad",
  #macs2_option => "__broad __broad_cutoff 0.1 _B _q 0.01 _g hs",
  
  perform_homer_motifs => 1,
  homer_option => "",
  homer_genome => "hg19",
  
  perform_chipqc => 1,
  perform_multiqc => 0,
};

my $config = performChIPSeq_gencode_hg19($def, 1);
#my $config = performChIPSeq_gencode_mm10($def, 1);

1;
