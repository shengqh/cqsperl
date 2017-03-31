#!/usr/bin/perl
package CQS::GSEHumanIP;

use strict;
use warnings;

use CQS::ClassFactory;
use CQS::FileUtils;
use CQS::ConfigUtils;
use Pipeline::PipelineUtils;
use Pipeline::Preprocession;
use Hash::Merge qw( merge );

require Exporter;
our @ISA = qw(Exporter);

our %EXPORT_TAGS = ( 'all' => [qw(getAGOConfig)] );

our @EXPORT = ( @{ $EXPORT_TAGS{'all'} } );

sub getAGOConfig {
  my $def = shift;

  initDefaultValue( $def, "cutadapt_option", "-m 20 --trim-n" );

  my ( $config, $individual, $summary, $source_ref, $preprocessing_dir ) = getPreprocessionConfig($def);

  if ( $def->{perform_star} ) {
    $config->{star} = {
      class                     => "Alignment::STAR",
      perform                   => 1,
      target_dir                => $def->{target_dir} . "/star",
      option                    => "--twopassMode Basic",
      source_ref                => $source_ref,
      genome_dir                => $def->{star_index},
      output_to_same_folder     => 1,
      output_sort_by_coordinate => 1,
      sh_direct                 => 0,
      pbs                       => {
        "email" => $def->{email},
        ,
        "nodes"    => "1:ppn=8",
        "walltime" => "72",
        "mem"      => "40gb"
      },
    };
    push( @$individual, "star" );
  }
  else {
    $config->{'bowtie1'} = {
      'pbs' => {
        'email'    => $def->{email},
        'walltime' => '72',
        'mem'      => '40gb',
        'nodes'    => '1:ppn=8'
      },
      'source_ref'            => $source_ref,
      'fasta_file'            => '/scratch/cqs/zhaos/vickers/reference/hg19ForAgo/bowtie_index_1.1.2/GRCh37.p13.genome.AddAC009948.fa',
      'sh_direct'             => 0,
      'perform'               => 1,
      mappedonly              => 1,
      output_to_same_folder   => 1,
      'bowtie1_index'         => '/scratch/cqs/zhaos/vickers/reference/hg19ForAgo/bowtie_index_1.1.2/GRCh37.p13.genome.AddAC009948',
      'option'                => '-v 2 -m 10 --best --strata',
      'target_dir'            => $def->{target_dir} . '/bowtie1',
      'class'                 => 'Alignment::Bowtie1',
      chromosome_grep_pattern => "chrlnc",
    };
    push( @$individual, "bowtie1" );
  }

  #push( @$summary,    "bamplot" );

  $config->{'bamplot'} = {
    'pbs' => {
      'email'    => $def->{email},
      'walltime' => '1',
      'mem'      => '10gb',
      'nodes'    => '1:ppn=1'
    },
    'is_single_pdf'      => 1,
    'sh_direct'          => 1,
    'is_rainbow_color'   => 0,
    'perform'            => 0,
    'target_dir'         => $def->{target_dir} . '/bamplot',
    'gff_file'           => '/scratch/cqs/shengq1/vickers/20170314_smallRNA_GSE_human/document/lincRNA.gff',
    'source_ref'         => 'bowtie1',
    'class'              => 'Visualization::Bamplot',
    'option'             => '-g HG19 -y uniform -r',
    'is_draw_individual' => 0
  };
  $config->{sequencetask} = {
    class      => "CQS::SequenceTask",
    perform    => 1,
    target_dir => $def->{target_dir} . "/sequencetask",
    option     => "",
    source     => {
      step1 => $individual,
      step2 => $summary,
    },
    sh_direct => 0,
    pbs       => {
      "email"    => $def->{email},
      "nodes"    => "1:ppn=8",
      "walltime" => "72",
      "mem"      => "40gb"
    },
  };
  return $config;
}
1;

