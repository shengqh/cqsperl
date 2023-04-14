#!/usr/bin/perl
use strict;
use warnings;
use CQS::FileUtils;
use CQS::SystemUtils;
use CQS::ConfigUtils;
use CQS::ClassFactory;
use Pipeline::WGBS;

use Hash::Merge qw( merge );

my $def = {
  task_name => "QZ9413",
  email => "your.id\@vumc.org",
  emailType => "FAIL",
  target_dir => "/nobackup/h_cqs/ywang/PI_Coffey/20230301_Coffey_methylation_QZ9413/analysis/dev_test",
  thread     => "4",
  abismal_index => "/data/cqs/references/abismal_index/hg19_chrm.abismalidx",
  chr_dir       => "/data/cqs/references/abismal_index/hg19_chrm.fa",
  chr_size_file => "/data/cqs/references/abismal_index/hg19_chrm.sizes",
  annovar_buildver => "hg19",
  annovar_db       => "/data/cqs/references/annovar/humandb",
  annovar_param    => "--otherinfo -protocol refGene,avsnp150,cosmic70, -operation g,f,f --remove",
  HOMER_perlFile => "/data/cqs/softwares/homer/bin/findMotifsGenome.pl",
  addqual_perlFile => "/data/cqs/softwares/ngsperl/lib/Methylation/add_qual.pl",
  picard => "/data/cqs/softwares/picard.jar",
  interval_list => "/data/cqs/references/abismal_index/Twist_Methylome_hg19.interval_list",
  is_paired_end => 1,
  webgestalt_organism => "hsapiens",

    files => {
    "DLD1_cell"    => [ "/dors/exrna/qinZhang/QZ9413/data/9413-QZ-0001_S1_L005_R1_001.fastq.gz", "/dors/exrna/qinZhang/QZ9413/data/9413-QZ-0001_S1_L005_R2_001.fastq.gz" ],
    "DLD1_lEVPH"   => [ "/dors/exrna/qinZhang/QZ9413/data/9413-QZ-0002_S1_L005_R1_001.fastq.gz", "/dors/exrna/qinZhang/QZ9413/data/9413-QZ-0002_S1_L005_R2_001.fastq.gz" ],
    "DLD1_sEVPH"   => [ "/dors/exrna/qinZhang/QZ9413/data/9413-QZ-0003_S1_L005_R1_001.fastq.gz", "/dors/exrna/qinZhang/QZ9413/data/9413-QZ-0003_S1_L005_R2_001.fastq.gz" ],
    "DLD1_ON"      => [ "/dors/exrna/qinZhang/QZ9413/data/9413-QZ-0004_S1_L005_R1_001.fastq.gz", "/dors/exrna/qinZhang/QZ9413/data/9413-QZ-0004_S1_L005_R2_001.fastq.gz" ],
    "DLD1_ON2"     => [ "/dors/exrna/qinZhang/QZ9413/data/9413-QZ-0005_S1_L005_R1_001.fastq.gz", "/dors/exrna/qinZhang/QZ9413/data/9413-QZ-0005_S1_L005_R2_001.fastq.gz" ],
    "DKs8_cell"    => [ "/dors/exrna/qinZhang/QZ9413/data/9413-QZ-0006_S1_L005_R1_001.fastq.gz", "/dors/exrna/qinZhang/QZ9413/data/9413-QZ-0006_S1_L005_R2_001.fastq.gz" ],
    "DKs8_sEVPH"   => [ "/dors/exrna/qinZhang/QZ9413/data/9413-QZ-0007_S1_L005_R1_001.fastq.gz", "/dors/exrna/qinZhang/QZ9413/data/9413-QZ-0007_S1_L005_R2_001.fastq.gz" ],
    "DKs8_ON"      => [ "/dors/exrna/qinZhang/QZ9413/data/9413-QZ-0008_S1_L005_R1_001.fastq.gz", "/dors/exrna/qinZhang/QZ9413/data/9413-QZ-0008_S1_L005_R2_001.fastq.gz" ],
    "DKs8_ON2"     => [ "/dors/exrna/qinZhang/QZ9413/data/9413-QZ-0009_S1_L005_R1_001.fastq.gz", "/dors/exrna/qinZhang/QZ9413/data/9413-QZ-0009_S1_L005_R2_001.fastq.gz" ],
    "Kidney_cell"  => [ "/dors/exrna/qinZhang/QZ9413/data/9413-QZ-0010_S1_L005_R1_001.fastq.gz", "/dors/exrna/qinZhang/QZ9413/data/9413-QZ-0010_S1_L005_R2_001.fastq.gz" ],
    "Kidney_4hr"   => [ "/dors/exrna/qinZhang/QZ9413/data/9413-QZ-0011_S1_L005_R1_001.fastq.gz", "/dors/exrna/qinZhang/QZ9413/data/9413-QZ-0011_S1_L005_R2_001.fastq.gz" ],
    "Kidney_ON"    => [ "/dors/exrna/qinZhang/QZ9413/data/9413-QZ-0012_S1_L005_R1_001.fastq.gz", "/dors/exrna/qinZhang/QZ9413/data/9413-QZ-0012_S1_L005_R2_001.fastq.gz" ],

  },
  pairs => {
    #control first, then treatment
    "DLD1_lEVPH_VS_cell"         => [ "DLD1_cell", "DLD1_lEVPH" ],
    "DLD1_sEVPH_VS_cell"         => [ "DLD1_cell", "DLD1_sEVPH" ],
    "DLD1_ON_VS_cell"            => [ "DLD1_cell", "DLD1_ON" ],
    "DLD1_ON2_VS_cell"           => [ "DLD1_cell", "DLD1_ON2" ],
    "DKs8_sEVPH_VS_cell"         => [ "DKs8_cell", "DKs8_sEVPH" ],
    "DKs8_ON_VS_cell"            => [ "DKs8_cell", "DKs8_ON" ],
    "DKs8_ON2_VS_cell"           => [ "DKs8_cell", "DKs8_ON2" ],
    "Kidney_4hr_VS_cell"         => [ "Kidney_cell", "Kidney_4hr" ],
    "Kidney_ON_VS_cell"          => [ "Kidney_cell", "Kidney_ON" ],
  },

};

