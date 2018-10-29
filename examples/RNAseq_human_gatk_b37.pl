#!/usr/bin/perl
use strict;
use warnings;

use CQS::PerformRNAseq;
use CQS::ClassFactory;

#cqstools file_def -i /scratch/cqs/shengq2/brown/data/1112_1442/ -f gz -m samplename.txt -n \(.+ZF.\\d+\)
my $def = {

  #General options
  task_name  => "zf_1112_1142_3685",
  email      => "quanhu.sheng.1\@vumc.org",
  target_dir => "/scratch/cqs/shengq2/temp/20181023_rnaseq_zf_1112_1142_3685_human",
  max_thread => 8,

  is_paired => 1,

  perform_cutadapt => 1,
  cutadapt_option  => "-a AGATCGGAAGAGCACACGTCTGAACTCCAGTCAC -A AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGTAGATCTCGGTGGTCGCCGTATCATT",
  min_read_length  => 30,

  files => {
    "DM_EC4" =>
      [ "/scratch/cqs/shengq2/brown/data/1112_1442/1112-ZF-7-ATTACTCG-TATAGCCT_S1_R1_001.fastq.gz", "/scratch/cqs/shengq2/brown/data/1112_1442/1112-ZF-7-ATTACTCG-TATAGCCT_S1_R2_001.fastq.gz" ],
    "DM_EC6" =>
      [ "/scratch/cqs/shengq2/brown/data/1112_1442/1112-ZF-11-CGCTCATT-TATAGCCT_S3_R1_001.fastq.gz", "/scratch/cqs/shengq2/brown/data/1112_1442/1112-ZF-11-CGCTCATT-TATAGCCT_S3_R2_001.fastq.gz" ],
    "DM_EC7" =>
      [ "/scratch/cqs/shengq2/brown/data/1112_1442/1442-ZF-1-GAGATTCC-TAATCTTA_S59_R1_001.fastq.gz", "/scratch/cqs/shengq2/brown/data/1112_1442/1442-ZF-1-GAGATTCC-TAATCTTA_S59_R2_001.fastq.gz" ],
    "DM_WBC4" =>
      [ "/scratch/cqs/shengq2/brown/data/1112_1442/1112-ZF-8-TCCGGAGA-TATAGCCT_S2_R1_001.fastq.gz", "/scratch/cqs/shengq2/brown/data/1112_1442/1112-ZF-8-TCCGGAGA-TATAGCCT_S2_R2_001.fastq.gz" ],
    "DM_WBC6" =>
      [ "/scratch/cqs/shengq2/brown/data/1112_1442/1112-ZF-12-GAGATTCC-TATAGCCT_S4_R1_001.fastq.gz", "/scratch/cqs/shengq2/brown/data/1112_1442/1112-ZF-12-GAGATTCC-TATAGCCT_S4_R2_001.fastq.gz" ],
    "DM_WBC7" =>
      [ "/scratch/cqs/shengq2/brown/data/1112_1442/1442-ZF-2-ATTCAGAA-TAATCTTA_S60_R1_001.fastq.gz", "/scratch/cqs/shengq2/brown/data/1112_1442/1442-ZF-2-ATTCAGAA-TAATCTTA_S60_R2_001.fastq.gz" ]
    ,
    "HUVEC_11" => [ "/scratch/cqs/shengq2/brown/data/3685/3685-JDB-11_S11_R1_001.fastq.gz", "/scratch/cqs/shengq2/brown/data/3685/3685-JDB-11_S11_R2_001.fastq.gz" ],
    "HUVEC_12" => [ "/scratch/cqs/shengq2/brown/data/3685/3685-JDB-12_S12_R1_001.fastq.gz", "/scratch/cqs/shengq2/brown/data/3685/3685-JDB-12_S12_R2_001.fastq.gz" ],
    "HUVEC_13" => [ "/scratch/cqs/shengq2/brown/data/3685/3685-JDB-13_S13_R1_001.fastq.gz", "/scratch/cqs/shengq2/brown/data/3685/3685-JDB-13_S13_R2_001.fastq.gz" ],
  },
  groups => {
    "Diabetic_EC"  => [ "DM_EC4",   "DM_EC6",   "DM_EC7" ],
    "Diabetic_WBC" => [ "DM_WBC4",  "DM_WBC6",  "DM_WBC7" ],
    "HUVEC"        => [ "HUVEC_11", "HUVEC_12", "HUVEC_13" ],
  },
  pairs => {
    "DM_EC_vs_DM_WBC" => {
      groups => [ "Diabetic_WBC", "Diabetic_EC" ],
      paired => [ "DM_4",         "DM_6", "DM_7", "DM_4", "DM_6", "DM_7" ],
    },
    "DM_EC_vs_HUVEC" => [ "HUVEC", "Diabetic_EC" ],
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

