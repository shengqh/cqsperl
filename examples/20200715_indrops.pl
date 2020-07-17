#!/usr/bin/perl
use strict;
use warnings;

use CQS::FileUtils;
use CQS::SystemUtils;
use CQS::ConfigUtils;
use CQS::ClassFactory;

my $target_dir = create_directory_or_die("/scratch/cqs/shengq2/test/20200715_indrops");
my $email = "quanhu.sheng.1\@vumc.org";

my $config = {
  general => { 
    task_name => "indrops",
    docker_command => "singularity exec -e /scratch/cqs_share/softwares/singularity/indrops.simg",
    cluster    => "slurm",
  },
  files   => {
    "457-AS-3B_S3" => ["/data/cqs/ramirema/ken_lau/20200529_457_AS/457-AS-3B_S3_R1_001.fastq.gz", "/data/cqs/ramirema/ken_lau/20200529_457_AS/457-AS-3B_S3_R2_001.fastq.gz"],
    "457-AS-4B_S4" => ["/data/cqs/ramirema/ken_lau/20200529_457_AS/457-AS-4B_S4_R1_001.fastq.gz", "/data/cqs/ramirema/ken_lau/20200529_457_AS/457-AS-4B_S4_R2_001.fastq.gz"],
    "457-AS-5B_S5" => ["/data/cqs/ramirema/ken_lau/20200529_457_AS/457-AS-5B_S5_R1_001.fastq.gz", "/data/cqs/ramirema/ken_lau/20200529_457_AS/457-AS-5B_S5_R2_001.fastq.gz"],
  },
  indrops => {
    class      => "scRNA::Indrops",
    perform    => 1,
    target_dir => "${target_dir}/indrops",
    option     => "",
    source_ref => "files",
    bowtie_index => "/scratch/cqs/ramirema/ken_lau/bowtie_index/Mus_musculus.GRCm38.85.annotated.AppleGFP/Mus_musculus.GRCm38.85.annotated.AppleGFP",
    indrops_script => "/opt/indrops/indrops.py",
    sh_direct  => 0,
    pbs        => {
      "email"    => $email,
      "nodes"    => "1:ppn=1",
      "walltime" => "24",
      "mem"      => "40gb"
    },
  },
};

performConfig($config);

1;

