#!/usr/bin/perl
package CQS::PerformEncodeATACSeq;

use strict;
use warnings;
use Pipeline::EncodeATACseq;
use CQS::Global;
use CQS::ConfigUtils;

require Exporter;
our @ISA = qw(Exporter);

our %EXPORT_TAGS = (
  'all' => [
    qw(
      PerformEncodeATACSeq_gencode_hg38
      PerformEncodeATACSeq_gencode_mm10
      )
  ]
);

our @EXPORT = ( @{ $EXPORT_TAGS{'all'} } );

our $VERSION = '0.01';

sub global_definition {
  my $result = merge_hash_right_precedent(global_options(), {
    #"constraint" => "haswell",

    "docker_command" => singularity_prefix() . " /data/cqs/softwares/singularity/cqs-chipseq.simg",
    "report_docker_command" => singularity_prefix() . " /data/cqs/softwares/singularity/report.sif",
    "croo_docker_command" => singularity_prefix() . " /data/cqs/softwares/singularity/cqs-encode.sif",

    "use_caper" => 1,
    "encode_option" => "--backend-file /data/cqs/softwares/cqsperl/config/caper/backend.conf --singularity",
    #"encode_option" => "--singularity",
    "encode_atac_walltime" => "48",
    "atac.singularity" => "/data/cqs/softwares/singularity/atac-seq-pipeline.v2.2.2.sif",
    "croo_out_def_json" => "/data/cqs/softwares/encode/atac-seq-pipeline.v2.2.2/atac.croo.v5.json",

    "wdl" => {
      "cromwell_jar" => "/data/cqs/softwares/cromwell/cromwell-64.jar",
      "cromwell_option_file" => "/data/cqs/softwares/cromwell/cromwell.options.json",
      "local" => {
        "cromwell_config_file" => "/data/cqs/softwares/cromwell/cromwell.local.conf",
        "encode_atacseq" => {
          "wdl_file" => "/data/cqs/softwares/encode/atac-seq-pipeline.v2.2.2/atac.wdl",
          "input_file" => "/data/cqs/softwares/cqsperl/config/wdl/encode-atacseq.inputs.json"
        }
      }
    },
  });

  return($result);
}

sub gencode_hg38_genome {
  return merge_hash_right_precedent(global_definition(), {
    "encode_atacseq_genome_tsv" => "/data/cqs/references/encode-pipeline-genome-data/hg38/hg38.tsv",
  });
}

sub gencode_mm10_genome {
  return merge_hash_right_precedent(global_definition(), {
    "encode_atacseq_genome_tsv" => "/data/cqs/references/encode-pipeline-genome-data/mm10/mm10.tsv",
  });
}

sub init_singularity {
  my ($userdef) = @_;

  if(defined $userdef->{encode_option}){
    if (not $userdef->{encode_option} =~ /singularity/){
      $userdef->{encode_option} = $userdef->{encode_option} . " --singularity";
    }
  }
}

sub PerformEncodeATACSeq_gencode_hg38 {
  my ($userdef, $perform) = @_;

  init_singularity($userdef);

  my $def = merge_hash_left_precedent($userdef, gencode_hg38_genome());
  my $config = performEncodeATACseq($def, $perform);
  return $config;
}

sub PerformEncodeATACSeq_gencode_mm10 {
  my ($userdef, $perform) = @_;

  init_singularity($userdef);

  my $def = merge_hash_left_precedent($userdef, gencode_mm10_genome());
  my $config = performEncodeATACseq($def, $perform);
  return $config;
}

1;
