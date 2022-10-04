#!/usr/bin/perl
package CQS::PerformWholeGenomeSeq;

use strict;
use warnings;
use Storable qw(dclone);
use CQS::StringUtils;
use Pipeline::WGS;
use CQS::PerformExomeSeq;
use CQS::Global;
use CQS::ConfigUtils;

require Exporter;
our @ISA = qw(Exporter);

our %EXPORT_TAGS = ( 'all' => [qw(
  performWholeGenomeSeq_gatk_hg38 
  performWholeGenomeSeq_gatk_hg19 
  performWholeGenomeSeq_gencode_mm10
  )] );

our @EXPORT = ( @{ $EXPORT_TAGS{'all'} } );

our $VERSION = '0.01';

sub performWholeGenomeSeq_gatk_hg38 {
  my ( $userdef, $perform ) = @_;
  my $def = merge_hash_left_precedent( $userdef, gatk_hg38_genome(1) );
  my $config = performWGS( $def, $perform );
  return $config;
}

sub performWholeGenomeSeq_gatk_hg19 {
  my ( $userdef, $perform ) = @_;
  my $def = merge_hash_left_precedent( $userdef, gatk_hg19_genome(1) );
  my $config = performWGS( $def, $perform );
  return $config;
}

sub performWholeGenomeSeq_gencode_mm10 {
  my ( $userdef, $perform ) = @_;
  my $def = merge_hash_left_precedent( $userdef, gencode_mm10_genome(1) );
  my $config = performWGS( $def, $perform );
  return $config;
}

1;
