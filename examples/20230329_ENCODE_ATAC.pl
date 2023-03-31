#/usr/bin/perl
use strict;
use warnings;

use CQS::Global;
use CQS::ClassFactory;
use CQS::FileUtils;
use CQS::PerformEncodeATACSeq;
use Data::Dumper;

my $def = {
  "email" => "quanhu.sheng.1\@vumc.org",
  "emailType" => "FAIL",
  "task_name" => "8857_human",
  "target_dir" => create_directory_or_die("/nobackup/jbrown_lab/shengq2/test/20230306_atac_8857_test"),

  "is_paired" => 1,

  "perform_cutadapt" => 1,
  "min_read_length" => 30,
  #adapter => "AGATCGGAAGAGC", #Illumina
  "adapter" => "CTGTCTCTTATA", #Nextera
  #adapter => "TGGAATTCTCGG", #smallRNA
  "cutadapt_option" => "-u 2 -n 3", #remove first 2 bases from first read, max three adapters
  #cutadapt_option => "-n 3", #max three adapters

  #file_def.py -i /data/jbrown_lab/20210522_atacseq_human -n "(LD..)" -f "*.gz"
  "files" => {
    'NT5_C' => [ '/data/jbrown_lab/2023/20230302_8857_atac/8857-JK-0020_S1_L005_R1_001.fastq.gz', '/data/jbrown_lab/2023/20230302_8857_atac/8857-JK-0020_S1_L005_R2_001.fastq.gz' ],
    'NT5_T' => [ '/data/jbrown_lab/2023/20230302_8857_atac/8857-JK-0021_S1_L005_R1_001.fastq.gz', '/data/jbrown_lab/2023/20230302_8857_atac/8857-JK-0021_S1_L005_R2_001.fastq.gz' ],
    'NT5_TH' => [ '/data/jbrown_lab/2023/20230302_8857_atac/8857-JK-0022_S1_L005_R1_001.fastq.gz', '/data/jbrown_lab/2023/20230302_8857_atac/8857-JK-0022_S1_L005_R2_001.fastq.gz' ],
    'HT8' => [ '/data/jbrown_lab/2023/20230302_8857_atac/8857-JK-0023_S1_L005_R1_001.fastq.gz', '/data/jbrown_lab/2023/20230302_8857_atac/8857-JK-0023_S1_L005_R2_001.fastq.gz' ],
    'NT3_C' => [ '/data/jbrown_lab/2023/20230302_8857_atac/8857-JK-10_S1_L005_R1_001.fastq.gz', '/data/jbrown_lab/2023/20230302_8857_atac/8857-JK-10_S1_L005_R2_001.fastq.gz' ],
    'NT3_T' => [ '/data/jbrown_lab/2023/20230302_8857_atac/8857-JK-11_S1_L005_R1_001.fastq.gz', '/data/jbrown_lab/2023/20230302_8857_atac/8857-JK-11_S1_L005_R2_001.fastq.gz' ],
    'NT3_TH' => [ '/data/jbrown_lab/2023/20230302_8857_atac/8857-JK-12_S1_L005_R1_001.fastq.gz', '/data/jbrown_lab/2023/20230302_8857_atac/8857-JK-12_S1_L005_R2_001.fastq.gz' ],
    'HT4' => [ '/data/jbrown_lab/2023/20230302_8857_atac/8857-JK-13_S1_L005_R1_001.fastq.gz', '/data/jbrown_lab/2023/20230302_8857_atac/8857-JK-13_S1_L005_R2_001.fastq.gz' ],
    'HT5' => [ '/data/jbrown_lab/2023/20230302_8857_atac/8857-JK-14_S1_L005_R1_001.fastq.gz', '/data/jbrown_lab/2023/20230302_8857_atac/8857-JK-14_S1_L005_R2_001.fastq.gz' ],
    'HT6' => [ '/data/jbrown_lab/2023/20230302_8857_atac/8857-JK-15_S1_L005_R1_001.fastq.gz', '/data/jbrown_lab/2023/20230302_8857_atac/8857-JK-15_S1_L005_R2_001.fastq.gz' ],
    'HT2' => [ '/data/jbrown_lab/2023/20230302_8857_atac/8857-JK-5_S1_L005_R1_001.fastq.gz', '/data/jbrown_lab/2023/20230302_8857_atac/8857-JK-5_S1_L005_R2_001.fastq.gz' ],
    'NT2_C' => [ '/data/jbrown_lab/2023/20230302_8857_atac/8857-JK-6_S1_L005_R1_001.fastq.gz', '/data/jbrown_lab/2023/20230302_8857_atac/8857-JK-6_S1_L005_R2_001.fastq.gz' ],
    'NT2_T' => [ '/data/jbrown_lab/2023/20230302_8857_atac/8857-JK-7_S1_L005_R1_001.fastq.gz', '/data/jbrown_lab/2023/20230302_8857_atac/8857-JK-7_S1_L005_R2_001.fastq.gz' ],
    'NT2_TH' => [ '/data/jbrown_lab/2023/20230302_8857_atac/8857-JK-8_S1_L005_R1_001.fastq.gz', '/data/jbrown_lab/2023/20230302_8857_atac/8857-JK-8_S1_L005_R2_001.fastq.gz' ],
    'HT3' => [ '/data/jbrown_lab/2023/20230302_8857_atac/8857-JK-9_S1_L005_R1_001.fastq.gz', '/data/jbrown_lab/2023/20230302_8857_atac/8857-JK-9_S1_L005_R2_001.fastq.gz' ]
  },

  #define your groups. Current pattern indicates that each sample would be in its group.
  "groups_pattern" => '(.+)',
  
  "encode_atac_men" => "80gb",
  "encode_atac_walltime" => "24",
};

my $config = PerformEncodeATACSeq_gencode_hg38($def, 1);

1;
