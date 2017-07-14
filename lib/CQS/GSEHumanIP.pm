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

sub initializeDefaultOptions {
  my $def = shift;
  initDefaultValue( $def, "cutadapt_option", "-m 20 --trim-n -q 20" );
  initDefaultValue( $def, "cqstools",        "/home/shengq1/cqstools/cqstools.exe" );
  initDefaultValue( $def, "star_index",      "/scratch/cqs/shengq1/references/vickers_lincRNA/STAR_index_2.5.2b_v19_sjdb99" );
  initDefaultValue( $def, "bamplot_gff",     "/scratch/cqs/shengq1/vickers/20170314_smallRNA_GSE_human/document/lincRNAchr.gff" );
  initDefaultValue( $def, "dataset_name",    "HG19" );
  return $def;
}

sub getAGOConfig {
  my $def = shift;

  initializeDefaultOptions($def);

  my ( $config, $individual, $summary, $source_ref, $preprocessing_dir ) = getPreprocessionConfig($def);

  my $alignmentTask;
  if ( $def->{perform_star} ) {
    $alignmentTask = "star";
    $config->{star} = {
      class                     => "Alignment::STAR",
      perform                   => 1,
      target_dir                => $def->{target_dir} . "/star",
      option                    => "--twopassMode Basic",
      source_ref                => $source_ref,
      genome_dir                => $def->{star_index},
      output_to_same_folder     => 1,
      output_sort_by_coordinate => 1,
      chromosome_grep_pattern   => "chrlnc",
      sh_direct                 => 0,
      pbs                       => {
        "email"    => $def->{email},
        "nodes"    => "1:ppn=8",
        "walltime" => "72",
        "mem"      => "40gb"
      },
    };
    $config->{star_summary} = {
      class      => "Alignment::STARSummary",
      perform    => 1,
      target_dir => $def->{target_dir} . "/star",
      option     => "",
      source_ref => [ "star", "_Log.final.out" ],
      sh_direct  => 1,
      pbs        => {
        "email"    => $def->{email},
        "nodes"    => "1:ppn=1",
        "walltime" => "72",
        "mem"      => "10gb"
      },
    };

    push( @$individual, "star" );
    push( @$summary,    "star_summary" );
  }
  else {
    $alignmentTask = "bowtie1";
    $config->{$alignmentTask} = {
      'class'                 => 'Alignment::Bowtie1',
      'source_ref'            => $source_ref,
      'fasta_file'            => '/scratch/cqs/zhaos/vickers/reference/hg19ForAgo/bowtie_index_1.1.2/GRCh37.p13.genome.AddAC009948.fa',
      'sh_direct'             => 0,
      'perform'               => 1,
      mappedonly              => 1,
      output_to_same_folder   => 1,
      chromosome_grep_pattern => "chrlnc",
      'bowtie1_index'         => '/scratch/cqs/zhaos/vickers/reference/hg19ForAgo/bowtie_index_1.1.2/GRCh37.p13.genome.AddAC009948',
      'option'                => '-v 2 -m 100 -a --best --strata',
      'target_dir'            => $def->{target_dir} . '/bowtie1',
      'pbs'                   => {
        'email'    => $def->{email},
        'walltime' => '72',
        'mem'      => '40gb',
        'nodes'    => '1:ppn=8'
      },
    };
    $config->{"bowtie1_summary"} = {
      class                    => "CQS::UniqueR",
      perform                  => 1,
      target_dir               => $def->{target_dir} . "/bowtie1",
      rtemplate                => "../Alignment/Bowtie1Summary.r",
      output_file              => "",
      output_file_ext          => ".csv",
      parameterSampleFile1_ref => [ "bowtie1", ".log\$" ],
      sh_direct                => 1,
      pbs                      => {
        "email"    => $def->{email},
        "nodes"    => "1:ppn=1",
        "walltime" => "1",
        "mem"      => "10gb"
      },
    };

    push @$individual, "bowtie1";
    push @$summary,    "bowtie1_summary";
  }

  $config->{count} = {
    class      => "CQS::CQSChromosomeCount",
    perform    => 1,
    target_dir => $def->{target_dir} . "/count",
    option     => "",
    source_ref => $alignmentTask,
    cqs_tools  => $def->{cqstools},
    sh_direct  => 1,
    cluster    => $def->{cluster},
    pbs        => {
      "email"     => $def->{email},
      "emailType" => $def->{emailType},
      "nodes"     => "1:ppn=1",
      "walltime"  => "72",
      "mem"       => "40gb"
    },
  };

  $config->{count_table} = {
    class      => "CQS::CQSChromosomeTable",
    perform    => 1,
    target_dir => $def->{target_dir} . "/count_table",
    option     => "",
    source_ref => [ "count", ".xml" ],
    cqs_tools  => $def->{cqstools},
    sh_direct  => 1,
    cluster    => $def->{cluster},
    pbs        => {
      "email"     => $def->{email},
      "emailType" => $def->{emailType},
      "nodes"     => "1:ppn=1",
      "walltime"  => "10",
      "mem"       => "10gb"
    },
  };
  push @$individual, "count";
  push @$summary,    "count_table";

  #push( @$summary,    "bamplot" );
  if ( $def->{perform_bamplot} ) {
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
      'perform'            => 1,
      'target_dir'         => $def->{target_dir} . '/bamplot',
      'gff_file'           => $def->{bamplot_gff},
      'source_ref'         => $alignmentTask,
      'class'              => 'Visualization::Bamplot',
      'option'             => '-g ' . $def->{dataset_name} . ' -y uniform -r --save-temp',
      'is_draw_individual' => 0
    };
    push @$summary, "bamplot";
  }

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

