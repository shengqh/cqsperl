#!/usr/bin/perl
use strict;
use warnings;

use CQS::FileUtils;
use CQS::SystemUtils;
use CQS::ConfigUtils;
use CQS::ClassFactory;
use CQS::Global;
use Pipeline::WdlPipeline;
use Data::Dumper;

my $mem          = "80gb";
my $bwa_walltime = 24;

my $target_dir = create_directory_or_die( "/nobackup/h_cqs/shengq2/temp/20260917_GATKSVPipelineSingleSample" );


my $def = merge_hash_right_precedent( global_options(),  {
  task_name    => "GATKSV",
  email        => "quanhu.sheng.1\@vumc.org",
  "email-type" => "FAIL",
  target_dir   => $target_dir,

  files => { "K4_75M" => [ "/nobackup/h_vangard_1/wangy67/PI_Park/20260706_cfDNA_downsample_Allen/gatk4_05_BamToCram/result/K4_75M.cram", "/nobackup/h_vangard_1/wangy67/PI_Park/20260706_cfDNA_downsample_Allen/gatk4_05_BamToCram/result/K4_75M.cram.crai" ], },

  wdl_key => "local",
  wdl     => {
    "local" => {
      "GATKSVPipelineSingleSample" => {
        wdl_file   => "/data/cqs/softwares/gatk-sv/repo/gatk-sv/wdl/GATKSVPipelineSingleSample.wdl",
        input_file => "/nobackup/h_cqs/shengq2/program/cqsperl/config/wdl/GATKSVPipelineSingleSample.base.localized.json",
      }
    },
    "slurm" => {
      "GATKSVPipelineSingleSample" => {
        wdl_file   => "/data/cqs/softwares/gatk-sv/repo/gatk-sv/wdl/GATKSVPipelineSingleSample.wdl",
        input_file => "/nobackup/h_cqs/shengq2/program/cqsperl/config/wdl/GATKSVPipelineSingleSample.base.localized.json",
      }
    }
  },
});

my $config = {
  general => {
    task_name => $def->{task_name},
    email => $def->{email},
    emailType => $def->{emailType},
    target_dir => $target_dir,
  },
  files => $def->{files},
};

my $tasks = [];
my $gatk_sv_task = "GATKSVPipelineSingleSample";

$config = add_GATKSVPipelineSingleSample( $config, $def, $tasks, $target_dir, $gatk_sv_task, "files" );

performTaskByPattern($config, $gatk_sv_task);

1;

