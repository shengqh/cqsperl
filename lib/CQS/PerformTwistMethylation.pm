#!/usr/bin/perl
package CQS::PerformTwistMethylation;

use strict;
use warnings;
use Pipeline::TwistMethylation;
use CQS::Global;
use CQS::ConfigUtils;
use CQS::PerformExomeSeq;

require Exporter;
our @ISA = qw(Exporter);

our %EXPORT_TAGS = (
  'all' => [
    qw(
      performTwistMethylation_gencode_hg38
    )
  ]
);

our @EXPORT = ( @{ $EXPORT_TAGS{'all'} } );

our $VERSION = '0.01';

sub global_definition {
  my $result = merge_hash_right_precedent(global_options(), {
    docker_command => images()->{"exomeseq"},
  });

  return($result);
}

sub gencode_hg38_genome {
  my $global_hg38 = merge_hash_right_precedent(hg38_options(), global_definition());
  return(merge_hash_right_precedent($global_hg38, gencode_hg38_databases()));
}

sub performTwistMethylation_gencode_hg38 {
  my ( $userdef, $perform ) = @_;
  my $def = merge_hash_left_precedent( $userdef, gencode_hg38_genome() );
  my $config = performTwistMethylation( $def, $perform );
  return $config;
}


1;
