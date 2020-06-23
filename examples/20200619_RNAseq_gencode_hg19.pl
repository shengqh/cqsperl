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

  #target dir which will be automatically created and used to save code and result, you need to change it for each project.
  target_dir         => "/scratch/cqs/test/rnaseq_example",

  #DEseq2 fold change, you can use either 1.5 or 2 or other option you want.
  DE_fold_change     => 1.5,

  #Since we have most of figure, we don't need multiqc anymore. But if you want, you can set it to 1.
  perform_multiqc    => 0,

  #We use webgestalt to do gene enrichment analysis using differential expressed genes.
  perform_webgestalt => 1,

  #We use GSEA for gene set enrichment analysis. It works for human genome only.
  perform_gsea       => 1,

  #If we need to trim the adapter from reads. Set to 0 if you don't find adapter in raw data.
  perform_cutadapt => 1,

  #If you find adapter through FastQC report, you need to specify adapter here.
  cutadapt_option  => "-O 1 -q 20 -a AGATCGGAAGAGCACACGTC -A AGATCGGAAGAGCGTCGTGT -a CTGTCTCTTATACACATCT -A CTGTCTCTTATACACATCT",

  #discard reads with length less than 30 after adapter trimming
  min_read_length  => 30,

  #Is the data pairend data or single end data
  pairend => 1,

  #Call variant using GATK pipeline
  perform_call_variants => 0,
  
  #source files, it's a hashmap with key (sample name) points to array of files. For single end data, the array should contains one file only.
  files => {
    "VPM150_5mM_cell"   => [ "/scratch/cqs/pipeline_example/rnaseq_data/948-WZ-1-AAGAGG_S1_R1_001.fastq.gz", "/scratch/cqs/pipeline_example/rnaseq_data/948-WZ-1-AAGAGG_S1_R2_001.fastq.gz" ],
    "VPM150_metaC_cell" => [ "/scratch/cqs/pipeline_example/rnaseq_data/948-WZ-1-GGAGAA_S2_R1_001.fastq.gz", "/scratch/cqs/pipeline_example/rnaseq_data/948-WZ-1-GGAGAA_S2_R2_001.fastq.gz" ],
    "VPM153_5mM_cell"   => [ "/scratch/cqs/pipeline_example/rnaseq_data/948-WZ-1-AGCATG_S3_R1_001.fastq.gz", "/scratch/cqs/pipeline_example/rnaseq_data/948-WZ-1-AGCATG_S3_R2_001.fastq.gz" ],
    "VPM153_metaC_cell" => [ "/scratch/cqs/pipeline_example/rnaseq_data/948-WZ-1-GAGTCA_S4_R1_001.fastq.gz", "/scratch/cqs/pipeline_example/rnaseq_data/948-WZ-1-GAGTCA_S4_R2_001.fastq.gz" ],
    "VPM154_5mM_cell"   => [ "/scratch/cqs/pipeline_example/rnaseq_data/948-WZ-1-CGTAGA_S5_R1_001.fastq.gz", "/scratch/cqs/pipeline_example/rnaseq_data/948-WZ-1-CGTAGA_S5_R2_001.fastq.gz" ],
    "VPM154_metaC_cell" => [ "/scratch/cqs/pipeline_example/rnaseq_data/948-WZ-1-TCAGAG_S6_R1_001.fastq.gz", "/scratch/cqs/pipeline_example/rnaseq_data/948-WZ-1-TCAGAG_S6_R2_001.fastq.gz" ],
    "H2O"               => [ "/scratch/cqs/pipeline_example/rnaseq_data/948-WZ-1-CACAGT_S7_R1_001.fastq.gz", "/scratch/cqs/pipeline_example/rnaseq_data/948-WZ-1-CACAGT_S7_R2_001.fastq.gz" ],
  },

  #group definition, group name points to array of sample name defined in files.
  groups => {
    "5mM"   => [ "VPM150_5mM_cell",   "VPM153_5mM_cell",   "VPM154_5mM_cell" ],
    "metaC" => [ "VPM150_metaC_cell", "VPM153_metaC_cell", "VPM154_metaC_cell" ],
    "H2O"   => ["H2O"],
  },

  #comparison definition, comparison name points to array of group name defined in groups.
  #for each comparison, only two group names allowed while the first group will be used as control.
  pairs => {
    "metaC_vs_5mM" => [ "5mM", "metaC" ]
  },
};

my $config = performRNASeq_gencode_hg19($def, 1);

1;
