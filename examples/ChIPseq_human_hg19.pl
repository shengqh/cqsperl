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

  is_paired_end    => 0,
  add_folder_index => 1,

  #Nextra
  perform_cutadapt => 0,
  cutadapt_option  => "-O 1 -n 3 -q 20 -a CTGTCTCTTATA -A CTGTCTCTTATA",
  min_read_length  => 30,

  files => {
    "input"       => ["/data/h_vangard_1/daix4/April_ChIP_public_data/fastq/SRR1503340.1.fastq"],
    "MCF10A_HC20_MYC-ERVD_OHT"       => ["/data/h_vangard_1/daix4/April_ChIP_public_data/fastq/SRR1508346.1.fastq"],
    "MCF10A_HC20_MYC-ERVD_control"       => ["/data/h_vangard_1/daix4/April_ChIP_public_data/fastq/SRR1508347.1.fastq"],
    "MCF10A_HC20_MYC-ER_control"       => ["/data/h_vangard_1/daix4/April_ChIP_public_data/fastq/SRR1508348.1.fastq"],
    "MCF10A_10E2_Vector"       => ["/data/h_vangard_1/daix4/April_ChIP_public_data/fastq/SRR1508349.1.fastq"],
    "MCF10A_10E2_MYC-ERVD_OHT"       => ["/data/h_vangard_1/daix4/April_ChIP_public_data/fastq/SRR1508350.1.fastq"],
    "MCF10A_10E2_MYC-ERVD_control"       => ["/data/h_vangard_1/daix4/April_ChIP_public_data/fastq/SRR1508351.1.fastq"],
    "MCF10A_10E2_MYC-ER_OHT"       => ["/data/h_vangard_1/daix4/April_ChIP_public_data/fastq/SRR1508352.1.fastq"],
    "MCF10A_10E2_MYC-ER_control"       => ["/data/h_vangard_1/daix4/April_ChIP_public_data/fastq/SRR1508353.1.fastq"],
  },
  treatments => {
    "MCF10A_HC20_MYC-ERVD_OHT"         => ["MCF10A_HC20_MYC-ERVD_OHT"],
    "MCF10A_HC20_MYC-ERVD_control"         => ["MCF10A_HC20_MYC-ERVD_control"],
    "MCF10A_HC20_MYC-ER_control"         => ["MCF10A_HC20_MYC-ER_control"],
    "MCF10A_10E2_Vector"         => ["MCF10A_10E2_Vector"],
    "MCF10A_10E2_MYC-ERVD_OHT"         => ["MCF10A_10E2_MYC-ERVD_OHT"],
    "MCF10A_10E2_MYC-ERVD_control"         => ["MCF10A_10E2_MYC-ERVD_control"],
    "MCF10A_10E2_MYC-ER_OHT"         => ["MCF10A_10E2_MYC-ER_OHT"],
    "MCF10A_10E2_MYC-ER_control"         => ["MCF10A_10E2_MYC-ER_control"],
  },
  controls => {
    "MCF10A_HC20_MYC-ERVD_OHT"         => ["input"],
    "MCF10A_HC20_MYC-ERVD_control"         => ["input"],
    "MCF10A_HC20_MYC-ER_control"         => ["input"],
    "MCF10A_10E2_Vector"         => ["input"],
    "MCF10A_10E2_MYC-ERVD_OHT"         => ["input"],
    "MCF10A_10E2_MYC-ERVD_control"         => ["input"],
    "MCF10A_10E2_MYC-ER_OHT"         => ["input"],
    "MCF10A_10E2_MYC-ER_control"         => ["input"],
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
  perform_multiqc => 1,
};

my $config = performChIPSeq_gencode_hg19($def, 1);
#my $config = performChIPSeq_gencode_mm10($def, 1);

1;
