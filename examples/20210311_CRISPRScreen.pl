#!/usr/bin/perl
use strict;
use warnings;

use CQS::ClassFactory;
use CQS::FileUtils;
use Data::Dumper;
use Pipeline::CRISPRScreen;

my $def = {
  task_name  => "CRISPRScreen",
  email      => "quanhu.sheng.1\@vumc.org",
  target_dir => create_directory_or_die("/scratch/cqs/shengq2/test/20210311_CRISPRScreen"),
  docker_command => "singularity exec -e /scratch/cqs_share/softwares/singularity/cqs-chipseq.simg ",
  mageck_docker_command => "singularity exec -e /data/cqs/softwares/singularity/cqs-mageck.simg ",

  is_paired_end    => 0,

  #add_folder_index => 1,

  perform_cutadapt => 1,
  use_cutadapt_option_only => 1,
  cutadapt_config => {
    "variant_adapter" => {
      option => '-g TTTATATATCTTGTGG',
      adapter => "",
      samples => [qw(plasmid)]
    },
    "fixed_adapter" => {
      option => '-u 45',
      adapter => "",
      samples => "default"
    }
  },

  files => {
    "plasmid" => ["/scratch/h_vangard_1/wangj52/Bill/Caleb-MV411-CRISPR_screen/fastq/3657-GH-1-CAAGGCGA-TCTTTCCC_S171_R1_001.fastq"],
    "Rep1_DMSO" => ["/scratch/h_vangard_1/wangj52/Bill/Caleb-MV411-CRISPR_screen/fastq/4056-GH-1-CAAGGCGA-TCTTTCCC_S392_R1_001.fastq"],
    "Rep1_VU641" => ["/scratch/h_vangard_1/wangj52/Bill/Caleb-MV411-CRISPR_screen/fastq/4056-GH-2-GACGCTAT-TCTTTCCC_S393_R1_001.fastq"],
    "Rep1_VU584" => ["/scratch/h_vangard_1/wangj52/Bill/Caleb-MV411-CRISPR_screen/fastq/4056-GH-3-ACTTCTTC-TCTTTCCC_S394_R1_001.fastq"],
    "Rep2_DMSO" => ["/scratch/h_vangard_1/wangj52/Bill/Caleb-MV411-CRISPR_screen/fastq/4056-GH-4-CATCAGAC-TCTTTCCC_S395_R1_001.fastq"],
    "Rep2_VU641" => ["/scratch/h_vangard_1/wangj52/Bill/Caleb-MV411-CRISPR_screen/fastq/4056-GH-5-GTGCGTAA-TCTTTCCC_S396_R1_001.fastq"],
    "Rep2_VU584" => ["/scratch/h_vangard_1/wangj52/Bill/Caleb-MV411-CRISPR_screen/fastq/4056-GH-6-CTATTCAA-TCTTTCCC_S397_R1_001.fastq"],
  },
  mageck_library => "/scratch/h_vangard_1/wangj52/Bill/Caleb-MV411-CRISPR_screen/MAGeCK/numbered_brunello_validation_library.txt",
  mageck_test => {
    DMSOvsplasmid => ["-t Rep1_DMSO,Rep2_DMSO -c plasmid"],
    VU641vsDMSO => ["-t Rep1_VU641,Rep2_VU641 -c Rep1_DMSO,Rep2_DMSO"],
    VU584vsDMSO => ["-t Rep1_VU584,Rep2_VU584 -c Rep1_DMSO,Rep2_DMSO"],
  },
};

my $config = performCRISPRScreen($def, 1);
#performTask($config, "report");

1;
