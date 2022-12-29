#!/usr/bin/perl
package CQS::PerformExceRpt;

use strict;
use warnings;
use CQS::Global;
use CQS::ConfigUtils;
use CQS::PerformSmallRNA;
use Pipeline::exceRpt;

require Exporter;
our @ISA = qw(Exporter);

our %EXPORT_TAGS = (
  'all' => [
    qw(performExceRpt_hg38)
  ]
);

our @EXPORT = ( @{ $EXPORT_TAGS{'all'} } );

our $VERSION = '1.0';

sub exceRpt_hg38_genome {
  return merge_hash_right_precedent(
    supplement_genome(),
    {
      exceRpt_host => "hg38",
      exceRpt_image => "/data/cqs/softwares/singularity/excerpt_latest.sif",
      exceRpt_DB => "/scratch/h_vangard_1/references/exceRpt",

      MAP_EXOGENOUS => "on", #'off'/'miRNA'/'on'

      MIN_READ_LENGTH => 16,

      software_version => {
        host => "GENCODE GRCh38.p13",
      }
    }
  );
}

sub performExceRpt_hg38 {
  my ( $userdef, $perform ) = @_;
  my $def = merge_hash_right_precedent( $userdef, exceRpt_hg38_genome() );

  my $config = performExceRpt( $def, $perform );
  return $config;
}


1;
