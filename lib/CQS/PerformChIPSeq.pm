#!/usr/bin/perl
package CQS::PerformChIPSeq;

use strict;
use warnings;
use Pipeline::ChIPSeq;
use CQS::Global;
use CQS::ConfigUtils;
use Hash::Merge qw( merge );

require Exporter;
our @ISA = qw(Exporter);

our %EXPORT_TAGS = (
  'all' => [
      "performChIPSeq_gencode_hg19",
      "performChIPSeq_gencode_hg38",
      "performChIPSeq_gencode_mm10",
  ]
);

our @EXPORT = ( @{ $EXPORT_TAGS{'all'} } );

our $VERSION = '0.01';

sub chipseq_options {
  return {
    docker_command => singularity_prefix() . " /data/cqs/softwares/singularity/cqs-chipseq.simg ",
    annovar_docker_command => singularity_prefix() . " /data/cqs/softwares/singularity/cqs-exomeseq.simg ",
    picard_jar     => "/opt/picard.jar",

    perform_cutadapt => 0,

    aligner => "bowtie2",

    perform_cleanbam  => 1,
    remove_chromosome => "M",
    keep_chromosome   => "chr",

    peak_caller => "macs",

    perform_enhancer   => 0,
    enhancer_folder    => "/scratch/cqs_share/local/bin/linlabpipeline",
    enhancer_gsea_path => "/scratch/cqs_share/tools/gsea/gsea2-2.2.3.jar",
    enhancer_gmx_path  => "/scratch/cqs_share/tools/gsea/c2.all.v5.2.symbols.gmt",

    rose_folder => "/scratch/cqs_share/local/bin/bradnerlab",

    perform_chipqc => 1,

    homer_option => "",
  };
}

sub gencode_hg19_options {
  my $result = merge_hash_right_precedent( hg19_options(), chipseq_options() );
  $result = merge_hash_right_precedent( $result, gencode_hg19_databases() );
  $result = merge_hash_right_precedent($result, 
  {
    annovar_buildver => "hg19",
    annovar_param => "-protocol refGene -operation g --remove",
    annovar_db => "/data/cqs/references/annovar/humandb/",
  });
  return($result);
}

sub gencode_hg38_options {
  my $result = merge_hash_right_precedent( hg38_options(), chipseq_options() );
  $result = merge_hash_right_precedent( $result, gencode_hg38_databases() );
  $result = merge_hash_right_precedent($result, 
  {
    annovar_buildver => "hg38",
    annovar_param => "-protocol refGene -operation g --remove",
    annovar_db => "/data/cqs/references/annovar/humandb/",
  });
  return($result);
}

sub gencode_mm10_options {
  my $result = merge_hash_right_precedent( mm10_options(), chipseq_options() );
  $result = merge_hash_right_precedent( $result, gencode_mm10_databases() );
  $result = merge_hash_right_precedent($result, 
  {
    annovar_buildver => "mm10",
    annovar_param => "-protocol refGene -operation g --remove",
    annovar_db => "/data/cqs/references/annovar/mousedb/",
  });
  return($result);
}

sub performChIPSeq_gencode_hg19 {
  my ( $userdef, $perform ) = @_;
  my $def = merge_hash_left_precedent( $userdef, gencode_hg19_options() );

  my $config = performChIPSeq( $def, $perform );
  return $config;
}

sub performChIPSeq_gencode_hg38 {
  my ( $userdef, $perform ) = @_;
  my $def = merge_hash_left_precedent( $userdef, gencode_hg38_options() );

  my $config = performChIPSeq( $def, $perform );
  return $config;
}

sub performChIPSeq_gencode_mm10 {
  my ( $userdef, $perform ) = @_;
  my $def = merge_hash_left_precedent( $userdef, gencode_mm10_options() );

  my $config = performChIPSeq( $def, $perform );
  return $config;
}

1;
