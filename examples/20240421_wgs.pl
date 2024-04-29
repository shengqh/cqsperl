#!/usr/bin/perl
use strict;
use warnings;

use CQS::FileUtils;
use CQS::SystemUtils;
use CQS::ConfigUtils;
use CQS::ClassFactory;
use CQS::Global;
use CQS::PerformWholeGenomeSeq;
use Pipeline::Preprocession;
use Pipeline::PipelineUtils;

my $def = {
  task_name => "wgs_big",
  email => "quanhu.sheng.1\@vumc.org",
  target_dir => create_directory_or_die("/nobackup/h_cqs/shengq2/temp/20240421_wgs_big_files"),

  use_tmp_folder => 0,

  perform_fastqc => 0,

  bwa_option => "-K 100000000 -v 3",
  max_thread => 8,
  aligner_scatter_count => 50,

  perform_split_fastq => "by_dynamic",
  call_fastqsplitter => 1,
  fastqsplitter_by_docker => 1,
  split_fastq_min_file_size_gb => 2,
  split_fastq_trunk_file_size_gb => 0.5,
  split_fastq_dynamic_no_docker => 0,

  perform_paired_end_validation => 0,

  perform_mark_duplicates => 1,
  mark_duplicates_memory => "80gb",

  GatherSortedBamFiles_cram => 1,

  BWA_docker_command => singularity_prefix() . " /data/cqs/softwares/singularity/cqs-exomeseq.20240418.sif ",
  docker_command => singularity_prefix() . " /data/cqs/softwares/singularity/cqs-exomeseq.20240418.sif ",

  bwa_do_bam_stat => 1,
  perform_bwa_summary => 0,

  perform_cnv_gatk4_cohort => 0,

  #bam_suffix => ".cram",
  #bam_suffix => ".cram",
  #bam_index_suffix => ".cram.crai",

  files => {
    'P06_619' => [ '/workspace/breast_cancer_spore/20220713_wgs/data/06-619/V350087326_L03_B5GHUMexlkRAAUA-1_1.fq.gz', '/workspace/breast_cancer_spore/20220713_wgs/data/06-619/V350087326_L03_B5GHUMexlkRAAUA-1_2.fq.gz' ], 
    'P06_622' => [ '/workspace/breast_cancer_spore/20220713_wgs/data/06-622/V350086080_L04_B5GHUMexlkRAAIA-1_1.fq.gz', '/workspace/breast_cancer_spore/20220713_wgs/data/06-622/V350086080_L04_B5GHUMexlkRAAIA-1_2.fq.gz' ], 
  },

  target_genes => "KRAS,TP53,SMAD4,CDKN2A,GNAS,PIK3CA",
};

my $config = performWholeGenomeSeq_gatk_hg38($def, 1);

1;



