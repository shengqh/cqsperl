#!/usr/bin/perl
package CQS::PerformCutrun;

use strict;
use warnings;
use Pipeline::Cutrun;
use CQS::Global;
use CQS::ConfigUtils;
use Hash::Merge qw( merge );

require Exporter;
our @ISA = qw(Exporter);

our %EXPORT_TAGS = (
  'all' => [
      "performCutrun_gencode_hg38",
      "performCutrun_gencode_mm10",
  ]
);

our @EXPORT = ( @{ $EXPORT_TAGS{'all'} } );

our $VERSION = '0.01';

sub cutrun_options {
  return {
    perform_preprocessing => 1,
    is_paired_end => 1,
    perform_cutadapt => 0, #trimmomatic will be used

    docker_command => singularity_prefix() . " /data/cqs/softwares/singularity/cqs-chipseq.20231017.sif",

    bamplot_docker_command => singularity_prefix() . " /data/cqs/softwares/singularity/bamplot.simg",
  
    cutruntools2_docker_command => singularity_prefix() . " /data/cqs/softwares/singularity/cutruntools2.sif",
    cutruntools2_path => "/opt/CUT-RUNTools-2.0",

    seacr_path => "/opt/SEACR/SEACR_1.3.sh",

    homer_option => "",
  };
}

sub gencode_hg38_options {
  my $result = merge_hash_right_precedent( hg38_options(), cutrun_options() );
  $result = merge_hash_right_precedent( $result, gencode_hg38_databases() );
  $result = merge_hash_right_precedent($result, 
  {
    macs2_genome => "hs",
    remove_chromosome => "chrM",
    keep_chromosome   => "chr",
  });
  return($result);
}

sub gencode_mm10_options {
  my $result = merge_hash_right_precedent( mm10_options(), cutrun_options() );
  $result = merge_hash_right_precedent( $result, gencode_mm10_databases() );
  $result = merge_hash_right_precedent($result, 
  {
    macs2_genome => "mm",
    remove_chromosome => "chrM",
    keep_chromosome   => "chr",
  });
  return($result);
}

sub performCutrun_gencode_hg38 {
  my ( $userdef, $perform ) = @_;
  my $def = merge_hash_left_precedent( $userdef, gencode_hg38_options() );

  my $config = performCutrun( $def, $perform );
  return $config;
}

sub performCutrun_gencode_mm10 {
  my ( $userdef, $perform ) = @_;
  my $def = merge_hash_left_precedent( $userdef, gencode_mm10_options() );

  my $config = performCutrun( $def, $perform );
  return $config;
}

1;
