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
  task_name           => "QZ9413",
  email               => "yu.wang.2\@vumc.org",
  emailType           => "FAIL",
  target_dir          => "/nobackup/h_cqs/ywang/PI_Coffey/20230301_Coffey_methylation_QZ9413/analysis/dev_test2",
  abismal_index       => "/data/cqs/references/abismal_index/hg19_chrm.abismalidx",
  chr_dir             => "/data/cqs/references/abismal_index/hg19_chrm.fa",
  chr_size_file       => "/data/cqs/references/abismal_index/hg19_chrm.sizes",
  annovar_buildver    => "hg19",
  annovar_db          => "/data/cqs/references/annovar/humandb",
  annovar_param       => "--otherinfo -protocol refGene,avsnp150,cosmic70, -operation g,f,f --remove",
  HOMER_perlFile      => "/data/cqs/softwares/homer/bin/findMotifsGenome.pl",
  addqual_perlFile    => "/data/cqs/softwares/ngsperl/lib/Methylation/add_qual.pl",
  picard              => "/data/cqs/softwares/picard.jar",
  interval_list       => "/data/cqs/references/abismal_index/Twist_Methylome_hg19.interval_list",
  is_paired_end       => 1,
  webgestalt_organism => "hsapiens",

  files => {
    "DLD1_cell"    => [ "/dors/exrna/qinZhang/20230301_Coffey_methylation_QZ9413/data/9413-QZ-0001_S1_L005_R1_001.fastq.gz", "/dors/exrna/qinZhang/20230301_Coffey_methylation_QZ9413/data/9413-QZ-0001_S1_L005_R2_001.fastq.gz" ],
    "DLD1_lEVPH"   => [ "/dors/exrna/qinZhang/20230301_Coffey_methylation_QZ9413/data/9413-QZ-0002_S1_L005_R1_001.fastq.gz", "/dors/exrna/qinZhang/20230301_Coffey_methylation_QZ9413/data/9413-QZ-0002_S1_L005_R2_001.fastq.gz" ],
    "DLD1_sEVPH"   => [ "/dors/exrna/qinZhang/20230301_Coffey_methylation_QZ9413/data/9413-QZ-0003_S1_L005_R1_001.fastq.gz", "/dors/exrna/qinZhang/20230301_Coffey_methylation_QZ9413/data/9413-QZ-0003_S1_L005_R2_001.fastq.gz" ],
    "DLD1_ON"      => [ "/dors/exrna/qinZhang/20230301_Coffey_methylation_QZ9413/data/9413-QZ-0004_S1_L005_R1_001.fastq.gz", "/dors/exrna/qinZhang/20230301_Coffey_methylation_QZ9413/data/9413-QZ-0004_S1_L005_R2_001.fastq.gz" ],
    "DLD1_ON2"     => [ "/dors/exrna/qinZhang/20230301_Coffey_methylation_QZ9413/data/9413-QZ-0005_S1_L005_R1_001.fastq.gz", "/dors/exrna/qinZhang/20230301_Coffey_methylation_QZ9413/data/9413-QZ-0005_S1_L005_R2_001.fastq.gz" ],
    "DKs8_cell"    => [ "/dors/exrna/qinZhang/20230301_Coffey_methylation_QZ9413/data/9413-QZ-0006_S1_L005_R1_001.fastq.gz", "/dors/exrna/qinZhang/20230301_Coffey_methylation_QZ9413/data/9413-QZ-0006_S1_L005_R2_001.fastq.gz" ],
    "DKs8_sEVPH"   => [ "/dors/exrna/qinZhang/20230301_Coffey_methylation_QZ9413/data/9413-QZ-0007_S1_L005_R1_001.fastq.gz", "/dors/exrna/qinZhang/20230301_Coffey_methylation_QZ9413/data/9413-QZ-0007_S1_L005_R2_001.fastq.gz" ],
    "DKs8_ON"      => [ "/dors/exrna/qinZhang/20230301_Coffey_methylation_QZ9413/data/9413-QZ-0008_S1_L005_R1_001.fastq.gz", "/dors/exrna/qinZhang/20230301_Coffey_methylation_QZ9413/data/9413-QZ-0008_S1_L005_R2_001.fastq.gz" ],
    "DKs8_ON2"     => [ "/dors/exrna/qinZhang/20230301_Coffey_methylation_QZ9413/data/9413-QZ-0009_S1_L005_R1_001.fastq.gz", "/dors/exrna/qinZhang/20230301_Coffey_methylation_QZ9413/data/9413-QZ-0009_S1_L005_R2_001.fastq.gz" ],
    "Kidney_cell"  => [ "/dors/exrna/qinZhang/20230301_Coffey_methylation_QZ9413/data/9413-QZ-0010_S1_L005_R1_001.fastq.gz", "/dors/exrna/qinZhang/20230301_Coffey_methylation_QZ9413/data/9413-QZ-0010_S1_L005_R2_001.fastq.gz" ],
    "Kidney_4hr"   => [ "/dors/exrna/qinZhang/20230301_Coffey_methylation_QZ9413/data/9413-QZ-0011_S1_L005_R1_001.fastq.gz", "/dors/exrna/qinZhang/20230301_Coffey_methylation_QZ9413/data/9413-QZ-0011_S1_L005_R2_001.fastq.gz" ],
    "Kidney_ON"    => [ "/dors/exrna/qinZhang/20230301_Coffey_methylation_QZ9413/data/9413-QZ-0012_S1_L005_R1_001.fastq.gz", "/dors/exrna/qinZhang/20230301_Coffey_methylation_QZ9413/data/9413-QZ-0012_S1_L005_R2_001.fastq.gz" ],

  },
  groups => {
    "DLD1"    => [ 'DLD1_cell', 'DLD1_lEVPH', 'DLD1_ON', 'DLD1_ON2', 'DLD1_sEVPH' ], 
    "DKs8"    => [ 'DKs8_cell', 'DKs8_ON', 'DKs8_ON2', 'DKs8_sEVPH' ],
    "Kidney"  => [ 'Kidney_cell', 'Kidney_4hr', 'Kidney_ON' ]
  },
  pairs => {
    #control first, then treatment
    #"DLD1_lEVPH_VS_cell"         => [ "DLD1_cell", "DLD1_lEVPH" ],
    #"DLD1_sEVPH_VS_cell"         => [ "DLD1_cell", "DLD1_sEVPH" ],
    #"DLD1_ON_VS_cell"            => [ "DLD1_cell", "DLD1_ON" ],
    #"DLD1_ON2_VS_cell"           => [ "DLD1_cell", "DLD1_ON2" ],
    #"DKs8_sEVPH_VS_cell"         => [ "DKs8_cell", "DKs8_sEVPH" ],
    #"DKs8_ON_VS_cell"            => [ "DKs8_cell", "DKs8_ON" ],
    #"DKs8_ON2_VS_cell"           => [ "DKs8_cell", "DKs8_ON2" ],
    #"Kidney_4hr_VS_cell"         => [ "Kidney_cell", "Kidney_4hr" ],
    #"Kidney_ON_VS_cell"          => [ "Kidney_cell", "Kidney_ON" ],
    "Kidney_vs_DLD1" => [ 'DLD1', 'Kidney' ],
    "Kidney_vs_DKs8" => [ 'DKs8', 'Kidney' ],
    "DLD1_vs_DKs8"   => [ 'DKs8', 'DLD1' ]
  },
};

