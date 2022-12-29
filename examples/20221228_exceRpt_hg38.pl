use strict;
use warnings;

use CQS::ClassFactory;
use Pipeline::exceRpt;
use CQS::ConfigUtils;
use Data::Dumper;
use CQS::PerformSmallRNA;
use CQS::PerformExceRpt;

my $def = {

  #General_options
  task_name => "exceRpt_test",
  email     => "quanhu.sheng.1\@vumc.org",
  emailType => "FAIL",
  target_dir => "/scratch/vickers_lab/projects/20221228_exceRpt_hg38",
  max_thread => 8,

  #Data
  files => {
    "Pool1_Media_1" => ["/data/vickers_lab/2022/20220825_8643_CM/8643-CM-1_0001_S1_L005_R1_001.fastq.gz"],
  },

  MAP_EXOGENOUS => "on", #'off'/'miRNA'/'on'
  ADAPTER_SEQ => "TGGAATTCTCGGGTGCCAAGG", #'guessKnown'/'none'/<String>

  #next_flex
  RANDOM_BARCODE_LENGTH => 4,
  RANDOM_BARCODE_LOCATION => "-5p -3p", #'-5p -3p'/'-5p'/'-3p'

  MIN_READ_LENGTH => 16,

  use_tmp_folder => 0,

  # Run spcount for comparison
  perform_refseq_bacteria => 1,
  min_read_length => 16, # Just use all reads from exceRpt result.
  use_first_read_after_trim => 0,
};

my $config = performExceRpt_hg38($def, 1 );

1;

