#!/usr/bin/perl
use strict;
use warnings;

use CQS::FileUtils;
use CQS::SystemUtils;
use CQS::ConfigUtils;
use CQS::ClassFactory;
use CQS::PerformExomeSeq;
use Pipeline::Preprocession;
use Pipeline::WGS;
use Data::Dumper;

my $def = merge_hash_right_precedent(gatk_hg38_genome(), {
  task_name => "wgs_5162",
  target_dir => "/scratch/cqs/shengq2/temp/20220106_wgs_5162_hg38",
  email      => "quanhu.sheng.1\@vumc.org",
  "mail-type"  => "FAIL",
  files      => {
    "CF001" => ["/data/jbrown_lab/20200905_Flynn_5162_novartis_WGS/Samples_1-100/5162-CF-1-CGCTGTCT-ATGGTTAG_S01_L005_R1_001.fastq.gz", "/data/jbrown_lab/20200905_Flynn_5162_novartis_WGS/Samples_1-100/5162-CF-1-CGCTGTCT-ATGGTTAG_S01_L005_R2_001.fastq.gz"],
    "CF002" => ["/data/jbrown_lab/20200905_Flynn_5162_novartis_WGS/Samples_1-100/5162-CF-2-GCTAATCT-AGAGCTGG_S01_L005_R1_001.fastq.gz", "/data/jbrown_lab/20200905_Flynn_5162_novartis_WGS/Samples_1-100/5162-CF-2-GCTAATCT-AGAGCTGG_S01_L005_R2_001.fastq.gz"],
    "CF003" => ["/data/jbrown_lab/20200905_Flynn_5162_novartis_WGS/Samples_1-100/5162-CF-3-CATATGAC-TGTGACAT_S01_L005_R1_001.fastq.gz", "/data/jbrown_lab/20200905_Flynn_5162_novartis_WGS/Samples_1-100/5162-CF-3-CATATGAC-TGTGACAT_S01_L005_R2_001.fastq.gz"],
  },
  covered_bed      => "/scratch/cqs_share/references/exomeseq/IDT/Exome-IDT-xGen-hg19-v1-slop50-nochr.bed",
  is_paired        => 1,
  perform_cutadapt => 0,
  perform_gatk4_callvariants  => 0,
  perform_gatk_callvariants   => 0,
  perform_cnv_gatk4_cohort    => 0,
  perform_fastqc => 1,
  perform_report => 0,
  use_tmp_folder => 1,
});

my $config = performExomeSeq_gatk_hg38( $def, 1 );
