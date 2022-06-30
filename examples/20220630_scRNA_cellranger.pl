#!/usr/bin/perl
use strict;
use warnings;

use CQS::ClassFactory;
use CQS::FileUtils;
use Pipeline::CellRanger;
use Data::Dumper;

my $def = {
  task_name => "scRNA_JLin_human",
  email => "quanhu.sheng.1\@vumc.org",
  emailType => "FAIL",

  target_dir => create_directory_or_die("/scratch/cqs/shengq2/temp/20220630_scRNA_cellranger"),

  count_fastq_folder => "/data/h_gelbard_lab/data/JLin112020/JLin112020",
  count_files => {
    "nMCu81420" => [ "081420-N" ],
    "sMCu81420" => [ "081420-S" ],
    "sSW91820" => [ "092220-S" ],
    "nZM100920" => [ "100920-N" ],
    "sZM100920" => [ "100920-S" ],
    "nSP112020" => [ "112020_N" ],
    "sSP112020" => [ "112020-S" ],
  },
  count_reference => "/data/cqs/references/10x/refdata-gex-GRCh38-2020-A",
  count_chemistry => "SC5P-R2", #single end data, only R2 contains mRNA sequence
  count_jobmode => "slurm", #or local

  vdj_fastq_folder => "/data/h_gelbard_lab/data/JLin112020/JLin112020_TCR",
  vdj_files => {
    "nMCu81420" => [ "081420-N-TCR" ],
    "sMCu81420" => [ "081420-S-TCR" ],
    "sSW91820" => [ "092220-S-TCR" ],
    "nZM100920" => [ "100920-N-TCR" ],
    "sZM100920" => [ "100920-S-TCR" ],
    "nSP112020" => [ "112020-N-TCR" ],
    "sSP112020" => [ "112020-S-TCR" ],
  },
  vdj_chain => "TR",
  vdj_reference => "/data/cqs/references/10x/refdata-cellranger-vdj-GRCh38-alts-ensembl-5.0.0",
};

performCellRanger( $def );

1;
