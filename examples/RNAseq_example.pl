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
  task_name => "rnaseq_hg19",

  #email which will be used for notification if you run through cluster
  email => "quanhu.sheng.1\@vumc.org",

  #target dir which will be automatically created and used to save code and result
  target_dir         => "/scratch/cqs/shengq2/temp/rnaseq_example",
  DE_fold_change     => 1.5,
  perform_multiqc    => 1,
  perform_webgestalt => 1,
  perform_gsea       => 1,

  perform_cutadapt => 1,
  cutadapt_option  => "-O 1 -q 20 -a AGATCGGAAGAGCACACGTC -A AGATCGGAAGAGCGTCGTGT -a CTGTCTCTTATACACATCT -A CTGTCTCTTATACACATCT",
  min_read_length  => 30,
  pairend => 1,

  perform_call_variants => 1,
  
  #source files
  files => {
    "VPM150_5mM_cell"   => [ "/scratch/cqs/pipeline_example/rnaseq_data/948-WZ-1-AAGAGG_S1_R1_001.fastq.gz", "/scratch/cqs/pipeline_example/rnaseq_data/948-WZ-1-AAGAGG_S1_R2_001.fastq.gz" ],
    "VPM150_metaC_cell" => [ "/scratch/cqs/pipeline_example/rnaseq_data/948-WZ-1-GGAGAA_S2_R1_001.fastq.gz", "/scratch/cqs/pipeline_example/rnaseq_data/948-WZ-1-GGAGAA_S2_R2_001.fastq.gz" ],
    "VPM153_5mM_cell"   => [ "/scratch/cqs/pipeline_example/rnaseq_data/948-WZ-1-AGCATG_S3_R1_001.fastq.gz", "/scratch/cqs/pipeline_example/rnaseq_data/948-WZ-1-AGCATG_S3_R2_001.fastq.gz" ],
    "VPM153_metaC_cell" => [ "/scratch/cqs/pipeline_example/rnaseq_data/948-WZ-1-GAGTCA_S4_R1_001.fastq.gz", "/scratch/cqs/pipeline_example/rnaseq_data/948-WZ-1-GAGTCA_S4_R2_001.fastq.gz" ],
    "VPM154_5mM_cell"   => [ "/scratch/cqs/pipeline_example/rnaseq_data/948-WZ-1-CGTAGA_S5_R1_001.fastq.gz", "/scratch/cqs/pipeline_example/rnaseq_data/948-WZ-1-CGTAGA_S5_R2_001.fastq.gz" ],
    "VPM154_metaC_cell" => [ "/scratch/cqs/pipeline_example/rnaseq_data/948-WZ-1-TCAGAG_S6_R1_001.fastq.gz", "/scratch/cqs/pipeline_example/rnaseq_data/948-WZ-1-TCAGAG_S6_R2_001.fastq.gz" ],
    "H2O"               => [ "/scratch/cqs/pipeline_example/rnaseq_data/948-WZ-1-CACAGT_S7_R1_001.fastq.gz", "/scratch/cqs/pipeline_example/rnaseq_data/948-WZ-1-CACAGT_S7_R2_001.fastq.gz" ],
  },

  groups => {
    "5mM"   => [ "VPM150_5mM_cell",   "VPM153_5mM_cell",   "VPM154_5mM_cell" ],
    "metaC" => [ "VPM150_metaC_cell", "VPM153_metaC_cell", "VPM154_metaC_cell" ],
    "H2O"   => ["H2O"],
  },

  pairs => {
    "metaC_vs_5mM" => [ "5mM", "metaC" ]
  },
};

#my $config = performRNASeq_gencode_hg38($def, 1);
my $config = performRNASeq_gencode_hg19($def, 1);
#my $config = performRNASeq_gencode_mm10($def, 1);
#my $config = performRNASeq_gatk_b37( $def, 1 );



1;
