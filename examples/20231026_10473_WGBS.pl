#!/usr/bin/perl
use strict;
use warnings;
use CQS::Global;
use CQS::FileUtils;
use CQS::SystemUtils;
use CQS::ConfigUtils;
use CQS::ClassFactory;
use CQS::PerformWGBS;

use Hash::Merge qw( merge );

my $def = {
  task_name           => "P10473",
  email               => "quanhu.sheng.1\@vumc.org",
  emailType           => "FAIL",
  target_dir          => "/nobackup/h_cqs/shengq2/temp/20231026_10473_WGBS",

  files => {
    'A1' => [ '/panfs/accrepfs.vampire/nobackup/h_cqs/shengq2/methylation_data/A1_R1.fastq.gz', '/panfs/accrepfs.vampire/nobackup/h_cqs/shengq2/methylation_data/A1_R2.fastq.gz' ],
    'A2' => [ '/panfs/accrepfs.vampire/nobackup/h_cqs/shengq2/methylation_data/A2_R1.fastq.gz', '/panfs/accrepfs.vampire/nobackup/h_cqs/shengq2/methylation_data/A2_R2.fastq.gz' ],
    'B1' => [ '/panfs/accrepfs.vampire/nobackup/h_cqs/shengq2/methylation_data/B1_R1.fastq.gz', '/panfs/accrepfs.vampire/nobackup/h_cqs/shengq2/methylation_data/B1_R2.fastq.gz' ],
    'B2' => [ '/panfs/accrepfs.vampire/nobackup/h_cqs/shengq2/methylation_data/B2_R1.fastq.gz', '/panfs/accrepfs.vampire/nobackup/h_cqs/shengq2/methylation_data/B2_R2.fastq.gz' ],
  },
  groups_pattern => "(.).",
  pairs => {
    #control first, then treatment
    "B_cs_A" => [ 'A', 'B' ],
  },

  interval_list => "/nobackup/brown_lab/projects/20231006_10473_DNAMethyl_hg38/covered_targets_Twist_Methylome_hg38_annotated_collapsed.intervals",
  meta_file => "/data/cqs/shengq2/program/cqsperl/examples/20231006_10473_WGBS.meta.tsv",
  #use_tmp_folder => 1,

  new_dnmtools => 1,
  dnmtools_docker_command => singularity_prefix() . " /data/cqs/softwares/singularity/cqs-dnmtools.20231026.sif ",
  #dnmtools_command => singularity_prefix() . " /data/cqs/softwares/singularity/cqs-dnmtools.20231026.sif dnmtools",

  add_folder_index => 1,
};

my $config = performWGBS_gencode_hg38($def, 1);

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
