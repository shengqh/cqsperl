#!/usr/bin/perl
package CQS::PerformCutruntools2;

use strict;
use warnings;
use Pipeline::Cutruntools2;
use CQS::Global;
use CQS::ConfigUtils;
use Hash::Merge qw( merge );

require Exporter;
our @ISA = qw(Exporter);

our %EXPORT_TAGS = (
  'all' => [
      "performCutruntools2_gencode_hg38",
      "performCutruntools2_gencode_mm10",
  ]
);

our @EXPORT = ( @{ $EXPORT_TAGS{'all'} } );

our $VERSION = '0.01';

sub cutrun_options {
  return {
    perform_preprocessing => 1,
    is_paired_end => 1,

    docker_command => singularity_prefix() . " /data/cqs/softwares/singularity/cqs-chipseq.20231017.sif",
    cutruntools2_docker_command => singularity_prefix() . " /data/cqs/softwares/singularity/cutruntools2.sif",
    "cutruntools2-bulk-config" => "/data/cqs/shengq2/program/cqsperl/lib/CQS/cutruntools2-cutrun-bulk-config.json",

    bamplot_docker_command => singularity_prefix() . " /data/cqs/softwares/singularity/bamplot.simg",
  };
}

sub gencode_hg38_options {
  my $result = merge_hash_right_precedent( hg38_options(), cutrun_options() );
  $result = merge_hash_right_precedent( $result, gencode_hg38_databases() );
  $result = merge_hash_right_precedent($result, 
  {
    cutruntools2_organism_build => "hg38", #hg38, hg19, mm10 or mm9
    cutruntools2_bt2idx => "/data/cqs/references/gencode/GRCh38.p13/bowtie2_index_2.4.3.genome",
  });
  return($result);
}

sub gencode_mm10_options {
  my $result = merge_hash_right_precedent( mm10_options(), cutrun_options() );
  $result = merge_hash_right_precedent( $result, gencode_mm10_databases() );
  $result = merge_hash_right_precedent($result, 
  {
    cutruntools2_organism_build => "mm10", #hg38, hg19, mm10 or mm9
    cutruntools2_bt2idx => "/data/cqs/references/gencode/GRCm38.p6/bowtie2_index_2.4.3.genome",
  });
  return($result);
}

sub performCutruntools2_gencode_hg38 {
  my ( $userdef, $perform ) = @_;
  my $def = merge_hash_left_precedent( $userdef, gencode_hg38_options() );

  my $config = performCutruntools2( $def, $perform );
  return $config;
}

sub performCutruntools2_gencode_mm10 {
  my ( $userdef, $perform ) = @_;
  my $def = merge_hash_left_precedent( $userdef, gencode_mm10_options() );

  my $config = performCutruntools2( $def, $perform );
  return $config;
}

1;
