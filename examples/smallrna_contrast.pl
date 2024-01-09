#!/usr/bin/perl
use strict;
use warnings;

use CQS::PerformSmallRNA;
use CQS::ClassFactory;

my $def = {

    #General options
    task_name => "mouse10875",
    email     => "quanhu.sheng.1\@vumc.org",
    emailType => "FAIL",
    target_dir =>"/nobackup/h_vangard_1/chenh19/alissa_weaver/smallRNA_mouse_10875",
    max_thread => 8,
    is_paired_end => 0,


    search_nonhost_genome => 1,
    search_nonhost_library => 1,
    search_refseq_bacteria => 0,

  #Default software parameter (don't change it except you really know it)
    remove_sequences => "'CCACGTTCCCGTGG;ACAGTCCGACGATC'",
    fastq_remove_random => 0,

    bowtie1_genome_unmapped_reads_mem => "30G",
    identical_sequence_count_table_mem=>"50G",

    
    cutadapt_option => "-a TGGAATTCTCGG -a GATCGTCGGACT",
    fastq_remove_random_3 => 4,
    fastq_remove_random_5 => 4,

    search_nonhost_genome_custom_group => 0,
    perform_host_tRNA_absolute_position => 0,
    perform_short_reads_deseq2 => 0,
    perform_host_genome_reads_deseq2 => 0,

    # sample count = 12
    #Data
    files => {
      "KD_Cell_N1" => ['/data/cqs/chenh19/alissa_weaver/smallRNA_mouse_10875/data/10875-DM-1_26_S1_L005_R1_001.fastq.gz'],
      "KD_Cell_N2" => ['/data/cqs/chenh19/alissa_weaver/smallRNA_mouse_10875/data/10875-DM-1_28_S1_L005_R1_001.fastq.gz'],
      "KD_Cell_N3" => ['/data/cqs/chenh19/alissa_weaver/smallRNA_mouse_10875/data/10875-DM-1_30_S1_L005_R1_001.fastq.gz'],
      "KD_Cell_N4" => ['/data/cqs/chenh19/alissa_weaver/smallRNA_mouse_10875/data/10875-DM-1_32_S1_L005_R1_001.fastq.gz'],
      "KD_Cell_N6" => ['/data/cqs/chenh19/alissa_weaver/smallRNA_mouse_10875/data/10875-DM-1_35_S1_L005_R1_001.fastq.gz'],
      "KD_sEV_N1" => ['/data/cqs/chenh19/alissa_weaver/smallRNA_mouse_10875/data/10875-DM-1_37_S1_L005_R1_001.fastq.gz'],
      "KD_sEV_N2" => ['/data/cqs/chenh19/alissa_weaver/smallRNA_mouse_10875/data/10875-DM-1_39_S1_L005_R1_001.fastq.gz'],
      "KD_sEV_N3" => ['/data/cqs/chenh19/alissa_weaver/smallRNA_mouse_10875/data/10875-DM-1_41_S1_L005_R1_001.fastq.gz'],
      "KD_sEV_N4" => ['/data/cqs/chenh19/alissa_weaver/smallRNA_mouse_10875/data/10875-DM-1_43_S1_L005_R1_001.fastq.gz'],
      "KD_sEV_N6" => ['/data/cqs/chenh19/alissa_weaver/smallRNA_mouse_10875/data/10875-DM-1_46_S1_L005_R1_001.fastq.gz'],
      "PA_Cell_N1" => ['/data/cqs/chenh19/alissa_weaver/smallRNA_mouse_10875/data/10875-DM-1_02_S1_L005_R1_001.fastq.gz'],
      "PA_Cell_N2" => ['/data/cqs/chenh19/alissa_weaver/smallRNA_mouse_10875/data/10875-DM-1_04_S1_L005_R1_001.fastq.gz'],
      "PA_Cell_N3" => ['/data/cqs/chenh19/alissa_weaver/smallRNA_mouse_10875/data/10875-DM-1_06_S1_L005_R1_001.fastq.gz'],
      "PA_Cell_N4" => ['/data/cqs/chenh19/alissa_weaver/smallRNA_mouse_10875/data/10875-DM-1_08_S1_L005_R1_001.fastq.gz'],
      "PA_Cell_N5" => ['/data/cqs/chenh19/alissa_weaver/smallRNA_mouse_10875/data/10875-DM-1_10_S1_L005_R1_001.fastq.gz'],
      "PA_Cell_N6" => ['/data/cqs/chenh19/alissa_weaver/smallRNA_mouse_10875/data/10875-DM-1_12_S1_L005_R1_001.fastq.gz'],
      "PA_sEV_N1" => ['/data/cqs/chenh19/alissa_weaver/smallRNA_mouse_10875/data/10875-DM-1_14_S1_L005_R1_001.fastq.gz'],
      "PA_sEV_N2" => ['/data/cqs/chenh19/alissa_weaver/smallRNA_mouse_10875/data/10875-DM-1_16_S1_L005_R1_001.fastq.gz'],
      "PA_sEV_N3" => ['/data/cqs/chenh19/alissa_weaver/smallRNA_mouse_10875/data/10875-DM-1_18_S1_L005_R1_001.fastq.gz'],
      "PA_sEV_N4" => ['/data/cqs/chenh19/alissa_weaver/smallRNA_mouse_10875/data/10875-DM-1_20_S1_L005_R1_001.fastq.gz'],
      "PA_sEV_N5" => ['/data/cqs/chenh19/alissa_weaver/smallRNA_mouse_10875/data/10875-DM-1_22_S1_L005_R1_001.fastq.gz'],
      "PA_sEV_N6" => ['/data/cqs/chenh19/alissa_weaver/smallRNA_mouse_10875/data/10875-DM-1_24_S1_L005_R1_001.fastq.gz'],
      "SC_Cell_N1" => ['/data/cqs/chenh19/alissa_weaver/smallRNA_mouse_10875/data/10875-DM-1_25_S1_L005_R1_001.fastq.gz'],
      "SC_Cell_N2" => ['/data/cqs/chenh19/alissa_weaver/smallRNA_mouse_10875/data/10875-DM-1_27_S1_L005_R1_001.fastq.gz'],
      "SC_Cell_N3" => ['/data/cqs/chenh19/alissa_weaver/smallRNA_mouse_10875/data/10875-DM-1_29_S1_L005_R1_001.fastq.gz'],
      "SC_Cell_N4" => ['/data/cqs/chenh19/alissa_weaver/smallRNA_mouse_10875/data/10875-DM-1_31_S1_L005_R1_001.fastq.gz'],
      "SC_Cell_N5" => ['/data/cqs/chenh19/alissa_weaver/smallRNA_mouse_10875/data/10875-DM-1_33_S1_L005_R1_001.fastq.gz'],
      "SC_Cell_N6" => ['/data/cqs/chenh19/alissa_weaver/smallRNA_mouse_10875/data/10875-DM-1_34_S1_L005_R1_001.fastq.gz'],
      "SC_sEV_N1" => ['/data/cqs/chenh19/alissa_weaver/smallRNA_mouse_10875/data/10875-DM-1_36_S1_L005_R1_001.fastq.gz'],
      "SC_sEV_N2" => ['/data/cqs/chenh19/alissa_weaver/smallRNA_mouse_10875/data/10875-DM-1_38_S1_L005_R1_001.fastq.gz'],
      "SC_sEV_N3" => ['/data/cqs/chenh19/alissa_weaver/smallRNA_mouse_10875/data/10875-DM-1_40_S1_L005_R1_001.fastq.gz'],
      "SC_sEV_N4" => ['/data/cqs/chenh19/alissa_weaver/smallRNA_mouse_10875/data/10875-DM-1_42_S1_L005_R1_001.fastq.gz'],
      "SC_sEV_N5" => ['/data/cqs/chenh19/alissa_weaver/smallRNA_mouse_10875/data/10875-DM-1_44_S1_L005_R1_001.fastq.gz'],
      "SC_sEV_N6" => ['/data/cqs/chenh19/alissa_weaver/smallRNA_mouse_10875/data/10875-DM-1_45_S1_L005_R1_001.fastq.gz'],
      "Veh_Cont_Cell_N1" => ['/data/cqs/chenh19/alissa_weaver/smallRNA_mouse_10875/data/10875-DM-1_01_S1_L005_R1_001.fastq.gz'],
      "Veh_Cont_Cell_N2" => ['/data/cqs/chenh19/alissa_weaver/smallRNA_mouse_10875/data/10875-DM-1_03_S1_L005_R1_001.fastq.gz'],
      "Veh_Cont_Cell_N3" => ['/data/cqs/chenh19/alissa_weaver/smallRNA_mouse_10875/data/10875-DM-1_05_S1_L005_R1_001.fastq.gz'],
      "Veh_Cont_Cell_N4" => ['/data/cqs/chenh19/alissa_weaver/smallRNA_mouse_10875/data/10875-DM-1_07_S1_L005_R1_001.fastq.gz'],
      "Veh_Cont_Cell_N5" => ['/data/cqs/chenh19/alissa_weaver/smallRNA_mouse_10875/data/10875-DM-1_09_S1_L005_R1_001.fastq.gz'],
      "Veh_Cont_Cell_N6" => ['/data/cqs/chenh19/alissa_weaver/smallRNA_mouse_10875/data/10875-DM-1_11_S1_L005_R1_001.fastq.gz'],
      "Veh_Cont_sEV_N1" => ['/data/cqs/chenh19/alissa_weaver/smallRNA_mouse_10875/data/10875-DM-1_13_S1_L005_R1_001.fastq.gz'],
      "Veh_Cont_sEV_N2" => ['/data/cqs/chenh19/alissa_weaver/smallRNA_mouse_10875/data/10875-DM-1_15_S1_L005_R1_001.fastq.gz'],
      "Veh_Cont_sEV_N3" => ['/data/cqs/chenh19/alissa_weaver/smallRNA_mouse_10875/data/10875-DM-1_17_S1_L005_R1_001.fastq.gz'],
      "Veh_Cont_sEV_N4" => ['/data/cqs/chenh19/alissa_weaver/smallRNA_mouse_10875/data/10875-DM-1_19_S1_L005_R1_001.fastq.gz'],
      "Veh_Cont_sEV_N5" => ['/data/cqs/chenh19/alissa_weaver/smallRNA_mouse_10875/data/10875-DM-1_21_S1_L005_R1_001.fastq.gz'],
      "Veh_Cont_sEV_N6" => ['/data/cqs/chenh19/alissa_weaver/smallRNA_mouse_10875/data/10875-DM-1_23_S1_L005_R1_001.fastq.gz']
    },

  # group information for visualization and comparison
  groups_pattern => {
    "KD_cell" => 'KD_Cell',
    "KD_ev" => 'KD_sEV',

    'PA_cell' => 'PA_Cell',
    'PA_ev' => 'PA_sEV',

    'SC_cell' => 'SC_Cell', 
    'SC_ev' => 'SC_sEV', 

    'Veh_ctrl_cell' => 'Veh_Cont_Cell', 
    'Veh_ctrl_ev' => 'Veh_Cont_sEV', 
  },

  # group pair info
  pairs => {
    'PA_cell_vs_VC_cell' => {
      groups => ['Veh_ctrl_cell', 'Veh_ctrl_ev', 'PA_cell', 'PA_ev'],
      contrast => "list(c('Condition_PA_ev_vs_Veh_ctrl_cell'), c('Condition_PA_cell_vs_Veh_ctrl_cell', 'Condition_Veh_ctrl_ev_vs_Veh_ctrl_cell'))",
    },
  }
};

my $config = performSmallRNA_mm10( $def, 0 );
#$config->{"deseq2_miRNA_TotalReads"}{class} = "Comparison::DESeq2contrast";
$config->{"deseq2_miRNA_TotalReads"}{target_dir} = "/nobackup/h_cqs/shengq2/temp/deseq2_miRNA_TotalReads";
performConfig($config,"deseq2_miRNA_TotalReads");

1;
