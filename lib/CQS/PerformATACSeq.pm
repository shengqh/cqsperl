#!/usr/bin/perl
package CQS::PerformATACSeq;

use strict;
use warnings;
use CQS::ConfigUtils;
use Pipeline::ATACSeq;
use CQS::Global;
use Hash::Merge qw( merge );

require Exporter;
our @ISA = qw(Exporter);

our %EXPORT_TAGS = (
  'all' => [
    qw(
      performATACSeq_gencode_hg19
      performATACSeq_gencode_hg38
      performATACSeq_gencode_mm10)
  ]
);

our @EXPORT = ( @{ $EXPORT_TAGS{'all'} } );

our $VERSION = '0.01';

sub atacseq_options {
  return {
    docker_command => singularity_prefix() . " /data/cqs/softwares/singularity/cqs-chipseq.simg ",
    picard_jar     => "/opt/picard.jar",

    perform_cutadapt => 0,

    perform_cleanbam  => 1,
    remove_chromosome => "M",
    keep_chromosome   => "chr",

    peak_caller => "macs2",
    macs2_peak_type => "broad",
  };
}

sub gencode_hg19_options {
  my $atac_hg19_options = merge_hash_right_precedent( hg19_options(), atacseq_options() );

  return merge_hash_right_precedent(
    $atac_hg19_options,
    gencode_hg19_databases()
  );
}

sub gencode_hg38_options {
  my $atac_hg38_options = merge_hash_right_precedent( hg38_options(), atacseq_options() );

  return merge_hash_right_precedent(
    $atac_hg38_options,
    gencode_hg38_databases()
  );
}

sub gencode_mm10_options {
  my $atac_mm10_options = merge_hash_right_precedent( mm10_options(), atacseq_options() );

  return merge_hash_right_precedent(
    $atac_mm10_options,
    gencode_mm10_databases()
  );
}

sub performATACSeq_gencode_hg19 {
  my ( $userdef, $perform ) = @_;
  my $def = merge_hash_left_precedent( $userdef, gencode_hg19_options() );

  my $config = performATACSeq( $def, $perform );
  return $config;
}

sub performATACSeq_gencode_hg38 {
  my ( $userdef, $perform ) = @_;
  my $def = merge_hash_left_precedent( $userdef, gencode_hg38_options() );

  my $config = performATACSeq( $def, $perform );
  return $config;
}

sub performATACSeq_gencode_mm10 {
  my ( $userdef, $perform ) = @_;
  my $def = merge_hash_left_precedent( $userdef, gencode_mm10_options() );

  my $config = performATACSeq( $def, $perform );
  return $config;
}

1;
