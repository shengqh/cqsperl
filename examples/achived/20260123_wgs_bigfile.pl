#!/usr/bin/perl
use strict;
use warnings;

use CQS::FileUtils;
use CQS::SystemUtils;
use CQS::ConfigUtils;
use CQS::ClassFactory;
use Pipeline::Preprocession;
use Pipeline::PipelineUtils;
use CQS::PerformWholeGenomeSeq;
use Data::Dumper;

my $mem          = "80gb";
my $bwa_walltime = 24;

my $def = {
  task_name    => "test",
  email        => "quanhu.sheng.1\@vumc.org",
  "email-type" => "FAIL",
  target_dir   => "/nobackup/h_cqs/shengq2/test/20260123_test_wgs",

  bwa_option                => "-K 100000000 -v 3",
  max_thread                => 8,
  bwa_walltime              => $bwa_walltime,
  bwa_memory                => $mem,
  bwa_output_unmapped_fastq => 0,
  bwa_output_unmapped_bam   => 0,

  mark_duplicates_memory => $mem,

  perform_gvcf_to_genotype => 0,
  perform_filter_and_merge => 0,

  #file_def.py -i /workspace/breast_cancer_spore/20220713_wgs/data -f "*.gz" -d 1 -r -p > ../sample.txt

  files => { 'KA_0001' => [ '/data/cqs/zhaos/BenPark_data/202512_KaelynWGS/data/14195-KA-0001_S1_L005_R1_001.fastq.gz', '/data/cqs/zhaos/BenPark_data/202512_KaelynWGS/data/14195-KA-0001_S1_L005_R2_001.fastq.gz' ], },

  "perform_split_fastq"            => "by_dynamic",
  "split_fastq_min_file_size_gb"   => 10,             #only the file with file size larger than this number would be splitted
  "split_fastq_trunk_file_size_gb" => 5,              #the splitted file will be smaller than this file size
  "call_fastqsplitter"             => 1,

  GatherSortedBamFiles_cram => 1,

  use_tmp_folder        => 1,
  use_tmp_folder_fastqc => 0,

  is_paired_end                        => 1,
  perform_paired_end_validation        => 1,
  use_tmp_folder_paired_end_validation => 0,

  check_file_exists => 1,

  perform_gvcf_to_genotype              => 0,
  perform_filter_and_merge              => 0,
  callvariants_vqsr_mode                => 1,
  indel_recalibration_annotation_values => [
    "FS", "ReadPosRankSum",
    #"MQRankSum",
    "QD", "SOR", "DP"
  ],
  "indel_max_gaussians" => 2,    #default 4
  "snp_max_gaussians"   => 2,    #default 6

  perform_extract_bam      => 0,
  extract_bam_locus        => "chr17:7661779-7687550",    #TP53
  extract_bam_locus_suffix => "_tp53",
};

my $config = performWholeGenomeSeq_gatk_hg38( $def, 1 );

1;