my $config = performWGBS($def, 1);

1;

##Pipeline example Readme##
#This perl script example is used for generating the pipeline structure/scripts for WGBS (Twist methylome target panel) data analysis under ngsperl framework on ACCRE HPC.
#
#1. Configure your work environment
#For reference, please follow the readme at https://github.com/shengqh/cqsperl. Basically, you need to add the following line into your .bashrc under your home directory. This will 
#make sure that most of the required softwares or dependencies which have been preintalled by ACCRE or cqs group are accessable and usable by the pipeline:
# source /data/cqs/softwares/cqsperl/scripts/path.txt
#
#2. Edit the configuration in this perl template for your own task
#Please change "task_name", "email", "emailType", "target_dir" to your own information before running it. 
#For "interval_list", if it's not based on twist methylome target panel, you should generate this first with picard and *.bed input file based on the experimental design. 
#If used for other organisms other than human, make sure to use/contruct reference files accordingly.
#
#"files" section defines the input fastq files of samples in .gz (required) format. 
#"groups" section defines the group of samples.
#"pairs" section defines the comparisons between pair of groups.
#
#3. Extra information
#Besides this perl script, you need to prepare a meta files named as "project_meta.tsv" for the sample-to-sample correlation distance MDS plot. For example:
#QZ9413_meta.tsv:
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
#20230518_WGBS_pipeline_example_with_readme.pl
#abismal
#dnmtools
#dnmtoolsAnnovar
#fastqc_raw
#fastqc_raw_summary
#methylkitcorr
#methylkitdiff
#MethylKitDiffAnnovar
#MethylKitDiffAnnovarGenes
#MethylKitDiffAnnovarGenes_WebGestalt
#methylkitprep
#paired_end_validation
#QZ9413.config
#QZ9413.def
#QZ9413_meta.tsv
#report
#sequencetask
#trimgalore
#
#You can submit the entire pipeline by running the .submit file under sequencetask/pbs/, or runned each step seperately following this order:
# 1. paired_end_validation 2. fastqc_raw 3. fastqc_raw_summary 4. trimgalore
# 4. abismal 5. dnmtools 6. dnmtoolsAnnovar
# 7. methylkitprep 8. methylkitcorr 9. methylkitdiff 10. MethylKitDiffAnnovar 11. MethylKitDiffAnnovarGenes 12. MethylKitDiffAnnovarGenes_WebGestalt
# 13. report 14. sequencetask
#
# The final report information can be found at: report/result/project.html and report/result/project.
#
