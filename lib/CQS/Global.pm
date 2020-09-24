#!/usr/bin/perl
package CQS::Global;

use strict;
use warnings;

require Exporter;
our @ISA = qw(Exporter);

our %EXPORT_TAGS = (
  'all' => [
    qw(
      global_options
    )
  ]
);

our @EXPORT = ( @{ $EXPORT_TAGS{'all'} } );

our $VERSION = '0.01';

sub global_options {
  return {
    constraint => "haswell",
    sratoolkit_setting_file => "/scratch/cqs_share/softwares/cqsperl/config/vdb-config/user-settings.mkfg",
    bamplot_docker_command => "singularity exec -e /scratch/cqs_share/softwares/singularity/bamplot.simg ",
    BWA_docker_command => "singularity exec -e /scratch/cqs_share/softwares/singularity/cqs-exomeseq.simg ",
  };
}

1;
