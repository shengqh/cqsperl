#!/usr/bin/perl
use strict;
use warnings;

use CQS::FileUtils;
use CQS::SystemUtils;
use CQS::ConfigUtils;
use CQS::ClassFactory;
use CQS::PerformExomeSeq;
use Pipeline::WdlPipeline;

my $def = global_definition();

my $config = {
  general => {
    task_name => "convert",
    email      => "quanhu.sheng.1\@vumc.org",
  },
  singularity_image_files => $def->{singularity_image_files},
  files      => {
    "VPM150_5mM_cell"   => [ "/scratch/cqs/pipeline_example/rnaseq_data/948-WZ-1-AAGAGG_S1_R1_001.fastq.gz", "/scratch/cqs/pipeline_example/rnaseq_data/948-WZ-1-AAGAGG_S1_R2_001.fastq.gz" ],
    "VPM150_metaC_cell" => [ "/scratch/cqs/pipeline_example/rnaseq_data/948-WZ-1-GGAGAA_S2_R1_001.fastq.gz", "/scratch/cqs/pipeline_example/rnaseq_data/948-WZ-1-GGAGAA_S2_R2_001.fastq.gz" ],
  },
};

my $target_dir = create_directory_or_die("/scratch/cqs/shengq2/temp/20200706_PairedFastq2UnmappedBAM");
my $individual = [];

my $convert_task = addPairedFastqToUnmappedBam($config, $def, $individual, $target_dir, "files");

performConfig($config);

1;

