#!/usr/bin/perl
use strict;
use warnings;
use CQS::FileUtils;
use CQS::SystemUtils;
use CQS::ConfigUtils;
use CQS::ClassFactory;
use CQS::PerformExomeSeq;
use Pipeline::WdlPipeline;
use Pipeline::Preprocession;
use Pipeline::PipelineUtils;
use Data::Dumper;

my $target_dir = create_directory_or_die("/nobackup/h_cqs/shengq2/temp/20240411_Wilson11085_16sRNA");

my $def = merge_hash_right_precedent(gatk_hg38_genome(),
  {
    task_name => "Wilson1108516Sexp1",
    email      => "yu.wang.2\@vumc.org",

    mothurPipelineCodeFile => "/home/zhaos/source/ngsperl/lib/Microbiome/mothurPipeline.code",
    mothurSilvaFile => "/data/cqs/references/mothur/silva/silva.seed_v132.pcr.align",
    mothurTrainsetFastaFile => "/data/cqs/references/mothur/trainset16_022016.pds/trainset16_022016.pds.fasta",
    mothurTrainsetTaxFile => "/data/cqs/references/mothur/trainset16_022016.pds/trainset16_022016.pds.tax",
  }
);

my $config = {
  general => {
    task_name => $def->{task_name},
    email => $def->{email},
    target_dir => $target_dir,
  },
  files      => {
    "C57S1"     => [ "/data/h_vangard_1/WilsonKeith_data/20240411_Wilson11085_16sRNA/data/11085-AG-0001_S1_L001_R1_001.fastq.gz", "/data/h_vangard_1/WilsonKeith_data/20240411_Wilson11085_16sRNA/data/11085-AG-0001_S1_L001_R2_001.fastq.gz" ],
    "C57S2"     => [ "/data/h_vangard_1/WilsonKeith_data/20240411_Wilson11085_16sRNA/data/11085-AG-0002_S2_L001_R1_001.fastq.gz", "/data/h_vangard_1/WilsonKeith_data/20240411_Wilson11085_16sRNA/data/11085-AG-0002_S2_L001_R2_001.fastq.gz" ],
    "C57S3"     => [ "/data/h_vangard_1/WilsonKeith_data/20240411_Wilson11085_16sRNA/data/11085-AG-0003_S3_L001_R1_001.fastq.gz", "/data/h_vangard_1/WilsonKeith_data/20240411_Wilson11085_16sRNA/data/11085-AG-0003_S3_L001_R2_001.fastq.gz" ],
    "C57S4"     => [ "/data/h_vangard_1/WilsonKeith_data/20240411_Wilson11085_16sRNA/data/11085-AG-0004_S4_L001_R1_001.fastq.gz", "/data/h_vangard_1/WilsonKeith_data/20240411_Wilson11085_16sRNA/data/11085-AG-0004_S4_L001_R2_001.fastq.gz" ],
    "C57S5"     => [ "/data/h_vangard_1/WilsonKeith_data/20240411_Wilson11085_16sRNA/data/11085-AG-0005_S5_L001_R1_001.fastq.gz", "/data/h_vangard_1/WilsonKeith_data/20240411_Wilson11085_16sRNA/data/11085-AG-0005_S5_L001_R2_001.fastq.gz" ],
    "C57S6"     => [ "/data/h_vangard_1/WilsonKeith_data/20240411_Wilson11085_16sRNA/data/11085-AG-0006_S6_L001_R1_001.fastq.gz", "/data/h_vangard_1/WilsonKeith_data/20240411_Wilson11085_16sRNA/data/11085-AG-0006_S6_L001_R2_001.fastq.gz" ],
    "C57TAMS7"  => [ "/data/h_vangard_1/WilsonKeith_data/20240411_Wilson11085_16sRNA/data/11085-AG-0007_S7_L001_R1_001.fastq.gz", "/data/h_vangard_1/WilsonKeith_data/20240411_Wilson11085_16sRNA/data/11085-AG-0007_S7_L001_R2_001.fastq.gz" ],
    "C57TAMS8"  => [ "/data/h_vangard_1/WilsonKeith_data/20240411_Wilson11085_16sRNA/data/11085-AG-0008_S8_L001_R1_001.fastq.gz", "/data/h_vangard_1/WilsonKeith_data/20240411_Wilson11085_16sRNA/data/11085-AG-0008_S8_L001_R2_001.fastq.gz" ],
    "C57TAMS9"  => [ "/data/h_vangard_1/WilsonKeith_data/20240411_Wilson11085_16sRNA/data/11085-AG-0009_S9_L001_R1_001.fastq.gz", "/data/h_vangard_1/WilsonKeith_data/20240411_Wilson11085_16sRNA/data/11085-AG-0009_S9_L001_R2_001.fastq.gz" ],
    "C57TAMS10" => [ "/data/h_vangard_1/WilsonKeith_data/20240411_Wilson11085_16sRNA/data/11085-AG-0010_S10_L001_R1_001.fastq.gz", "/data/h_vangard_1/WilsonKeith_data/20240411_Wilson11085_16sRNA/data/11085-AG-0010_S10_L001_R2_001.fastq.gz" ],
    "ApcS11"    => [ "/data/h_vangard_1/WilsonKeith_data/20240411_Wilson11085_16sRNA/data/11085-AG-0011_S11_L001_R1_001.fastq.gz", "/data/h_vangard_1/WilsonKeith_data/20240411_Wilson11085_16sRNA/data/11085-AG-0011_S11_L001_R2_001.fastq.gz" ],
    "ApcS12"    => [ "/data/h_vangard_1/WilsonKeith_data/20240411_Wilson11085_16sRNA/data/11085-AG-0012_S12_L001_R1_001.fastq.gz", "/data/h_vangard_1/WilsonKeith_data/20240411_Wilson11085_16sRNA/data/11085-AG-0012_S12_L001_R2_001.fastq.gz" ],
    "ApcS13"    => [ "/data/h_vangard_1/WilsonKeith_data/20240411_Wilson11085_16sRNA/data/11085-AG-0013_S13_L001_R1_001.fastq.gz", "/data/h_vangard_1/WilsonKeith_data/20240411_Wilson11085_16sRNA/data/11085-AG-0013_S13_L001_R2_001.fastq.gz" ],
    "ApcS14"    => [ "/data/h_vangard_1/WilsonKeith_data/20240411_Wilson11085_16sRNA/data/11085-AG-0014_S14_L001_R1_001.fastq.gz", "/data/h_vangard_1/WilsonKeith_data/20240411_Wilson11085_16sRNA/data/11085-AG-0014_S14_L001_R2_001.fastq.gz" ],
    "ApcTAMS15" => [ "/data/h_vangard_1/WilsonKeith_data/20240411_Wilson11085_16sRNA/data/11085-AG-0015_S15_L001_R1_001.fastq.gz", "/data/h_vangard_1/WilsonKeith_data/20240411_Wilson11085_16sRNA/data/11085-AG-0015_S15_L001_R2_001.fastq.gz" ],
    "ApcTAMS16" => [ "/data/h_vangard_1/WilsonKeith_data/20240411_Wilson11085_16sRNA/data/11085-AG-0016_S16_L001_R1_001.fastq.gz", "/data/h_vangard_1/WilsonKeith_data/20240411_Wilson11085_16sRNA/data/11085-AG-0016_S16_L001_R2_001.fastq.gz" ],
    "ApcTAMS17" => [ "/data/h_vangard_1/WilsonKeith_data/20240411_Wilson11085_16sRNA/data/11085-AG-0017_S17_L001_R1_001.fastq.gz", "/data/h_vangard_1/WilsonKeith_data/20240411_Wilson11085_16sRNA/data/11085-AG-0017_S17_L001_R2_001.fastq.gz" ],
    "ApcTAMS18" => [ "/data/h_vangard_1/WilsonKeith_data/20240411_Wilson11085_16sRNA/data/11085-AG-0018_S18_L001_R1_001.fastq.gz", "/data/h_vangard_1/WilsonKeith_data/20240411_Wilson11085_16sRNA/data/11085-AG-0018_S18_L001_R2_001.fastq.gz" ],
    "ApcTAMS19" => [ "/data/h_vangard_1/WilsonKeith_data/20240411_Wilson11085_16sRNA/data/11085-AG-0019_S19_L001_R1_001.fastq.gz", "/data/h_vangard_1/WilsonKeith_data/20240411_Wilson11085_16sRNA/data/11085-AG-0019_S19_L001_R2_001.fastq.gz" ],
    "ApcTAMS20" => [ "/data/h_vangard_1/WilsonKeith_data/20240411_Wilson11085_16sRNA/data/11085-AG-0020_S20_L001_R1_001.fastq.gz", "/data/h_vangard_1/WilsonKeith_data/20240411_Wilson11085_16sRNA/data/11085-AG-0020_S20_L001_R2_001.fastq.gz" ],
    "NC"        => [ "/data/h_vangard_1/WilsonKeith_data/20240411_Wilson11085_16sRNA/data/11085-AG-NC_S32_L001_R1_001.fastq.gz", "/data/h_vangard_1/WilsonKeith_data/20240411_Wilson11085_16sRNA/data/11085-AG-NC_S32_L001_R2_001.fastq.gz" ],
    "PC"        => [ "/data/h_vangard_1/WilsonKeith_data/20240411_Wilson11085_16sRNA/data/11085-AG-PC_S31_L001_R1_001.fastq.gz", "/data/h_vangard_1/WilsonKeith_data/20240411_Wilson11085_16sRNA/data/11085-AG-PC_S31_L001_R2_001.fastq.gz" ]
  },
  groups => {
    "C57"    => ['C57S1','C57S2','C57S3','C57S4','C57S5','C57S6'],
    "C57TAM" => ['C57TAMS7','C57TAMS8','C57TAMS9','C57TAMS10'],
    "Apc"    => ['ApcS11','ApcS12','ApcS13','ApcS14'],
    "ApcTAM" => ['ApcTAMS15','ApcTAMS16','ApcTAMS17','ApcTAMS18','ApcTAMS19','ApcTAMS20']
  }
};

my $tasks = [];

my $addFastQCTask= addFastQC( $config, $def, $tasks, $tasks, "fastQC_raw", "files", $target_dir);
my $AddMothurPipelineTask = AddMothurPipeline($config, $def, $tasks, $target_dir,"files");
my $AddMothurPipelineVisTask = AddMothurPipelineVis($config, $def, $tasks, $target_dir, $AddMothurPipelineTask,"groups", $addFastQCTask);

performConfig($config);

1;