#!/usr/bin/perl
use strict;
use warnings;

use CQS::ClassFactory;
use CQS::FileUtils;
use CQS::SystemUtils;
use Data::Dumper;
use File::Basename;
use Pipeline::scRNASeq;

my $docker_command = "singularity exec -e -H `pwd` /data/cqs/softwares/singularity/cqs-scrnaseq.simg ";
my $home = '/home/shengq2/program';
my $target_dir = "/scratch/cqs/shengq2/temp/20210611_NoAAC_iSGS_3364_3800_6363_scRNA";
my $gsea_db_ver = "v7.4";

my $def = {
  task_name => "NoAAC_iSGS_airway_atlas",

  email      => "quanhu.sheng.1\@vumc.org",
  target_dir => create_directory_or_die($target_dir),

  docker_command =>  $docker_command,

  files => {
    "nSP112020" => [ "/scratch/cqs/shengq2/alexander_gelbard_projects/20210219_scRNA_JLin_human_cellranger/count_chemistry_local/result/nSP112020/filtered_feature_bc_matrix.h5" ],
    "nZM100920" => [ "/scratch/cqs/shengq2/alexander_gelbard_projects/20210219_scRNA_JLin_human_cellranger/count_chemistry_local/result/nZM100920/filtered_feature_bc_matrix.h5" ],
    "sSP112020" => [ "/scratch/cqs/shengq2/alexander_gelbard_projects/20210219_scRNA_JLin_human_cellranger/count_chemistry_local/result/sSP112020/filtered_feature_bc_matrix.h5" ],
    "sZM100920" => [ "/scratch/cqs/shengq2/alexander_gelbard_projects/20210219_scRNA_JLin_human_cellranger/count_chemistry_local/result/sZM100920/filtered_feature_bc_matrix.h5" ],
  },

  groups => {
    "iSGS_Airway_Scar" => [qw(sSP112020 sZM100920)],
    "Healthy_Airway_Mucosa" => [qw(nSP112020 nZM100920)]
  },

  pairs => {
    "iSGS_vs_Healthy" => ["Healthy_Airway_Mucosa", "iSGS_Airway_Scar"]
  },

  perform_localization_genes_plot => 1,
  localization_genes_file => "$home/collaborations/alexander_gelbard/20210611_NoAAC_iSGS_3364_3800_6363_scRNA/GeneLocalizationMap_06222021.txt",

  perform_localization_gene_ratio_plot => 1,
  localization_gene_ratio => [qw(BAX/BCL2)],

  webgestalt_organism => "hsapiens",

  nFeature_cutoff_min => 300,
  nFeature_cutoff_max => 10000,
  nCount_cutoff       => 500,
  mt_cutoff           => 20,
  Mtpattern           => "^MT-|^Mt-|^mt-",
  rRNApattern         => "^Rp[sl][[:digit:]]|^RP[SL][[:digit:]]",
  pca_dims            => 50,
  species             => "Hs",
  Remove_rRNA         => 1,
  Remove_MtRNA        => 0,
  resolution          => 0.5,
  markers_file        => "/data/cqs/references/scrna/PanglaoDB_markers_27_Mar_2020.tsv",
  HLA_panglao5_file   => "/data/cqs/references/scrna/HLA_panglao5.txt",
  curated_markers_file => "/data/cqs/references/scrna/curated_markers.txt",
  summary_layer_file => "$home/collaborations/alexander_gelbard/HLA_panglao5_ag.06222021.xlsx",
  annotate_tcell      => 0,
  remove_subtype      => "T cells",
  tcell_markers_file  => "/data/cqs/references/scrna/TcellAI_marker.txt",
  by_sctransform      => 1,

  by_integration      => 1,
  integration_by_harmony => 1,

  batch_for_integration => 0,
  batch_for_integration_groups => {
    "3364" => [ "iSGS_3364_1", "iSGS_3364_2", "iSGS_3364_3" ],
    "3800" => [ "nSP112020", "nZM100920", "sSP112020", "sSW91820", "sZM100920" ],
    "6363" => [ "iSGS_6363_1", "iSGS_6363_2" ],
  },

  #view marker genes
  #marker_genes_file => "C:/Users/sheng/Programs/collaborations/alexander_gelbard/20200519_cell_markers.txt",

  perform_scRNABatchQC => 0,

  #genes =>"H3F3A",

  #differential expression analysis
  perform_edgeR => 1,

  DE_by_celltype => 0,
  DE_by_cluster  => 1,
  DE_by_sample   => 0,
  DE_by_cell     => 1,

  DE_pvalue         => 0.05,
  DE_use_raw_pvalue => 0,
  DE_fold_change    => 1.5,

  #DE gene annotation
  perform_webgestalt  => 1,
  webgestalt_organism => "hsapiens",

  perform_gsea    => 1,
  gsea_jar            => "gsea-cli.sh",
  gsea_db_ver         => $gsea_db_ver,
  gsea_db             => "/data/cqs/references/gsea/$gsea_db_ver",
  gsea_categories     => "'h.all.$gsea_db_ver.symbols.gmt', 'c2.all.$gsea_db_ver.symbols.gmt', 'c5.all.$gsea_db_ver.symbols.gmt', 'c6.all.$gsea_db_ver.symbols.gmt', 'c7.all.$gsea_db_ver.symbols.gmt'",
  gsea_makeReport => 0,


  perform_rename_cluster => 0,
  rename_cluster     => {
  },

  plot_marker_genes => {
    "celltype" => {
      file => "$home/collaborations/alexander_gelbard/20200519_cell_markers.txt",
    },
    "pathway" => {
      file => "$home/collaborations/alexander_gelbard/20200526_pathway_genes.txt",
    },
  },

  genesDotPlotOnly => 1,

  perform_curated_gene_dotplot => 1,
  curated_gene_files => {
    Genomic_Cannidate => "$home/collaborations/alexander_gelbard/20210611_NoAAC_iSGS_3364_3800_6363_scRNA/curated_genes/Genomic_Cannidate_GeneList.txt",
    Pathway_Apoptosis => "$home/collaborations/alexander_gelbard/20210611_NoAAC_iSGS_3364_3800_6363_scRNA/curated_genes/Pathway_Apoptosis.txt",
    Pathway_AutoAntigens => "$home/collaborations/alexander_gelbard/20210611_NoAAC_iSGS_3364_3800_6363_scRNA/curated_genes/Pathway_AutoAntigens.txt",
    Pathway_ClassI_AntigenPresentation => "$home/collaborations/alexander_gelbard/20210611_NoAAC_iSGS_3364_3800_6363_scRNA/curated_genes/Pathway_ClassI_AntigenPresentation.txt",
    Pathway_ClassII_AntigenPresentation => "$home/collaborations/alexander_gelbard/20210611_NoAAC_iSGS_3364_3800_6363_scRNA/curated_genes/Pathway_ClassII_AntigenPresentation.txt",
    Pathway_EndothelialTargets => "$home/collaborations/alexander_gelbard/20210611_NoAAC_iSGS_3364_3800_6363_scRNA/curated_genes/Pathway_EndothelialTargets.txt",
    Pathway_FocalAdhesion => "$home/collaborations/alexander_gelbard/20210611_NoAAC_iSGS_3364_3800_6363_scRNA/curated_genes/Pathway_FocalAdhesion.txt",
    Pathway_mTOR => "$home/collaborations/alexander_gelbard/20210611_NoAAC_iSGS_3364_3800_6363_scRNA/curated_genes/Pathway_mTOR.txt",
    Pathway_OMIM_LTS => "$home/collaborations/alexander_gelbard/20210611_NoAAC_iSGS_3364_3800_6363_scRNA/curated_genes/Pathway_OMIM_LTS_genes.txt",
    Pathway_TCR_signaling => "$home/collaborations/alexander_gelbard/20210611_NoAAC_iSGS_3364_3800_6363_scRNA/curated_genes/Pathway_TCR_signaling.txt",
    Pathway_TGFB_signaling => "$home/collaborations/alexander_gelbard/20210611_NoAAC_iSGS_3364_3800_6363_scRNA/curated_genes/Pathway_TGFB_signaling.txt",
    Pathway_TH1_TH2_TH17 => "$home/collaborations/alexander_gelbard/20210611_NoAAC_iSGS_3364_3800_6363_scRNA/curated_genes/Pathway_TH1_TH2_TH17.txt",
    Pathway_Upregulated_proteins => "$home/collaborations/alexander_gelbard/20210611_NoAAC_iSGS_3364_3800_6363_scRNA/curated_genes/Pathway_Upregulated_protiens.txt",
    ECM_components => "$home/collaborations/alexander_gelbard/20210611_NoAAC_iSGS_3364_3800_6363_scRNA/curated_genes/ECM_components.txt",
    Epithelial_markers => "$home/collaborations/alexander_gelbard/20210611_NoAAC_iSGS_3364_3800_6363_scRNA/curated_genes/Epithelial_markers.txt"
  },

  perform_scMRMA => 0,
  perform_CHETAH => 0,
  chetah_reference_file => "/data/cqs/references/scrna/CHETAH_TME_reference.Rdata",
  chetah_ribosomal_file => "/data/cqs/references/scrna/ribosomal.txt",
  perform_SignacX => 0,
  perform_SignacX_tcell => 0,

  bubblemap_file => "$home/collaborations/alexander_gelbard/Gelbard_BubbleMap_06222021_v2.xlsx",
};

my $config = performScRNASeq( $def, 1 );

1;
