#!/usr/bin/perl
use strict;
use warnings;

use CQS::FileUtils;
use CQS::SystemUtils;
use CQS::ConfigUtils;
use CQS::ClassFactory;
use CQS::PerformExomeSeq;
use Pipeline::WdlPipeline;

my $def = gatk_hg19_genome();

my $config = {
  general => {
    task_name => "gatk_hg19",
    email      => "quanhu.sheng.1\@vumc.org",
  },
  files      => {
    "Normal_99-24902" => [ "/scratch/cqs/ramirema/20190610_Ciombior_ExomeSeq/results/bwa_refine/result/Normal_99-24902.rmdup.indel.recal.bam",  "/scratch/cqs/ramirema/20190610_Ciombior_ExomeSeq/results/bwa_refine/result/Normal_99-24902.rmdup.indel.recal.bai" ],
    "Tumor_99-24902" => [ "/scratch/cqs/ramirema/20190610_Ciombior_ExomeSeq/results/bwa_refine/result/Tumor_99-24902.rmdup.indel.recal.bam",  "/scratch/cqs/ramirema/20190610_Ciombior_ExomeSeq/results/bwa_refine/result/Tumor_99-24902.rmdup.indel.recal.bai" ],
  },
  groups => {
    "99-24902" => ["Normal_99-24902", "Tumor_99-24902"],
  },
  "singularity_image_files" => $def->{"singularity_image_files"},
};

my $target_dir = create_directory_or_die("/scratch/cqs/shengq2/temp/20200702_Exomeseq_mutect2_fromBAM");
my $summary = [];

my $mutect2task = addMutect2($config, $def, $summary, $target_dir, "files");

performConfig($config);

1;

