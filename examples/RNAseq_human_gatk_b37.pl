#!/usr/bin/perl
use strict;
use warnings;

use CQS::PerformRNAseq;
use CQS::ClassFactory;

#cqstools file_def -i /scratch/cqs/pipeline_example/rnaseq_data -n \(sample.\)
my $def = {

  #General options
  task_name  => "rnaseq_example",
  email      => "quanhu.sheng.1\@vumc.org",
  target_dir => "/scratch/cqs/shengq2/temp/rnaseq_example",
  max_thread => 8,

  is_paired => 1,

  perform_cutadapt => 1,
  cutadapt_option  => "-q 20 -a AGATCGGAAGAGCACACGTC -A AGATCGGAAGAGCGTCGTGT",
  min_read_length  => 30,

  files => {
    "sample1" => ["/scratch/cqs/pipeline_example/rnaseq_data/sample1_R1.fastq.gz", "/scratch/cqs/pipeline_example/rnaseq_data/sample1_R2.fastq.gz"],
    "sample2" => ["/scratch/cqs/pipeline_example/rnaseq_data/sample2_R1.fastq.gz", "/scratch/cqs/pipeline_example/rnaseq_data/sample2_R2.fastq.gz"],
    "sample3" => ["/scratch/cqs/pipeline_example/rnaseq_data/sample3_R1.fastq.gz", "/scratch/cqs/pipeline_example/rnaseq_data/sample3_R2.fastq.gz"],
    "sample4" => ["/scratch/cqs/pipeline_example/rnaseq_data/sample4_R1.fastq.gz", "/scratch/cqs/pipeline_example/rnaseq_data/sample4_R2.fastq.gz"],
    "sample5" => ["/scratch/cqs/pipeline_example/rnaseq_data/sample5_R1.fastq.gz", "/scratch/cqs/pipeline_example/rnaseq_data/sample5_R2.fastq.gz"],
    "sample6" => ["/scratch/cqs/pipeline_example/rnaseq_data/sample6_R1.fastq.gz", "/scratch/cqs/pipeline_example/rnaseq_data/sample6_R2.fastq.gz"],
    "sample7" => ["/scratch/cqs/pipeline_example/rnaseq_data/sample7_R1.fastq.gz", "/scratch/cqs/pipeline_example/rnaseq_data/sample7_R2.fastq.gz"],
    "sample8" => ["/scratch/cqs/pipeline_example/rnaseq_data/sample8_R1.fastq.gz", "/scratch/cqs/pipeline_example/rnaseq_data/sample8_R2.fastq.gz"],
    "sample9" => ["/scratch/cqs/pipeline_example/rnaseq_data/sample9_R1.fastq.gz", "/scratch/cqs/pipeline_example/rnaseq_data/sample9_R2.fastq.gz"],
  },
  groups => {
    "Group1" => [ "sample1", "sample2", "sample3" ],
    "Group2" => [ "sample4", "sample5", "sample6" ],
    "Group3" => [ "sample7", "sample8", "sample9" ],
  },
  pairs => {
    "Group2_vs_Group1" => {
      groups => [ "Group1", "Group2" ],
      paired => [ "Patient1", "Patient2", "Patient3", "Patient1", "Patient2", "Patient3" ],
    },
    "Group3_vs_Group1" => [ "Group1", "Group3" ],
  },
  perform_proteincoding_gene => 1,
  outputPdf                  => 1,
  outputPng                  => 1,
  show_label_PCA             => 0,
};

my $config = performRNASeq_gatk_b37( $def, 1 );

#my $config = performRNASeq_gatk_b37( $def, 0 );
#performTask( $config, "deseq2_proteincoding_genetable" );
1;