my $config = performWGBS($def, 1);
#performTask($config, "report");
#performTask($config, "DNMToolsDiffAnnovarGenes_WebGestalt");

1;

##Pipeline example Readme##
#This perl script example is used for generating the pipeline structure/scripts for WGBS (Twist methylome target panel) data analysis under ngsperl framework on ACCRE HPC.
#
#Please modify "task_name", "email", "emailType", "target_dir" to your own information before running it. For "interval_list", if it's not based on twist methylome target 
#panel, you should generate this first with picard and *.bed input file based on the experimental design.
#
#"files" section defines the input fastq files of samples in .gz (required) format. 
#"pairs" section defines the comparisons between pair of samples.
#
#Besides this perl script, you need to prepare a meta files named as "project_meta.tsv" for the sample MDS plot. For example:
#QZ9413_meta.tsv
#group	type
#DKs8_cell	DKs8	cell
#DKs8_ON	DKs8	EV
#DKs8_ON2	DKs8	EV
#DKs8_sEVPH	DKs8	EV
#DLD1_cell	DLD1	cell
#DLD1_lEVPH	DLD1	EV
#DLD1_ON	DLD1	EV
#DLD1_ON2	DLD1	EV
#DLD1_sEVPH	DLD1	EV
#Kidney_4hr	Kidney	EV
#Kidney_cell	Kidney	cell
#Kidney_ON	Kidney	EV
#
#If all configuration are correct, you will see following files/folders under your current folder:
# 20230414_WGBS_pipeline_example_with_readme.pl
# abismal
# dnmtools
# dnmtoolsAnnovar
# DNMToolsDiff
# DNMToolsDiffAnnovar
# DNMToolsDiffAnnovarGenes
# DNMToolsDiffAnnovarGenes_WebGestalt
# fastqc_raw
# fastqc_raw_summary
# HOMER_DMR
# paired_end_validation
# QZ9413.config
# QZ9413.def
# QZ9413_meta.tsv
# report
# sequencetask
# trimgalore
#
#You can submit the entire pipeline by running the .submit file under sequencetask/pbs/, or runned each step seperately following this order:
# 1. paired_end_validation 2. fastqc_raw 3. fastqc_raw_summary 4. trimgalore
# 4. abismal 5. dnmtools 6. dnmtoolsAnnovar
# 7. DNMToolsDiff 8. DNMToolsDiffAnnovar 9. DNMToolsDiffAnnovarGenes 10. DNMToolsDiffAnnovarGenes_WebGestalt 11. HOMER_DMR
# 12. report 13. sequencetask
#
# The final report information can be found at: report/result/project.html and report/result/project.
#
