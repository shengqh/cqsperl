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
  initDefaultValue( $def, "cqstools",        "/home/shengq2/cqstools/cqstools.exe" );
  initDefaultValue( $def, "star_index",      "/scratch/cqs/shengq2/references/vickers_lincRNA/STAR_index_2.5.2b_v19_sjdb99" );
  initDefaultValue( $def, "bamplot_gff",     "/scratch/cqs/shengq2/vickers/20170314_smallRNA_GSE_human/document/lincRNAchr.gff" );
  initDefaultValue( $def, "dataset_name",    "HG19" );
  initDefaultValue( $def, "cutadapt_option", " -m 18 " );

  if ( $def->{perform_macs2} ) {
    initDefaultValue( $def, "macs2_option", "-B -q 0.01 -g hs" );
  }
  return $def;
}

sub getAGOConfig {
  my $def = shift;

  initializeDefaultOptions($def);

  my ( $config, $individual, $summary, $source_ref, $preprocessing_dir ) = getPreprocessionConfig($def);

  my $notIdenticalAlignmentTask;
  my $count_ref;
  if ( $def->{collapse} ) {
    $config->{identical} = {
      class      => "CQS::FastqIdentical",
      perform    => 1,
      target_dir => $preprocessing_dir . "/identical",
      option     => "",
      source_ref => $source_ref,
      cqstools   => $def->{cqstools},
      extension  => "_clipped_identical.fastq.gz",
      sh_direct  => 1,
      cluster    => $def->{cluster},
      pbs        => {
        "email"    => $def->{email},
        "nodes"    => "1:ppn=1",
        "walltime" => "24",
        "mem"      => "20gb"
      },
    };

    if ( $def->{perform_star} ) {
      $config->{star_notidentical} = {
        class                     => "Alignment::STAR",
        perform                   => 1,
        target_dir                => $def->{target_dir} . "/star_notidentical",
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
      $config->{star_notidentical_summary} = {
        class      => "Alignment::STARSummary",
        perform    => 1,
        target_dir => $def->{target_dir} . "/star_notidentical",
        option     => "",
        source_ref => [ "star_notidentical", "_Log.final.out" ],
        sh_direct  => 1,
        pbs        => {
          "email"    => $def->{email},
          "nodes"    => "1:ppn=1",
          "walltime" => "72",
          "mem"      => "10gb"
        },
      };

      push( @$individual, "star_notidentical" );
      push( @$summary,    "star_notidentical_summary" );
      $notIdenticalAlignmentTask = "star_notidentical";
    }
    else {
      my $bowtie_option = getValue( $def, "bowtie_option", "-v 2 -m 100 -a --best --strata" );
      $config->{bowtie1_notidentical} = {
        'class'               => 'Alignment::Bowtie1',
        'source_ref'          => $source_ref,
        'fasta_file'          => '/scratch/cqs/zhaos/vickers/reference/hg19ForAgo/bowtie_index_1.1.2/GRCh37.p13.genome.AddAC009948.fa',
        'sh_direct'           => 0,
        'perform'             => 1,
        mappedonly            => 1,
        output_to_same_folder => 1,

        #chromosome_grep_pattern => "lnc_DFNB",
        'bowtie1_index' => '/scratch/cqs/zhaos/vickers/reference/hg19ForAgo/bowtie_index_1.1.2/GRCh37.p13.genome.AddAC009948',
        'option'        => $bowtie_option,
        'target_dir'    => $def->{target_dir} . '/bowtie1_notidentical',
        'pbs'           => {
          'email'    => $def->{email},
          'walltime' => '72',
          'mem'      => '40gb',
          'nodes'    => '1:ppn=8'
        },
      };
      $config->{"bowtie1_notidentical_summary"} = {
        class                    => "CQS::UniqueR",
        perform                  => 1,
        target_dir               => $def->{target_dir} . "/bowtie1_notidentical",
        rtemplate                => "../Alignment/Bowtie1Summary.r",
        output_file              => "",
        output_file_ext          => ".csv",
        parameterSampleFile1_ref => [ "bowtie1_notidentical", ".log\$" ],
        sh_direct                => 1,
        pbs                      => {
          "email"    => $def->{email},
          "nodes"    => "1:ppn=1",
          "walltime" => "1",
          "mem"      => "10gb"
        },
      };

      push @$individual, "bowtie1_notidentical";
      push @$summary,    "bowtie1_notidentical_summary";
      $notIdenticalAlignmentTask = "bowtie1_notidentical";
    }
    $source_ref = [ "identical", ".fastq.gz\$" ];
    $count_ref  = [ "identical", ".dupcount\$" ];
    push( @$individual, "identical" );

  }

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
    my $bowtie_option = getValue( $def, "bowtie_option", "-v 2 -m 100 -a --best --strata" );
    $config->{$alignmentTask} = {
      'class'               => 'Alignment::Bowtie1',
      'source_ref'          => $source_ref,
      'fasta_file'          => '/scratch/cqs/zhaos/vickers/reference/hg19ForAgo/bowtie_index_1.1.2/GRCh37.p13.genome.AddAC009948.fa',
      'sh_direct'           => 0,
      'perform'             => 1,
      mappedonly            => 1,
      output_to_same_folder => 1,

      #chromosome_grep_pattern => "lnc_DFNB",
      'bowtie1_index' => '/scratch/cqs/zhaos/vickers/reference/hg19ForAgo/bowtie_index_1.1.2/GRCh37.p13.genome.AddAC009948',
      'option'        => $bowtie_option,
      'target_dir'    => $def->{target_dir} . '/bowtie1',
      'pbs'           => {
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

  if ( !defined $notIdenticalAlignmentTask ) {
    $notIdenticalAlignmentTask = $alignmentTask;
  }

  $config->{smallrna_count} = {
    'pbs' => {
      'email'     => 'quanhu.sheng@vanderbilt.edu',
      'walltime'  => '72',
      'emailType' => undef,
      'mem'       => '40gb',
      'nodes'     => '1:ppn=1'
    },
    'cluster'         => 'slurm',
    'fasta_file'      => '/scratch/cqs/shengq2/references/smallrna/v3/hg19_miRBase21_GtRNAdb2_gencode19_ncbi.bed.fa',
    'sh_direct'       => 1,
    'perform'         => 1,
    'target_dir'      => $def->{target_dir} . "/smallrna_count",
    'fastq_files_ref' => $source_ref,
    'coordinate_file' => '/scratch/cqs/shengq2/references/smallrna/v3/hg19_miRBase21_GtRNAdb2_gencode19_ncbi.bed',
    'source_ref'      => $alignmentTask,
    'seqcount_ref'    => $count_ref,
    'cqs_tools'       => '/home/shengq2/cqstools/cqstools.exe',
    'class'           => 'CQS::SmallRNACount',
    'option'          => ''
  };

  $config->{smallrna_table} = {
    'pbs' => {
      'email'     => 'quanhu.sheng@vanderbilt.edu',
      'walltime'  => '10',
      'emailType' => undef,
      'mem'       => '10gb',
      'nodes'     => '1:ppn=1'
    },
    'cluster'    => 'slurm',
    'sh_direct'  => 1,
    'hasYRNA'    => 0,
    'perform'    => 1,
    'target_dir' => $def->{target_dir} . "/smallrna_table",
    'source_ref' => [ 'smallrna_count', '.mapped.xml' ],
    'cqs_tools'  => '/home/shengq2/cqstools/cqstools.exe',
    'class'      => 'CQS::SmallRNATable',
    'option'     => '',
    'prefix'     => 'smallRNA_2mm_'
  };

  $config->{chrlnc_count} = {
    class        => "CQS::CQSChromosomeCount",
    perform      => 1,
    target_dir   => $def->{target_dir} . "/chrlnc_count",
    option       => "--chromosomePattern lnc_DFNB",
    source_ref   => $alignmentTask,
    seqcount_ref => $count_ref,
    cqs_tools    => $def->{cqstools},
    sh_direct    => 1,
    cluster      => $def->{cluster},
    pbs          => {
      "email"     => $def->{email},
      "emailType" => $def->{emailType},
      "nodes"     => "1:ppn=1",
      "walltime"  => "72",
      "mem"       => "40gb"
    },
  };

  $config->{chrlnc_table} = {
    class      => "CQS::CQSChromosomeTable",
    perform    => 1,
    target_dir => $def->{target_dir} . "/chrlnc_table",
    option     => "",
    source_ref => [ "chrlnc_count", ".xml" ],
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
  push @$individual, ( "smallrna_count", "chrlnc_count" );
  push @$summary,    ( "smallrna_table", "chrlnc_table" );

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
      'source_ref'         => $notIdenticalAlignmentTask,
      'class'              => 'Visualization::Bamplot',
      'option'             => '-g ' . $def->{dataset_name} . ' -y uniform -r --save-temp',
      'is_draw_individual' => 0
    };
    push @$summary, "bamplot";
  }

  if ( $def->{perform_macs2} ) {
    my $groups = {};
    my $files  = $def->{files};
    my @sampleNames;
    if ( ref($files) eq 'ARRAY' ) {
      @sampleNames = @$files;
    }
    else {
      @sampleNames = sort keys %$files;
    }
    for my $sampleName (@sampleNames) {
      $groups->{$sampleName} = [$sampleName];
    }
    $config->{macs2} = {
      class      => "Chipseq::MACS2Callpeak",
      perform    => 1,
      target_dir => $def->{target_dir} . "/macs2",
      option     => getValue( $def, "macs2_option" ),
      source_ref => [ $notIdenticalAlignmentTask, ".bam\$" ],
      groups     => $groups,
      sh_direct  => 0,
      pbs        => {
        "email"    => $def->{email},
        "nodes"    => "1:ppn=1",
        "walltime" => "72",
        "mem"      => "40gb"
      },
    };
    push @$individual, ("macs2");

    my $geneName = "macs2_annotation";
    $config->{$geneName} = {
      class           => "Annotation::FindOverlapGene",
      perform         => 1,
      target_dir      => $def->{target_dir} . "/macs2",
      source_ref      => [ "macs2", "Peak.bed\$" ],
      gene_sorted_bed => "/scratch/cqs/shengq2/references/smallrna/v3/hg19_miRBase21_GtRNAdb2_gencode19_ncbi.sorted.bed",
      sh_direct       => 1,
      pbs             => {
        "email"     => $def->{email},
        "emailType" => $def->{emailType},
        "nodes"     => "1:ppn=1",
        "walltime"  => "1",
        "mem"       => "10gb"
      },
    };
    push @$summary, ($geneName);
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

