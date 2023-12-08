#!/usr/bin/perl
use strict;
use warnings;

use CQS::FileUtils;
use CQS::SystemUtils;
use CQS::ConfigUtils;
use CQS::ClassFactory;
use CQS::PerformRNAseq;
use Pipeline::PipelineUtils;
use Data::Dumper;

my $target_dir = create_directory_or_die("/nobackup/h_cqs/shengq2/temp/20231208_deseq2_gsea");

my $def = merge_hash_right_precedent(
  gencode_hg38_genome(), #gencode_mm10_genome()
  {
    task_name => "deseq2_gsea",
    cluster => "slurm",
    max_thread => 8,
  }
);

#print(Dumper($def));

$def = add_human_gsea($def, "Mouse"); #add_human_gsea($def, "Human"); if your sample is Human sample.

my $config = {
  general => {
    task_name => $def->{task_name},
    email => "quanhu.sheng.1\@vumc.org",
    docker_command => "singularity exec -e /nobackup/h_cqs/softwares/singularity/cqs-rnaseq.simg ",
  },
  files => {
    "ObObEthionine_vs_ObObChow" => ["/nobackup/h_cqs/softwares/cqsperl/data/ObObEthionine_vs_ObObChow_min5_fdr0.05_DESeq2_GSEA.rnk"],
  },
};

my $tasks=[];
my $gseaTaskName = "gsea";
my $rnk_file_ref = "files";
my $files = $config->{files};
my $keys = [sort keys %$files];
my $suffix = "";
add_gsea($config, $def, $tasks, $target_dir, $gseaTaskName, $rnk_file_ref, $keys, $suffix );

addSequenceTask($config, $def, $tasks, $target_dir);

performConfig($config);

1;
