#!/usr/bin/perl
package CQS::PerformPIPseq3;

use strict;
use warnings;
use Pipeline::PIPseq;
use CQS::Global;
use CQS::ConfigUtils;

require Exporter;
our @ISA = qw(Exporter);

our %EXPORT_TAGS = (
  'all' => [
    qw(
      performPIPseq3_ensembl_CanFam3_1
      performPIPseq3_gencode_hg38
      )
  ]
);

our @EXPORT = ( @{ $EXPORT_TAGS{'all'} } );

our $VERSION = '0.01';

sub global_definition {
  my $result = merge_hash_right_precedent(global_options(), {
    #constraint                => "haswell",
    docker_command => singularity_prefix() . " /data/cqs/softwares/singularity/cqs-scrnaseq.simg ",

    pipseeker_command => "/data/cqs/softwares/pipseeker_v3.1.3/pipseeker",

    perform_individual_qc => 1,

    remove_subtype => "T cells,B cells,Plasma cells,Fibroblasts,Neurons,Epithelial cells,Endothelial cells,Macrophages,Dendritic cells,Ciliated cells,Plasmacytoid dendritic cells",

    Mtpattern => "^MT-|^Mt-|^mt-",
    rRNApattern => "^Rp[sl][[:digit:]]|^RP[SL][[:digit:]]",
    markers_file => "/data/cqs/references/scrna/PanglaoDB_markers_27_Mar_2020.tsv",
    curated_markers_file => "/data/cqs/references/scrna/curated_markers.txt",
    HLA_panglao5_file => "/data/cqs/references/scrna/HLA_panglao5.txt",
  });

  return($result);
}

sub ensembl_CanFam3_1_genome {
  return merge_hash_right_precedent(global_definition(), {
    ensembl_gene_map_file => "/data/cqs/references/dog/ensembl_symbol.txt",
    species => "Hs", #treat the gene symbol as human genes
    pipseeker_star_index => "/data/cqs/references/dog/CanFam3.1/STAR_index_2.7.8a_v104_sjdb100"
  });
}

sub performPIPseq3_ensembl_CanFam3_1 {
  my ( $userdef, $perform ) = @_;
  my $def = merge_hash_left_precedent( $userdef, ensembl_CanFam3_1_genome() );
  my $config = performPIPseq3( $def, $perform );
  return $config;
}

sub gencode_hg38_genome {
  return merge_hash_right_precedent(global_definition(), {
    ensembl_gene_map_file => "",
    species => "Hs", #treat the gene symbol as human genes
    pipseeker_star_index => "/data/cqs/references/gencode/GRCh38.p13/STAR_index_2.7.8a_v38_sjdb100",
  });
}

sub performPIPseq3_gencode_hg38 {
  my ( $userdef, $perform ) = @_;
  my $def = merge_hash_left_precedent( $userdef, gencode_hg38_genome() );
  my $config = performPIPseq3( $def, $perform );
  return $config;
}


1;
