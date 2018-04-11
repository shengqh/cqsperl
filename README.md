# cqsperl 

cqsperl is a library including predefined pipelines for RNASeq and smallRNASeq for CQS users in ACCRE. It is based on ngsperl framework and can be extended to other pipelines very easily.

In order to use ngsperl and cqstools library, and neccessory tools in ACCRE, you need to add following line into your .bashrc file:
```
source /home/shengq2/local/bin/path.txt
```

# RNASeq 

We provide four functions for predefined databases:

* performRNASeq_gencode_hg19
* performRNASeq_gatk_b37
* performRNASeq_gencode_mm10
* performRNASeq_ensembl_Mmul1

For example, if you want to perform RNASeq data using hg19 database, write perl script as following example and run the scripts to generate pbs scripts which can be either submit to cluster or run directly. Remember to change the task_name, email and target_dir before you have a try:

```

#!/usr/bin/perl
use strict;
use warnings;

use CQS::ClassFactory;
use CQS::FileUtils;
use CQS::SystemUtils;
use CQS::ConfigUtils;
use CQS::PerformRNAseq;

my $def = {

  #define task name, this name will be used as prefix of a few result, such as read count table file name.
  task_name => "Carrie1048",

  #email which will be used for notification if you run through cluster
  email => "quanhu.sheng.1\@vanderbilt.edu",

  #target dir which will be automatically created and used to save code and result
  target_dir => "/scratch/cqs/shengq2/vickers/20171207_rnaseq_1048_carrie_human",

  pairend => 1,

  #source files
  files => {
    "Control_1" => [ "/scratch/cqs/shengq2/vickers/data/1048/1048-CW-1-1-AACCAGAT_S429_R1_001.fastq.gz",  "/scratch/cqs/shengq2/vickers/data/1048/1048-CW-1-1-AACCAGAT_S429_R2_001.fastq.gz" ],
    "Control_2" => [ "/scratch/cqs/shengq2/vickers/data/1048/1048-CW-1-2-TGGTGAAT_S430_R1_001.fastq.gz",  "/scratch/cqs/shengq2/vickers/data/1048/1048-CW-1-2-TGGTGAAT_S430_R2_001.fastq.gz" ],
    "Control_3" => [ "/scratch/cqs/shengq2/vickers/data/1048/1048-CW-1-3-AGTGAGAT_S431_R1_001.fastq.gz",  "/scratch/cqs/shengq2/vickers/data/1048/1048-CW-1-3-AGTGAGAT_S431_R2_001.fastq.gz" ],
    "miR489_1"  => [ "/scratch/cqs/shengq2/vickers/data/1048/1048-CW-1-4-GCACTAAT_S432_R1_001.fastq.gz",  "/scratch/cqs/shengq2/vickers/data/1048/1048-CW-1-4-GCACTAAT_S432_R2_001.fastq.gz" ],
    "miR489_2"  => [ "/scratch/cqs/shengq2/vickers/data/1048/1048-CW-1-5-ACCTCAAT_S433_R1_001.fastq.gz",  "/scratch/cqs/shengq2/vickers/data/1048/1048-CW-1-5-ACCTCAAT_S433_R2_001.fastq.gz" ],
    "miR489_3"  => [ "/scratch/cqs/shengq2/vickers/data/1048/1048-CW-1-6-GTGCTTAT_S434_R1_001.fastq.gz",  "/scratch/cqs/shengq2/vickers/data/1048/1048-CW-1-6-GTGCTTAT_S434_R2_001.fastq.gz" ],
  },

  groups => {
    "Control" => [ "Control_1", "Control_2", "Control_3" ],
    "miR489"  => [ "miR489_1",  "miR489_2",  "miR489_3" ],
  },

  pairs => {
    "miR489" => [ "Control", "miR489" ]
  },
};

my $config = performRNASeq_gencode_hg19( $def, 1 );

1;
```

# smallRNASeq

We provide following functions for predefined databases. Human, mouse and rat are three most complehensive databases we prepared so far.

* performSmallRNA_hg19 
* performSmallRNA_hg38
* performSmallRNA_mm10
* performSmallRNA_rn5
* performSmallRNA_cel235
* performSmallRNA_cfa3
* performSmallRNA_bta8
* performSmallRNA_eca2
* performSmallRNA_ssc3
* performSmallRNA_ocu2
* performSmallRNA_oar3
* performSmallRNA_gga4
* performSmallRNA_fca6
* performSmallRNA_rheMac8
* performSmallRNA_chir1

For example, if you want to perform smallRNAseq data using mm10 database, write perl script as following example and run the scripts to generate pbs scripts which can be either submit to cluster or run directly. Remember to change the task_name, email and target_dir before you have a try:

```
#!/usr/bin/perl
use strict;
use warnings;

use CQS::PerformSmallRNA3;
use CQS::ClassFactory;
use CQS::StringUtils;

my $email = "quanhu.sheng.1\@vanderbilt.edu";

my $def = {

  #General options
  task_name        => "KCV_3018_77_78_79",
  email            => $email,

  target_dir                => "/scratch/cqs/shengq2/vickers/20180410_smallRNA_3018-KCV-77_78_79_mouse_v3",
  max_thread                => 8,

  #preprocessing
  run_cutadapt                => 1,
  adapter                     => "TGGAATTCTCGGGTGCCAAGG",
  fastq_remove_random         => 4,                                   #next flex

  #Data
  files => {
    "APOB_WT_01"     => ['/scratch/cqs/zhaos/vickers/data/3018/3018-KCV-77/3018/3018-KCV-77-i42_S19_R1_001.fastq.gz'],
    "APOB_WT_03"     => ['/scratch/cqs/zhaos/vickers/data/3018/3018-KCV-77/3018/3018-KCV-77-i44_S21_R1_001.fastq.gz'],
    "APOB_WT_05"     => ['/scratch/cqs/zhaos/vickers/data/3018/3018-KCV-78/3018/3018-KCV-78-i46_S20_R1_001.fastq.gz'],
    "APOB_SRBIKO_02" => ['/scratch/cqs/zhaos/vickers/data/3018/3018-KCV-77/3018/3018-KCV-77-i43_S20_R1_001.fastq.gz'],
    "APOB_SRBIKO_04" => ['/scratch/cqs/zhaos/vickers/data/3018/3018-KCV-77/3018/3018-KCV-77-i45_S22_R1_001.fastq.gz'],
    "APOB_SRBIKO_06" => ['/scratch/cqs/zhaos/vickers/data/3018/3018-KCV-78/3018/3018-KCV-78-i47_S21_R1_001.fastq.gz'],
  },

  groups => {
    "APOB_WT"      => [ "APOB_WT_01",      "APOB_WT_03",      "APOB_WT_05" ],
    "APOB_SRBIKO"  => [ "APOB_SRBIKO_02",  "APOB_SRBIKO_04",  "APOB_SRBIKO_06" ],
  },
  pairs => {
    "APOB_SRBIKO_vs_WT" =>  [ "APOB_WT", "APOB_SRBIKO" ],
  },
};

my $config = performSmallRNA_mm10( $def, 1 );

1;

```
