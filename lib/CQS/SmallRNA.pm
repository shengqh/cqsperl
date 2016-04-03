#!/usr/bin/perl
package CQS::SmallRNA;

use strict;
use warnings;
require CQS::PerformSmallRNA;
require Exporter;
our @ISA = qw(Exporter);

our %EXPORT_TAGS = (
  'all' => [
    qw(performSmallRNA_hg19 performSmallRNATask_hg19 performSmallRNA_hg20 performSmallRNATask_hg20 performSmallRNA_mm10 performSmallRNATask_mm10 performSmallRNA_rn5 performSmallRNATask_rn5
     performSmallRNA_cel235 performSmallRNATask_cel235 performSmallRNA_cfa3 performSmallRNATask_cfa3 performSmallRNA_bta8 performSmallRNATask_bta8 performSmallRNA_eca2 performSmallRNATask_eca2
      performSmallRNA_ssc3 performSmallRNATask_ssc3 performSmallRNA_ocu2 performSmallRNATask_ocu2 performSmallRNA_oar3 performSmallRNATask_oar3 performSmallRNA_gga4 performSmallRNATask_gga4
       performSmallRNA_fca6 performSmallRNATask_fca6)
  ]
);

our @EXPORT = ( @{ $EXPORT_TAGS{'all'} } );

our $VERSION = '0.01';

sub performSmallRNA_hg19 {
  CQS::PerformSmallRNA::performSmallRNA_hg19(@_);
}

sub performSmallRNATask_hg19 {
  CQS::PerformSmallRNA::performSmallRNATask_hg19(@_);
}

sub performSmallRNA_hg20 {
  CQS::PerformSmallRNA::performSmallRNA_hg20(@_);
}

sub performSmallRNATask_hg20 {
  CQS::PerformSmallRNA::performSmallRNATask_hg20(@_);
}

sub performSmallRNA_mm10 {
  CQS::PerformSmallRNA::performSmallRNA_mm10(@_);
}

sub performSmallRNATask_mm10 {
  CQS::PerformSmallRNA::performSmallRNATask_mm10(@_);
}

sub performSmallRNA_rn5 {
  CQS::PerformSmallRNA::performSmallRNA_rn5(@_);
}

sub performSmallRNATask_rn5 {
  CQS::PerformSmallRNA::performSmallRNATask_rn5(@_);
}

sub performSmallRNA_cel235 {
  CQS::PerformSmallRNA::performSmallRNA_cel235(@_);
}

sub performSmallRNATask_cel235 {
  CQS::PerformSmallRNA::performSmallRNATask_cel235(@_);
}

sub performSmallRNA_cfa3 {
  CQS::PerformSmallRNA::performSmallRNA_cfa3(@_);
}

sub performSmallRNATask_cfa3 {
  CQS::PerformSmallRNA::performSmallRNATask_cfa3(@_);
}

sub performSmallRNA_bta8 {
  CQS::PerformSmallRNA::performSmallRNA_bta8(@_);
}

sub performSmallRNATask_bta8 {
  CQS::PerformSmallRNA::performSmallRNATask_bta8(@_);
}

sub performSmallRNA_eca2 {
  CQS::PerformSmallRNA::performSmallRNA_eca2(@_);
}

sub performSmallRNATask_eca2 {
  CQS::PerformSmallRNA::performSmallRNATask_eca2(@_);
}

sub performSmallRNA_ssc3 {
  CQS::PerformSmallRNA::performSmallRNA_ssc3(@_);
}

sub performSmallRNATask_ssc3 {
  CQS::PerformSmallRNA::performSmallRNATask_ssc3(@_);
}

sub performSmallRNA_ocu2 {
  CQS::PerformSmallRNA::performSmallRNA_ocu2(@_);
}

sub performSmallRNA_oar3 {
  CQS::PerformSmallRNA::performSmallRNA_oar3(@_);
}

sub performSmallRNATask_oar3 {
  CQS::PerformSmallRNA::performSmallRNATask_oar3(@_);
}

sub performSmallRNA_gga4 {
  CQS::PerformSmallRNA::performSmallRNA_gga4(@_);
}

sub performSmallRNATask_gga4 {
  CQS::PerformSmallRNA::performSmallRNATask_gga4(@_);
}

sub performSmallRNA_fca6 {
  CQS::PerformSmallRNA::performSmallRNA_fca6(@_);
}

sub performSmallRNATask_fca6 {
  CQS::PerformSmallRNA::performSmallRNATask_fca6(@_);
}

1;
