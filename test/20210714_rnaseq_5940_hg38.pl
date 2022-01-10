#!/usr/bin/perl
use strict;
use warnings;

use CQS::Global;
use CQS::ClassFactory;
use CQS::FileUtils;
use CQS::ConfigUtils;
use Data::Dumper;
use Pipeline::SmallRNAUtils;
use CQS::PerformRNAseq;

my $def = {
  task_name => "rnaseq_5940",

  email      => "quanhu.sheng.1\@vumc.org",
  target_dir => create_directory_or_die("/scratch/cqs/shengq2/temp/20210714_rnaseq_5940_hg38"),

  perform_qc_check_fastq_duplicate => 0,
  perform_preprocessing      => 1,
  #perform_cutadapt_test      => 1,

  perform_cutadapt           => 1,
  #illumina universal adapter
  cutadapt_option            => "-q 20 -a AGATCGGAAGAG -A AGATCGGAAGAG",
  min_read_length            => 30,
  is_pairend                 => 1,

  perform_mapping            => 1,
  perform_counting           => 1,
  perform_count_table        => 1,
  perform_correlation        => 1,
  perform_proteincoding_gene => 1,
  perform_webgestalt         => 1,
  perform_gsea               => 1,
  perform_report             => 1,
  outputPdf                  => 1,
  outputPng                  => 1,
  outputTIFF                 => 0,

  files => {
    'NoTreatment_Rep1' => [ '/data/jbrown_lab/20210714_5940/5940-JB-1_S1_L005_R1_001.fastq.gz', '/data/jbrown_lab/20210714_5940/5940-JB-1_S1_L005_R2_001.fastq.gz' ],
    'NoTreatment_Rep2' => [ '/data/jbrown_lab/20210714_5940/5940-JB-2_S1_L005_R1_001.fastq.gz', '/data/jbrown_lab/20210714_5940/5940-JB-2_S1_L005_R2_001.fastq.gz' ],
    'NoTreatment_Rep3' => [ '/data/jbrown_lab/20210714_5940/5940-JB-3_S1_L005_R1_001.fastq.gz', '/data/jbrown_lab/20210714_5940/5940-JB-3_S1_L005_R2_001.fastq.gz' ],
    'TNF_Rep1' => [ '/data/jbrown_lab/20210714_5940/5940-JB-9_S1_L005_R1_001.fastq.gz', '/data/jbrown_lab/20210714_5940/5940-JB-9_S1_L005_R2_001.fastq.gz' ],
    'TNF_Rep2' => [ '/data/jbrown_lab/20210714_5940/5940-JB-10_S1_L005_R1_001.fastq.gz', '/data/jbrown_lab/20210714_5940/5940-JB-10_S1_L005_R2_001.fastq.gz' ],
    'TNF_Rep3' => [ '/data/jbrown_lab/20210714_5940/5940-JB-11_S1_L005_R1_001.fastq.gz', '/data/jbrown_lab/20210714_5940/5940-JB-11_S1_L005_R2_001.fastq.gz' ],
  },
  groups_pattern => "(.+)_Rep",
  pairs => {
    TNF_vs_NoTreatment => {
      groups => [ 'NoTreatment', 'TNF'],
    },
  },
  show_label_PCA => 0,
  use_tmp_folder => 1,
};

my $config = performRNASeq_gencode_hg38( $def, 1 );

1;
