#!/usr/bin/perl
use strict;
use warnings;

use CQS::PerformSmallRNA;
use CQS::ClassFactory;

my $def = {

	#General options
	task_name => "6092_ES_ARMseq",
	email     => "marisol.a.ramirez\@vumc.org",
	emailType => "FAIL",
	target_dir =>"/scratch/cqs/shengq2/temp/20210401_6092_ES_smRNA_ARMseq_humanv5_byMars",
    max_thread => 8,
    is_paired_end => 0,

  #Default software parameter (don't change it except you really know it)
    remove_sequences => "'CCACGTTCCCGTGG;ACAGTCCGACGATC'",
   #next flex
   fastq_remove_random => 4,
   
  perform_short_reads_deseq2 => 1,
  
	#Data
files => {
  "Water_AlkB" => ["/data/vickers_lab/20210331_6092_ES/6092-ES-1_S1_L005_R1_001.fastq.gz"],
  "THP1_AlkB" => ["/data/vickers_lab/20210331_6092_ES/6092-ES-2_S1_L005_R1_001.fastq.gz"],
  "HDL_96_AlkB" => ["/data/vickers_lab/20210331_6092_ES/6092-ES-3_S1_L005_R1_001.fastq.gz"],
  "HDL_97_AlkB" => ["/data/vickers_lab/20210331_6092_ES/6092-ES-4_S1_L005_R1_001.fastq.gz"],
  "HDL_98_AlkB" => ["/data/vickers_lab/20210331_6092_ES/6092-ES-5_S1_L005_R1_001.fastq.gz"],
  "HDL_99_AlkB" => ["/data/vickers_lab/20210331_6092_ES/6092-ES-6_S1_L005_R1_001.fastq.gz"],
  "LDL_96_AlkB" => ["/data/vickers_lab/20210331_6092_ES/6092-ES-7_S1_L005_R1_001.fastq.gz"],
  "LDL_97_AlkB" => ["/data/vickers_lab/20210331_6092_ES/6092-ES-8_S1_L005_R1_001.fastq.gz"],
  "LDL_98_AlkB" => ["/data/vickers_lab/20210331_6092_ES/6092-ES-9_S1_L005_R1_001.fastq.gz"], 
  "LDL_99_AlkB" => ["/data/vickers_lab/20210331_6092_ES/6092-ES-10_S1_L005_R1_001.fastq.gz"],
  "Water_Unt" => ["/data/vickers_lab/20210331_6092_ES/6092-ES-11_S1_L005_R1_001.fastq.gz"],
  "THP1_Unt" => ["/data/vickers_lab/20210331_6092_ES/6092-ES-12_S1_L005_R1_001.fastq.gz"],
  "HDL_96_Unt" => ["/data/vickers_lab/20210331_6092_ES/6092-ES-13_S1_L005_R1_001.fastq.gz"],
  "HDL_97_Unt" => ["/data/vickers_lab/20210331_6092_ES/6092-ES-14_S1_L005_R1_001.fastq.gz"],
  "HDL_98_Unt" => ["/data/vickers_lab/20210331_6092_ES/6092-ES-15_S1_L005_R1_001.fastq.gz"],
  "HDL_99_Unt" => ["/data/vickers_lab/20210331_6092_ES/6092-ES-16_S1_L005_R1_001.fastq.gz"],
  "LDL_96_Unt" => ["/data/vickers_lab/20210331_6092_ES/6092-ES-17_S1_L005_R1_001.fastq.gz"],
  "LDL_97_Unt" => ["/data/vickers_lab/20210331_6092_ES/6092-ES-18_S1_L005_R1_001.fastq.gz"],
  "LDL_98_Unt" => ["/data/vickers_lab/20210331_6092_ES/6092-ES-19_S1_L005_R1_001.fastq.gz"],
  "LDL_99_Unt" => ["/data/vickers_lab/20210331_6092_ES/6092-ES-20_S1_L005_R1_001.fastq.gz"],
  "Water" => ["/data/vickers_lab/20210331_6092_ES/6092-ES-21_S1_L005_R1_001.fastq.gz"],
  "THP1" => ["/data/vickers_lab/20210331_6092_ES/6092-ES-22_S1_L005_R1_001.fastq.gz"],
},

#group information for visualization and comparison
  groups => {
    "Water_AlkB" => ["Water_AlkB"],
    "Water_Unt" => ["Water_Unt"],
    "THP1_AlkB" => ["THP1_AlkB"],
    "THP1_Unt" => ["THP1_Unt"],
    "LDL_AlkB" => ["LDL_96_AlkB", "LDL_97_AlkB", "LDL_98_AlkB", "LDL_99_AlkB"],
    "LDL_Unt" => ["LDL_96_Unt", "LDL_97_Unt", "LDL_98_Unt", "LDL_99_Unt"],
    "HDL_AlkB" => ["HDL_96_AlkB", "HDL_97_AlkB", "HDL_98_AlkB", "HDL_99_AlkB"],
    "HDL_Unt" => ["HDL_96_Unt", "HDL_97_Unt", "HDL_98_Unt", "HDL_99_Unt"],
  },

  #Comparison information, in each comparison, the first one is control. For example, in comparison "DMSO_vs_FED", "FED" is control.
  pairs => {
    "HDL_AlkB_vs_HDL_Untreated" => ["HDL_Unt", "HDL_AlkB"],
    "LDL_AlkB_vs_LDL_Untreated" => ["LDL_Unt", "LDL_AlkB"],
    #"THP1_AlkB_vs_THP1_Untreated" => ["THP1_Unt", "THP1_AlkB"],
    #"Water_AlkB_vs_Water_Untreated" => ["Water_Unt", "Water_AlkB"],
  },

};

my $config = performSmallRNA_hg19( $def, 1 );

1;

