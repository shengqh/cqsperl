#!/usr/bin/perl
use strict;
use warnings;

use CQS::ClassFactory;
use CQS::FileUtils;
use Pipeline::CellRanger;
use Data::Dumper;

#with all FASTQ files, we will perform cellranger count
#remember to add cellranger to your PATH environment variable: /data/cqs/softwares/10x/cellranger-10.0.0/bin/cellranger
my $def = {
  task_name => "example",
  email => "quanhu.sheng.1\@vumc.org",
  emailType => "FAIL",

  target_dir => create_directory_or_die("/nobackup/h_cqs/shengq2/test/cellranger"),

  #VUMC data
  count_fastq_folder => "/data/wanjalla_lab/data/20250114_12629_scRNA_mouseWhumanDNA/FASTQ",

  count_files => {
    "CW01" => ["12629-CW-P1"],
  },

  # human genome reference  
  count_reference => "/data/cqs/references/10x/refdata-gex-GRCh38-2024-A",
  count_jobmode => "slurm",

  perform_individual_qc => 0,
};

performCellRanger( $def );

1;
