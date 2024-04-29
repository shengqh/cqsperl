#!/usr/bin/perl
package CQS::PerformWGSByWDL;

use strict;
use warnings;
use CQS::FileUtils;
use CQS::SystemUtils;
use CQS::ConfigUtils;
use CQS::ClassFactory;
use Pipeline::PipelineUtils;
use Pipeline::Preprocession;
use Pipeline::WdlPipeline;
use CQS::PerformExomeSeq;
use Data::Dumper;
use Hash::Merge qw( merge );

require Exporter;
our @ISA = qw(Exporter);

our %EXPORT_TAGS = ( 'all' => [qw(performWGSByWDL)] );

our @EXPORT = ( @{ $EXPORT_TAGS{'all'} } );

our $VERSION = '0.01';

sub initializeDefaultOptions {
  my $def = shift;

  return $def;
}

sub getConfig {
  my ($def) = @_;
  $def->{VERSION} = $VERSION;

  my $target_dir = $def->{target_dir};
  create_directory_or_die($target_dir);

  $def = initializeDefaultOptions($def);

  my ( $config, $individual, $summary, $source_ref, $preprocessing_dir, $untrimed_ref, $cluster ) = getPreprocessionConfig($def);

  #print(Dumper($config));

  #merge summary and individual 
  my $tasks = [@$individual, @$summary];
  $summary = undef;
  $individual = undef;
  
  my $wdl = global_definition()->{wdl};
  my $server_key = "local";
  my $server = $wdl->{$server_key};

  my $fastq_1 = "fastq_1";
  $config->{$fastq_1} = {     
    "class" => "CQS::FilePickTask",
    "source_ref" => "files",
    "sample_index" => 0, 
  };
  
  my $fastq_2 = "fastq_2";
  $config->{$fastq_2} = {     
    "class" => "CQS::FilePickTask",
    "source_ref" => "files",
    "sample_index" => 1, 
  };
  
  my $fastq_to_bam_name = getValue($def, "fastq_to_bam_name", "VUMCFastqToAlignedCramNoBamQCFast");
  my $fastq_to_bam_wdl = getValue($def, "fastq_to_bam_wdl", "/nobackup/h_cqs/shengq2/program/warp/pipelines/vumc_biostatistics/dna_seq/germline/single_sample/wgs/VUMCFastqToAlignedCramNoBamQCFast.wdl");
  my $fastq_to_bam_inputs = getValue($def, "fastq_to_bam_inputs", "/nobackup/h_cqs/shengq2/program/cqsperl/lib/CQS/VUMCFastqToAlignedCramNoBamQCFast.inputs.json");

  my $task = "fastq_to_bam";
  $config->{$task} = {     
    "class" => "CQS::Wdl",
    "target_dir" => "${target_dir}/$task",
    "source_ref" => $source_ref,
    "cromwell_jar" => $wdl->{"cromwell_jar"},
    "input_option_file" => $wdl->{"cromwell_option_file"},
    "cromwell_config_file" => $server->{"cromwell_config_file"},
    "wdl_file" => $fastq_to_bam_wdl,
    "input_json_file" => $fastq_to_bam_inputs,
    "use_caper" => 1,
    "input_parameters" => {
      "$fastq_to_bam_name.fastq_1_ref" => [$fastq_1],
      "$fastq_to_bam_name.fastq_2_ref" => [$fastq_2],
      "$fastq_to_bam_name.sample_name" => "SAMPLE_NAME",
      "$fastq_to_bam_name.library_name" => "SAMPLE_NAME",
      "$fastq_to_bam_name.readgroup_name" => "SAMPLE_NAME"
    },
    "input_parameters_is_vector" => {
      "$fastq_to_bam_name.fastq_1" => 1,
      "$fastq_to_bam_name.fastq_2" => 1,
    },
    output_file_ext => ".cram",
    pbs=> {
      "nodes"     => "1:ppn=16",
      "walltime"  => "24",
      "mem"       => getValue($def, "$fastq_to_bam_name.memory", "40gb")
    },
  },

  $config->{sequencetask} = {
    class => "CQS::SequenceTaskSlurmSlim",
    perform => 1,
    target_dir            => "${target_dir}/sequencetask",
    option                => "",
    source                => {
      processing => $tasks,
    },
    sh_direct             => 1,
    pbs                   => {
      "nodes"    => "1:ppn=8",
      "walltime" => "24",
      "mem"      => "40gb"
    },
  };

  return($config);
};

sub performWGSByWDL {
  my ( $def, $perform ) = @_;
  if ( !defined $perform ) {
    $perform = 1;
  }

  my $config = getConfig($def);

  if ($perform) {
    saveConfig( $def, $config );

    performConfig($config);
  }

  return $config;
}

1;
