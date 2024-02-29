#!/usr/bin/perl
use strict;
use warnings;

use Pipeline::PIPseq3;
use CQS::ClassFactory;

my $def = {
  #General options
  task_name  => "AS_11162",
  email      => "marisol.a.ramirez\@vumc.org",
  emailType => 'FAIL',

  target_dir => "/nobackup/h_cqs/shengq2/bugfix/20240229_AS_11162_DA_pipseq",

  check_file_exists => 0,

  #file path should contain the prefix which can identify the specific sample in the folder
  files => {
    "AS_11162_0011" => ["/data/cqs/ramirema/ken_lau/20240227_11162_AS/11162-AS-0011"],
    "AS_11162_0012" => ["/data/cqs/ramirema/ken_lau/20240227_11162_AS/11162-AS-0012"],
    "AS_11162_0013" => ["/data/cqs/ramirema/ken_lau/20240227_11162_AS/11162-AS-0013"],
  },
  
  pipseeker_command => "/data/cqs/softwares/pipseeker_v3.1.3/pipseeker",
  pipseeker_chemistry => "V4",
  pipseeker_star_index => "/data/cqs/ramirema/references/pipseeker/pipseeker-gex-reference-GRCm39-2022.04",

  perform_individual_qc => 0,
};

performPIPseq3($def);

1;
