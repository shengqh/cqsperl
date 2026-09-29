#!/usr/bin/perl
use strict;
use warnings;

use CQS::Global;
use CQS::FileUtils;
use CQS::ClassFactory;
use Pipeline::PipelineUtils;

my $def = {
  task_name        => "RNAseq_Deconvolution",
  email            => "quanhu.sheng.1\@vumc.org",
  affiliation      => "CQS/Biostatistics of VUMC",
  target_dir       => create_directory_or_die("/nobackup/h_cqs/shengq2/test/20260929_RNAseq_Deconvolution"),
  add_folder_index => 0,

  files => {
    "P14806_mm10" => {
      "count_file"       => "/nobackup/brown_lab/projects/20260601_14806_rnaseq_mm10/genetable/result/P14806_mm10.proteincoding.count",
      "gene_column"      => "Feature_gene_name",
      "discard_columns"  => [ 'Feature', 'Feature_length', 'Feature_chr', 'Feature_start', 'Feature_end', 'Feature_gene_biotype' ],
      "single_cell_rds"  => "/nobackup/brown_lab/projects/20260604_scRNA_Aorta_Progeria_mm10_newCellRanger/20260804_silhouette_refine_clusters/Aorta_Progeria.final.obj.rds",
      "cell_type_column" => "refine_cell_type",
      "species"          => "mm", #mm or hs
    }
  },
};

my $config = {
  general => {
    email          => $def->{email},
    target_dir     => $def->{target_dir},
    task_name      => $def->{task_name},
    affiliation    => $def->{affiliation},
    docker_command => singularity_prefix() . "/data/cqs/softwares/singularity/cqs-scrnaseq.20260929.sif"
  },
  files => $def->{files},
};

my $tasks = [];

add_BayesPrism_Deconvolution( $config, $def, $tasks, $def->{target_dir}, "BayesPrism_Deconvolution", "files" );

performConfig($config);

1;
