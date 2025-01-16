#!/usr/bin/perl
use strict;
use warnings;

use CQS::ClassFactory;
use CQS::FileUtils;
use Pipeline::CellRanger;
use Data::Dumper;

my $def = {
  task_name => "OCM4plex5V3_YJ12593",
  email => "yu.wang.2\@vumc.org",
  emailType => "FAIL",

  target_dir => create_directory_or_die("/nobackup/h_cqs/shengq2/test/20250113_mouse_scRNAseq_10x_YJ12593"),

  count_fastq_folder => "/data/cqs/ywang/PI_Weaver/20250113_mouse_scRNAseq_10x_YJ12593/data/FASTQ",
  count_files => {
    "YJ-P1" => [ "12593-YJ-P1" ],
  },
  count_reference => "/data/cqs/references/10x/refdata-gex-GRCm39-2024-A",
  count_chemistry => "auto", #multiplex FRP 
  count_jobmode => "slurm", #or local
  by_sctransform => 0,
  pca_dims => 30,
  cellranger_option => "--create-bam=false",

  perform_individual_qc => 0,
};

performCellRanger( $def );

1;
