#!/usr/bin/perl
use strict;
use warnings;

use CQS::PerformRNAseq;
use CQS::ClassFactory;

#cqstools file_def -i /nobackup/h_cqs/pipeline_example/rnaseq_data -n \(S.\) -f gz
my $def = {

  #General options
  task_name  => "rnaseq_example",
  email      => "quanhu.sheng.1\@vumc.org",
  target_dir => "/nobackup/h_cqs/shengq2/temp/rnaseq_example_01_simple",
  max_thread => 8,

  is_paired => 1,

  perform_cutadapt => 0,
  cutadapt_option  => "-q 20 -a AGATCGGAAGAGCACACGTC -A AGATCGGAAGAGCGTCGTGT",
  min_read_length  => 30,

  perform_trimmomatic => 1,
  adaptor_type => "Truseq", #"Nextera",

  files => {
    "S1" => ["/nobackup/h_cqs/pipeline_example/rnaseq_data/948-WZ-1-AAGAGG_S1_R1_001.fastq.gz", "/nobackup/h_cqs/pipeline_example/rnaseq_data/948-WZ-1-AAGAGG_S1_R2_001.fastq.gz"],
    "S2" => ["/nobackup/h_cqs/pipeline_example/rnaseq_data/948-WZ-1-GGAGAA_S2_R1_001.fastq.gz", "/nobackup/h_cqs/pipeline_example/rnaseq_data/948-WZ-1-GGAGAA_S2_R2_001.fastq.gz"],
    "S3" => ["/nobackup/h_cqs/pipeline_example/rnaseq_data/948-WZ-1-AGCATG_S3_R1_001.fastq.gz", "/nobackup/h_cqs/pipeline_example/rnaseq_data/948-WZ-1-AGCATG_S3_R2_001.fastq.gz"],
    "S4" => ["/nobackup/h_cqs/pipeline_example/rnaseq_data/948-WZ-1-GAGTCA_S4_R1_001.fastq.gz", "/nobackup/h_cqs/pipeline_example/rnaseq_data/948-WZ-1-GAGTCA_S4_R2_001.fastq.gz"],
    "S5" => ["/nobackup/h_cqs/pipeline_example/rnaseq_data/948-WZ-1-CGTAGA_S5_R1_001.fastq.gz", "/nobackup/h_cqs/pipeline_example/rnaseq_data/948-WZ-1-CGTAGA_S5_R2_001.fastq.gz"],
    "S6" => ["/nobackup/h_cqs/pipeline_example/rnaseq_data/948-WZ-1-TCAGAG_S6_R1_001.fastq.gz", "/nobackup/h_cqs/pipeline_example/rnaseq_data/948-WZ-1-TCAGAG_S6_R2_001.fastq.gz"],
    "S7" => ["/nobackup/h_cqs/pipeline_example/rnaseq_data/948-WZ-1-CACAGT_S7_R1_001.fastq.gz", "/nobackup/h_cqs/pipeline_example/rnaseq_data/948-WZ-1-CACAGT_S7_R2_001.fastq.gz"],
  },
  groups => {
    "Control" => [ "S1", "S2", "S3" ],
    "Treatment" => [ "S4", "S5", "S6", "S7" ]
  },
  pairs => {
    "Treatment_vs_Control" => [ "Control", "Treatment" ], 
  },
  perform_proteincoding_gene => 1,
  outputPdf                  => 1,
  outputPng                  => 1,
  show_label_PCA             => 0,
};

my $config = performRNASeq_gencode_hg19( $def, 1 );

#my $config = performRNASeq_gencode_hg19( $def, 0 );
#performTask( $config, "deseq2_proteincoding_genetable" );

1;
