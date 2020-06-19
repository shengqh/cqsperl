# cqsperl 

cqsperl is a library including predefined pipelines for CQS users in ACCRE. It is based on [ngsperl](https://github.com/shengqh/ngsperl) framework.

In order to use ngsperl and cqstools library, and neccessory tools in ACCRE, you need to add following line into your .bashrc file:
```
source /home/shengq2/local/bin/path.txt
```

# RNASeq 

We provide four functions for predefined databases:

* performRNASeq_gencode_hg19
* performRNASeq_gencode_hg38
* performRNASeq_gencode_mm10
* performRNASeq_ensembl_Mmul10

For example, if you want to perform RNASeq data using hg19 database, write perl script as following example and run the scripts to generate pbs scripts which can be either submit to cluster or run directly. Remember to change the task_name, email and target_dir before you have a try [RNAseq_example.pl](examples/RNAseq_example.pl):

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
  task_name => "rnaseq_hg19",

  #email which will be used for notification if you run through cluster
  email => "quanhu.sheng.1\@vumc.org",

  #target dir which will be automatically created and used to save code and result
  target_dir         => "/scratch/cqs/shengq2/temp/rnaseq_example",
  DE_fold_change     => 1.5,
  perform_multiqc    => 1,
  perform_webgestalt => 1,
  perform_gsea       => 1,

  perform_cutadapt => 1,
  cutadapt_option  => "-O 1 -q 20 -a AGATCGGAAGAGCACACGTC -A AGATCGGAAGAGCGTCGTGT -a CTGTCTCTTATACACATCT -A CTGTCTCTTATACACATCT",
  min_read_length  => 30,
  pairend => 1,

  perform_call_variants => 1,
  
  #source files
  files => {
    "VPM150_5mM_cell"   => [ "/scratch/cqs/pipeline_example/rnaseq_data/948-WZ-1-AAGAGG_S1_R1_001.fastq.gz", "/scratch/cqs/pipeline_example/rnaseq_data/948-WZ-1-AAGAGG_S1_R2_001.fastq.gz" ],
    "VPM150_metaC_cell" => [ "/scratch/cqs/pipeline_example/rnaseq_data/948-WZ-1-GGAGAA_S2_R1_001.fastq.gz", "/scratch/cqs/pipeline_example/rnaseq_data/948-WZ-1-GGAGAA_S2_R2_001.fastq.gz" ],
    "VPM153_5mM_cell"   => [ "/scratch/cqs/pipeline_example/rnaseq_data/948-WZ-1-AGCATG_S3_R1_001.fastq.gz", "/scratch/cqs/pipeline_example/rnaseq_data/948-WZ-1-AGCATG_S3_R2_001.fastq.gz" ],
    "VPM153_metaC_cell" => [ "/scratch/cqs/pipeline_example/rnaseq_data/948-WZ-1-GAGTCA_S4_R1_001.fastq.gz", "/scratch/cqs/pipeline_example/rnaseq_data/948-WZ-1-GAGTCA_S4_R2_001.fastq.gz" ],
    "VPM154_5mM_cell"   => [ "/scratch/cqs/pipeline_example/rnaseq_data/948-WZ-1-CGTAGA_S5_R1_001.fastq.gz", "/scratch/cqs/pipeline_example/rnaseq_data/948-WZ-1-CGTAGA_S5_R2_001.fastq.gz" ],
    "VPM154_metaC_cell" => [ "/scratch/cqs/pipeline_example/rnaseq_data/948-WZ-1-TCAGAG_S6_R1_001.fastq.gz", "/scratch/cqs/pipeline_example/rnaseq_data/948-WZ-1-TCAGAG_S6_R2_001.fastq.gz" ],
    "H2O"               => [ "/scratch/cqs/pipeline_example/rnaseq_data/948-WZ-1-CACAGT_S7_R1_001.fastq.gz", "/scratch/cqs/pipeline_example/rnaseq_data/948-WZ-1-CACAGT_S7_R2_001.fastq.gz" ],
  },

  groups => {
    "5mM"   => [ "VPM150_5mM_cell",   "VPM153_5mM_cell",   "VPM154_5mM_cell" ],
    "metaC" => [ "VPM150_metaC_cell", "VPM153_metaC_cell", "VPM154_metaC_cell" ],
    "H2O"   => ["H2O"],
  },

  pairs => {
    "metaC_vs_5mM" => [ "5mM", "metaC" ]
  },
};

my $config = performRNASeq_gencode_hg19($def, 1);

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
