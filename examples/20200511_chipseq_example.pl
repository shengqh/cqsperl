#!/usr/bin/perl
use strict;
use warnings;

use CQS::ClassFactory;
use CQS::FileUtils;
use Data::Dumper;
use Pipeline::SmallRNAUtils;
use CQS::PerformChIPSeq;

my $def = {
  task_name  => "chipseq_example",
  email      => "quanhu.sheng.1\@vumc.org",
  target_dir => create_directory_or_die("/scratch/cqs/shengq2/temp/20200511_chip-seq"),
  constraint => "haswell",

  #add_folder_index => 1,

  perform_cutadapt => 0,
  adapter          => "AGATCGGAAGAGCACACGTCTGAACTCCAGTCAC",                                                 #trueseq adapter
  min_read_length  => 30,

  aligner       => "bowtie2",

  #peak
  peak_caller     => "macs2",
  macs2_genome    => "hs",
  macs2_peak_type => "narrow",
  macs2_option    => "-B -q 0.01 -g hs --nomodel --extsize 146",

  #macs2_peak_type => "broad",
  #macs2_option => "--broad --broad-cutoff 0.1 -B -q 0.01 -g hs --nomodel --extsize 146",

  #cqstools file_def -i . -n 152.\(.+?\)\-\(.+?\)_ -a
  files => {
    "wt_h3k4me1_1"     => ["/scratch/shavertm/20170512_chip-seq/fastq/152-TS-1_S1_R1_001.fastq.gz"],
    "wt_h3k4me1_2"     => ["/scratch/shavertm/20170512_chip-seq/fastq/152-TS-2_S2_R1_001.fastq.gz"],
    "r175h_h3k4me1_1"  => ["/scratch/shavertm/20170512_chip-seq/fastq/152-TS-3_S3_R1_001.fastq.gz"],
    "r175h_h3k4me1_2"  => ["/scratch/shavertm/20170512_chip-seq/fastq/152-TS-4_S4_R1_001.fastq.gz"],
    "r273h_h3k4me1_1"  => ["/scratch/shavertm/20170512_chip-seq/fastq/152-TS-5_S5_R1_001.fastq.gz"],
    "r273h_h3k4me1_2"  => ["/scratch/shavertm/20170512_chip-seq/fastq/152-TS-6_S6_R1_001.fastq.gz"],
    "null_h3k4me1_1"   => ["/scratch/shavertm/20170512_chip-seq/fastq/152-TS-7_S7_R1_001.fastq.gz"],
    "null_h3k4me1_2"   => ["/scratch/shavertm/20170512_chip-seq/fastq/152-TS-8_S8_R1_001.fastq.gz"],
    "wt_h3k27ac_1"     => ["/scratch/shavertm/20170512_chip-seq/fastq/152-TS-9_S9_R1_001.fastq.gz"],
    "wt_h3k27ac_2"     => ["/scratch/shavertm/20170512_chip-seq/fastq/152-TS-10_S10_R1_001.fastq.gz"],
    "r175h_h3k27ac_1"  => ["/scratch/shavertm/20170512_chip-seq/fastq/152-TS-11_S11_R1_001.fastq.gz"],
    "r175h_h3k27ac_2"  => ["/scratch/shavertm/20170512_chip-seq/fastq/152-TS-12_S12_R1_001.fastq.gz"],
    "r273h_h3k27ac_1"  => ["/scratch/shavertm/20170512_chip-seq/fastq/152-TS-13_S13_R1_001.fastq.gz"],
    "r273h_h3k27ac_2"  => ["/scratch/shavertm/20170512_chip-seq/fastq/152-TS-14_S14_R1_001.fastq.gz"],
    "null_h3k27ac_1"   => ["/scratch/shavertm/20170512_chip-seq/fastq/152-TS-15_S15_R1_001.fastq.gz"],
    "null_h3k27ac_2"   => ["/scratch/shavertm/20170512_chip-seq/fastq/152-TS-16_S16_R1_001.fastq.gz"],
    "wt_h3k4me3_1"     => ["/scratch/shavertm/20170512_chip-seq/fastq/152-TS-17_S17_R1_001.fastq.gz"],
    "wt_h3k4me3_2"     => ["/scratch/shavertm/20170512_chip-seq/fastq/152-TS-18_S18_R1_001.fastq.gz"],
    "r175h_h3k4me3_1"  => ["/scratch/shavertm/20170512_chip-seq/fastq/152-TS-19_S19_R1_001.fastq.gz"],
    "r175h_h3k4me3_2"  => ["/scratch/shavertm/20170512_chip-seq/fastq/152-TS-20_S20_R1_001.fastq.gz"],
    "r273h_h3k4me3_1"  => ["/scratch/shavertm/20170512_chip-seq/fastq/152-TS-21_S21_R1_001.fastq.gz"],
    "r273h_h3k4me3_2"  => ["/scratch/shavertm/20170512_chip-seq/fastq/152-TS-22_S22_R1_001.fastq.gz"],
    "null_h3k4me3_1"   => ["/scratch/shavertm/20170512_chip-seq/fastq/152-TS-23_S23_R1_001.fastq.gz"],
    "null_h3k4me3_2"   => ["/scratch/shavertm/20170512_chip-seq/fastq/152-TS-24_S24_R1_001.fastq.gz"],
    "wt_rnapolii_1"    => ["/scratch/shavertm/20170512_chip-seq/fastq/152-TS-25_S25_R1_001.fastq.gz"],
    "wt_rnapolii_2"    => ["/scratch/shavertm/20170512_chip-seq/fastq/152-TS-26_S26_R1_001.fastq.gz"],
    "r175h_rnapolii_1" => ["/scratch/shavertm/20170512_chip-seq/fastq/152-TS-27_S27_R1_001.fastq.gz"],
    "r175h_rnapolii_2" => ["/scratch/shavertm/20170512_chip-seq/fastq/152-TS-28_S28_R1_001.fastq.gz"],
    "r273h_rnapolii_1" => ["/scratch/shavertm/20170512_chip-seq/fastq/152-TS-29_S29_R1_001.fastq.gz"],
    "r273h_rnapolii_2" => ["/scratch/shavertm/20170512_chip-seq/fastq/152-TS-30_S30_R1_001.fastq.gz"],
    "null_rnapolii_1"  => ["/scratch/shavertm/20170512_chip-seq/fastq/152-TS-31_S31_R1_001.fastq.gz"],
    "null_rnapolii_2"  => ["/scratch/shavertm/20170512_chip-seq/fastq/152-TS-32_S32_R1_001.fastq.gz"],
    "wt_input_1"       => ["/scratch/shavertm/20170512_chip-seq/fastq/152-TS-33_S33_R1_001.fastq.gz"],
    "wt_input_2"       => ["/scratch/shavertm/20170512_chip-seq/fastq/152-TS-34_S34_R1_001.fastq.gz"],
    "r175h_input_1"    => ["/scratch/shavertm/20170512_chip-seq/fastq/152-TS-35_S35_R1_001.fastq.gz"],
    "r175h_input_2"    => ["/scratch/shavertm/20170512_chip-seq/fastq/152-TS-36_S36_R1_001.fastq.gz"],
    "r273h_input_1"    => ["/scratch/shavertm/20170512_chip-seq/fastq/152-TS-37_S37_R1_001.fastq.gz"],
    "r273h_input_2"    => ["/scratch/shavertm/20170512_chip-seq/fastq/152-TS-38_S38_R1_001.fastq.gz"],
    "null_input_1"     => ["/scratch/shavertm/20170512_chip-seq/fastq/152-TS-39_S39_R1_001.fastq.gz"],
    "null_input_2"     => ["/scratch/shavertm/20170512_chip-seq/fastq/152-TS-40_S40_R1_001.fastq.gz"],
  },

  treatments => {
    "wt_h3k4me1_1"     => ["wt_h3k4me1_1"],
    "wt_h3k4me1_2"     => ["wt_h3k4me1_2"],
    "r175h_h3k4me1_1"  => ["r175h_h3k4me1_1"],
    "r175h_h3k4me1_2"  => ["r175h_h3k4me1_2"],
    "r273h_h3k4me1_1"  => ["r273h_h3k4me1_1"],
    "r273h_h3k4me1_2"  => ["r273h_h3k4me1_2"],
    "null_h3k4me1_1"   => ["null_h3k4me1_1"],
    "null_h3k4me1_2"   => ["null_h3k4me1_2"],
    "wt_h3k27ac_1"     => ["wt_h3k27ac_1"],
    "wt_h3k27ac_2"     => ["wt_h3k27ac_2"],
    "r175h_h3k27ac_1"  => ["r175h_h3k27ac_1"],
    "r175h_h3k27ac_2"  => ["r175h_h3k27ac_2"],
    "r273h_h3k27ac_1"  => ["r273h_h3k27ac_1"],
    "r273h_h3k27ac_2"  => ["r273h_h3k27ac_2"],
    "null_h3k27ac_1"   => ["null_h3k27ac_1"],
    "null_h3k27ac_2"   => ["null_h3k27ac_2"],
    "wt_h3k4me3_1"     => ["wt_h3k4me3_1"],
    "wt_h3k4me3_2"     => ["wt_h3k4me3_2"],
    "r175h_h3k4me3_1"  => ["r175h_h3k4me3_1"],
    "r175h_h3k4me3_2"  => ["r175h_h3k4me3_2"],
    "r273h_h3k4me3_1"  => ["r273h_h3k4me3_1"],
    "r273h_h3k4me3_2"  => ["r273h_h3k4me3_2"],
    "null_h3k4me3_1"   => ["null_h3k4me3_1"],
    "null_h3k4me3_2"   => ["null_h3k4me3_2"],
    "wt_rnapolii_1"    => ["wt_rnapolii_1"],
    "wt_rnapolii_2"    => ["wt_rnapolii_2"],
    "r175h_rnapolii_1" => ["r175h_rnapolii_1"],
    "r175h_rnapolii_2" => ["r175h_rnapolii_2"],
    "r273h_rnapolii_1" => ["r273h_rnapolii_1"],
    "r273h_rnapolii_2" => ["r273h_rnapolii_2"],
    "null_rnapolii_1"  => ["null_rnapolii_1"],
    "null_rnapolii_2"  => ["null_rnapolii_2"],
  },
  controls => {
    "wt_h3k4me1_1"     => ["wt_input_1"],
    "wt_h3k4me1_2"     => ["wt_input_2"],
    "r175h_h3k4me1_1"  => ["r175h_input_1"],
    "r175h_h3k4me1_2"  => ["r175h_input_2"],
    "r273h_h3k4me1_1"  => ["r273h_input_1"],
    "r273h_h3k4me1_2"  => ["r273h_input_2"],
    "null_h3k4me1_1"   => ["null_input_1"],
    "null_h3k4me1_2"   => ["null_input_2"],
    "wt_h3k27ac_1"     => ["wt_input_1"],
    "wt_h3k27ac_2"     => ["wt_input_2"],
    "r175h_h3k27ac_1"  => ["r175h_input_1"],
    "r175h_h3k27ac_2"  => ["r175h_input_2"],
    "r273h_h3k27ac_1"  => ["r273h_input_1"],
    "r273h_h3k27ac_2"  => ["r273h_input_2"],
    "null_h3k27ac_1"   => ["null_input_1"],
    "null_h3k27ac_2"   => ["null_input_2"],
    "wt_h3k4me3_1"     => ["wt_input_1"],
    "wt_h3k4me3_2"     => ["wt_input_2"],
    "r175h_h3k4me3_1"  => ["r175h_input_1"],
    "r175h_h3k4me3_2"  => ["r175h_input_2"],
    "r273h_h3k4me3_1"  => ["r273h_input_1"],
    "r273h_h3k4me3_2"  => ["r273h_input_2"],
    "null_h3k4me3_1"   => ["null_input_1"],
    "null_h3k4me3_2"   => ["null_input_2"],
    "wt_rnapolii_1"    => ["wt_input_1"],
    "wt_rnapolii_2"    => ["wt_input_2"],
    "r175h_rnapolii_1" => ["r175h_input_1"],
    "r175h_rnapolii_2" => ["r175h_input_2"],
    "r273h_rnapolii_1" => ["r273h_input_1"],
    "r273h_rnapolii_2" => ["r273h_input_2"],
    "null_rnapolii_1"  => ["null_input_1"],
    "null_rnapolii_2"  => ["null_input_2"],
  },

  perform_chipqc          => 1,
  chipqc_genome           => "hg19",
  chipqc_chromosomes      => 'chr1,chr2,chr3,chr4,chr5,chr6,chr7,chr8,chr9,chr10,chr11,chr12,chr13,chr14,chr15,chr16,chr17,chr18,chr19,chr20,chr21,chr22',
  
  perform_diffbind        => 1,
  design_table            => {
    "h3k27ac" => {
      Factor           => "h3k27ac",
      "null_h3k27ac_1" => {
        Condition => "NULL",
        Replicate => "1"
      },
      "null_h3k27ac_2" => {
        Condition => "NULL",
        Replicate => "2"
      },
      "r175h_h3k27ac_1" => {
        Condition => "R175H",
        Replicate => "1"
      },
      "r175h_h3k27ac_2" => {
        Condition => "R175H",
        Replicate => "2"
      },
      "r273h_h3k27ac_1" => {
        Condition => "R273H",
        Replicate => "1"
      },
      "r273h_h3k27ac_2" => {
        Condition => "R273H",
        Replicate => "2"
      },
      "wt_h3k27ac_1" => {
        Condition => "WT",
        Replicate => "1"
      },
      "wt_h3k27ac_2" => {
        Condition => "WT",
        Replicate => "2"
      },
      "Comparison" => [
        [ "R175H_vs_WT",    "WT",    "R175H" ],
        [ "NULL_vs_WT",     "WT",    "NULL" ],
        [ "R273H_vs_WT",    "WT",    "R273H" ],
        [ "R175H_vs_R273H", "R273H", "R175H" ],
        [ "R175H_vs_NULL",  "NULL",  "R175H" ],
        [ "R273H_vs_NULL",  "NULL",  "R273H" ],
      ],
    },
    "h3k4me3" => {
      Factor           => "h3k4me3",
      "null_h3k4me3_1" => {
        Condition => "NULL",
        Replicate => "1"
      },
      "null_h3k4me3_2" => {
        Condition => "NULL",
        Replicate => "2"
      },
      "r175h_h3k4me3_1" => {
        Condition => "R175H",
        Replicate => "1"
      },
      "r175h_h3k4me3_2" => {
        Condition => "R175H",
        Replicate => "2"
      },
      "r273h_h3k4me3_1" => {
        Condition => "R273H",
        Replicate => "1"
      },
      "r273h_h3k4me3_2" => {
        Condition => "R273H",
        Replicate => "2"
      },
      "wt_h3k4me3_1" => {
        Condition => "WT",
        Replicate => "1"
      },
      "wt_h3k4me3_2" => {
        Condition => "WT",
        Replicate => "2"
      },
      "Comparison" => [
        [ "R175H_vs_WT",    "WT",    "R175H" ],
        [ "NULL_vs_WT",     "WT",    "NULL" ],
        [ "R273H_vs_WT",    "WT",    "R273H" ],
        [ "R175H_vs_R273H", "R273H", "R175H" ],
        [ "R175H_vs_NULL",  "NULL",  "R175H" ],
        [ "R273H_vs_NULL",  "NULL",  "R273H" ],
      ],
    },
    "h3k4me1" => {
      Factor           => "h3k4me1",
      "null_h3k4me1_1" => {
        Condition => "NULL",
        Replicate => "1"
      },
      "null_h3k4me1_2" => {
        Condition => "NULL",
        Replicate => "2"
      },
      "r273h_h3k4me1_1" => {
        Condition => "R273H",
        Replicate => "1"
      },
      "r273h_h3k4me1_2" => {
        Condition => "R273H",
        Replicate => "2"
      },
      "r175h_h3k4me1_1" => {
        Condition => "R175H",
        Replicate => "1"
      },
      "r175h_h3k4me1_2" => {
        Condition => "R175H",
        Replicate => "2"
      },
      "wt_h3k4me1_1" => {
        Condition => "WT",
        Replicate => "1"
      },
      "wt_h3k4me1_2" => {
        Condition => "WT",
        Replicate => "2"
      },
      "Comparison" => [
        [ "R175H_vs_WT",    "WT",    "R175H" ],
        [ "NULL_vs_WT",     "WT",    "NULL" ],
        [ "R273H_vs_WT",    "WT",    "R273H" ],
        [ "R175H_vs_R273H", "R273H", "R175H" ],
        [ "R175H_vs_NULL",  "NULL",  "R175H" ],
        [ "R273H_vs_NULL",  "NULL",  "R273H" ],
      ],
    },
    "rnapolii" => {
      Factor            => "rnapolii",
      "null_rnapolii_1" => {
        Condition => "NULL",
        Replicate => "1"
      },
      "null_rnapolii_2" => {
        Condition => "NULL",
        Replicate => "2"
      },
      "r175h_rnapolii_1" => {
        Condition => "R175H",
        Replicate => "1"
      },
      "r175h_rnapolii_2" => {
        Condition => "R175H",
        Replicate => "2"
      },
      "r273h_rnapolii_1" => {
        Condition => "R273H",
        Replicate => "1"
      },
      "r273h_rnapolii_2" => {
        Condition => "R273H",
        Replicate => "2"
      },
      "wt_rnapolii_1" => {
        Condition => "WT",
        Replicate => "1"
      },
      "wt_rnapolii_2" => {
        Condition => "WT",
        Replicate => "2"
      },
      "Comparison" => [
        [ "R175H_vs_WT",    "WT",    "R175H" ],
        [ "NULL_vs_WT",     "WT",    "NULL" ],
        [ "R273H_vs_WT",    "WT",    "R273H" ],
        [ "R175H_vs_R273H", "R273H", "R175H" ],
        [ "R175H_vs_NULL",  "NULL",  "R175H" ],
        [ "R273H_vs_NULL",  "NULL",  "R273H" ],
      ],
    },
  },

  perform_homer => 1,
  homer_annotation_genome => "hg19",
};

performChIPSeq_gencode_hg19($def);

1;
