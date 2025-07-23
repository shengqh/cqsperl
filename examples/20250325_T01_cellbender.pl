#!/usr/bin/perl
use strict;
use warnings;

use CQS::Global;
use CQS::ClassFactory;
use CQS::SystemUtils;
use CQS::FileUtils;
use Data::Dumper;
use CQS::PerformRNAseq;
use Pipeline::scRNASeq;
use CQS::ConfigUtils;
use scRNA::Modules;

my $program = "/nobackup/h_cqs/shengq2/program";

my $def = {
  task_name => "T01_cellbender",

  email      => "quanhu.sheng.1\@vumc.org",
  target_dir => create_directory_or_die("/nobackup/shah_lab/shengq2/20241030_Kaushik_Amancherla_snRNAseq/20250325_T01_cellbender"),

  docker_command => singularity_prefix() . " /data/cqs/softwares/singularity/cqs-scrnaseq.simg ",
  
  perform_cellbender => 1,
  ##for cellbender, if the protein capture data is included, it will be used as genes. so we need to keep gene expression data only
  cellbender_extract_gene_expression_h5 => 1,
  cellbender_docker_command => global_options()->{"cellbender_docker_command"},

  raw_files => {
    'KA_0001' => [ '/data/shah_lab/202410_pbmc_rejection_KA/Count/12306-KA-0001_FB/raw_feature_bc_matrix.h5' ],
    'KA_0002' => [ '/data/shah_lab/202410_pbmc_rejection_KA/Count/12306-KA-0002_FB/raw_feature_bc_matrix.h5' ],
    'KA_0003' => [ '/data/shah_lab/202410_pbmc_rejection_KA/Count/12306-KA-0003_FB/raw_feature_bc_matrix.h5' ],
    'KA_0004' => [ '/data/shah_lab/202410_pbmc_rejection_KA/Count/12306-KA-0004_FB/raw_feature_bc_matrix.h5' ],
  },

  files => {
    'KA_0001' => [ '/data/shah_lab/202410_pbmc_rejection_KA/Count/12306-KA-0001_FB/filtered_feature_bc_matrix.h5' ],
    'KA_0002' => [ '/data/shah_lab/202410_pbmc_rejection_KA/Count/12306-KA-0002_FB/filtered_feature_bc_matrix.h5' ],
    'KA_0003' => [ '/data/shah_lab/202410_pbmc_rejection_KA/Count/12306-KA-0003_FB/filtered_feature_bc_matrix.h5' ],
    'KA_0004' => [ '/data/shah_lab/202410_pbmc_rejection_KA/Count/12306-KA-0004_FB/filtered_feature_bc_matrix.h5' ],
  },

  perform_decontX => 0,
  remove_decontX => 0,

  perform_scRNABatchQC => 0,
  perform_individual_qc => 0,
  perform_individual_dynamic_qc => 1,
  perform_seurat => 0,

  dynamic_by_one_resolution => 0.5, 
  by_sctransform => 1,
  dynamic_combine_cell_types => {
    "Epithelial/Basal" => ["Epithelial cells", "Basal cells"],
    "Fibroblasts/SMC" => [ "Fibroblasts", "Smooth muscle cells"],
    "Myeloid" => ["Monocytes", "Dendritic cells", "Macrophages"],
    "NK/T cells" => ["NK cells", "T cells"],
  },

  #https://plger.github.io/scDblFinder/articles/scDblFinder.html
  #If your samples are multiplexed, i.e. the different samples are mixed in different batches, then the batches should be what you provide to this argument.
  #Based on the description of the method, we will perform scDblFinder and batch level
  perform_scDblFinder => 1,
  scDblFinder_by_dynamic_qc => 1,
  perform_sctk => 0,

  # 20250226, changed the mt_cutoff from 20 to 5
  nFeature_cutoff_min => 200,
  nFeature_cutoff_max => 8000,
  nCount_cutoff       => 500,
  nCount_cutoff_max   => 80000,
  mt_cutoff           => 5,
  Mtpattern           => "^MT-|^Mt-|^mt-",
  rRNApattern         => "^Rp[sl][[:digit:]]|^RP[SL][[:digit:]]",
  species             => "Hs",
  Remove_MtRNA        => 0,
  Remove_rRNA         => 0,
  markers_file        => "/data/cqs/references/scrna/PanglaoDB_markers_27_Mar_2020.tsv",
  curated_markers_file => "/data/cqs/references/scrna/curated_markers.txt",
  HLA_panglao5_file   => "/data/cqs/references/scrna/HLA_panglao5.txt",

  bubblemap_file => "/nobackup/h_cqs/shengq2/program/collaborations/celestine_wanjalla/20230115_combined_scRNA_hg38/20241231_global_bubble.xlsx",
  bubblemap_width => 4000,
  bubblemap_height => 2000,

  species => "Hs",
  markers_file        => "/data/cqs/references/scrna/PanglaoDB_markers_27_Mar_2020.tsv",
  HLA_panglao5_file   => "/data/cqs/references/scrna/HLA_panglao5.txt",

  perform_webgestalt => 0,
  webgestalt_organism => "hsapiens",
  
  perform_gsea => 0,

  perform_dynamic_subcluster => 0,

  perform_report => 0,
};

my $config = performScRNASeq( $def, 1 );

1;
