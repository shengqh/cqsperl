#!/usr/bin/perl
use strict;
use warnings;

use CQS::FileUtils;
use CQS::SystemUtils;
use CQS::ConfigUtils;
use CQS::ClassFactory;
use CQS::Global;
use CQS::PerformExomeSeq;
use Pipeline::Preprocession;
use Pipeline::PipelineUtils;
use Pipeline::TargetWGS;

my $def = merge_hash_right_precedent(gatk_hg38_genome(), {
  task_name => "wgs_small",
  email => "quanhu.sheng.1\@vumc.org",
  target_dir => create_directory_or_die("/nobackup/h_cqs/shengq2/temp/20240420_target_wgs_small_files"),

  use_tmp_folder => 0,

  perform_fastqc => 0,

  bwa_option => "-K 100000000 -v 3",
  max_thread => 8,
  aligner_scatter_count => 50,

  perform_split_fastq => "by_dynamic",
  call_fastqsplitter => 1,
  fastqsplitter_by_docker => 1,
  split_fastq_min_file_size_gb => 1,
  split_fastq_trunk_file_size_gb => 0.2,
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
  #bam_index_suffix => ".cram.crai",

  files => {
    "CF001" => ["/data/jbrown_lab/2020/20200905_Flynn_5162_novartis_WGS/Samples_1-100/5162-CF-1-CGCTGTCT-ATGGTTAG_S01_L005_R1_001.fastq.gz", "/data/jbrown_lab/2020/20200905_Flynn_5162_novartis_WGS/Samples_1-100/5162-CF-1-CGCTGTCT-ATGGTTAG_S01_L005_R2_001.fastq.gz"],
    "CF002" => ["/data/jbrown_lab/2020/20200905_Flynn_5162_novartis_WGS/Samples_1-100/5162-CF-2-GCTAATCT-AGAGCTGG_S01_L005_R1_001.fastq.gz", "/data/jbrown_lab/2020/20200905_Flynn_5162_novartis_WGS/Samples_1-100/5162-CF-2-GCTAATCT-AGAGCTGG_S01_L005_R2_001.fastq.gz"],
  },

  target_genes => "KRAS,TP53,SMAD4,CDKN2A,GNAS,PIK3CA",
});

my $config = performTargetWGS($def, 1);
#performTaskByPattern($config, "target_gene_cram");
#performTask($config, "bwa_03_summary");
#performTask($config, "GatherSortedBamFiles");
#performTaskByPattern($config, "gatk4");

1;



