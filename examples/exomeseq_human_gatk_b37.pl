#!/usr/bin/perl
use strict;
use warnings;

use CQS::FileUtils;
use CQS::SystemUtils;
use CQS::ConfigUtils;
use CQS::ClassFactory;
use CQS::PerformExomeSeq;

my $def = {
  task_name => "linton_exomeseq_2118",

  #target_dir => "T:/Shared/Labs/Linton Lab/20180913_linton_exomeseq_2118_human_cutadapt",
  target_dir => "/scratch/cqs/shengq2/macrae_linton/20180913_linton_exomeseq_2118_human_cutadapt",
  email      => "quanhu.sheng.1\@vumc.org",
  files      => {
    "MEL194" =>
      [ "/data/h_vangard_1/macrae_linton_data/2118/2118-JB-1-AGTGTTGC-ATGTAACG_S329_R1_001.fastq.gz", "/data/h_vangard_1/macrae_linton_data/2118/2118-JB-1-AGTGTTGC-ATGTAACG_S329_R2_001.fastq.gz" ],
    "AF245" =>
      [ "/data/h_vangard_1/macrae_linton_data/2118/2118-JB-2-TTACCTGG-GATTCTGA_S330_R1_001.fastq.gz", "/data/h_vangard_1/macrae_linton_data/2118/2118-JB-2-TTACCTGG-GATTCTGA_S330_R2_001.fastq.gz" ],
    "AK417" =>
      [ "/data/h_vangard_1/macrae_linton_data/2118/2118-JB-3-TCTATCCT-GAGAGGTT_S331_R1_001.fastq.gz", "/data/h_vangard_1/macrae_linton_data/2118/2118-JB-3-TCTATCCT-GAGAGGTT_S331_R2_001.fastq.gz" ],
    "SH132" =>
      [ "/data/h_vangard_1/macrae_linton_data/2118/2118-JB-4-TTCTACAT-TTGTATCA_S332_R1_001.fastq.gz", "/data/h_vangard_1/macrae_linton_data/2118/2118-JB-4-TTCTACAT-TTGTATCA_S332_R2_001.fastq.gz" ],
    "DJ023" =>
      [ "/data/h_vangard_1/macrae_linton_data/2118/2118-JB-5-GCCATATA-AATTCTTG_S333_R1_001.fastq.gz", "/data/h_vangard_1/macrae_linton_data/2118/2118-JB-5-GCCATATA-AATTCTTG_S333_R2_001.fastq.gz" ],
    "CA311" =>
      [ "/data/h_vangard_1/macrae_linton_data/2118/2118-JB-6-CGGTTACG-CATATGCG_S334_R1_001.fastq.gz", "/data/h_vangard_1/macrae_linton_data/2118/2118-JB-6-CGGTTACG-CATATGCG_S334_R2_001.fastq.gz" ],
    "RL028" =>
      [ "/data/h_vangard_1/macrae_linton_data/2118/2118-JB-7-GGCGATCA-TGTCTGGC_S335_R1_001.fastq.gz", "/data/h_vangard_1/macrae_linton_data/2118/2118-JB-7-GGCGATCA-TGTCTGGC_S335_R2_001.fastq.gz" ],
    "RN027" =>
      [ "/data/h_vangard_1/macrae_linton_data/2118/2118-JB-8-AGACTGCG-GTAACTTG_S336_R1_001.fastq.gz", "/data/h_vangard_1/macrae_linton_data/2118/2118-JB-8-AGACTGCG-GTAACTTG_S336_R2_001.fastq.gz" ],
    "CL153" =>
      [ "/data/h_vangard_1/macrae_linton_data/2118/2118-JB-9-GACACCAT-GCACGGTA_S337_R1_001.fastq.gz", "/data/h_vangard_1/macrae_linton_data/2118/2118-JB-9-GACACCAT-GCACGGTA_S337_R2_001.fastq.gz" ],
    "MK414" =>
      [ "/data/h_vangard_1/macrae_linton_data/2118/2118-JB-10-CCGTTCAA-AGCCTCAG_S338_R1_001.fastq.gz", "/data/h_vangard_1/macrae_linton_data/2118/2118-JB-10-CCGTTCAA-AGCCTCAG_S338_R2_001.fastq.gz" ],
    "KS165" =>
      [ "/data/h_vangard_1/macrae_linton_data/2118/2118-JB-11-CTCGCTTC-AGAGAACC_S339_R1_001.fastq.gz", "/data/h_vangard_1/macrae_linton_data/2118/2118-JB-11-CTCGCTTC-AGAGAACC_S339_R2_001.fastq.gz" ],
    "ML188" =>
      [ "/data/h_vangard_1/macrae_linton_data/2118/2118-JB-12-CCTCGTGC-CCACGCTG_S340_R1_001.fastq.gz", "/data/h_vangard_1/macrae_linton_data/2118/2118-JB-12-CCTCGTGC-CCACGCTG_S340_R2_001.fastq.gz" ],
    "BD016" =>
      [ "/data/h_vangard_1/macrae_linton_data/2118/2118-JB-13-ATTGCGCG-GGCCTCCA_S341_R1_001.fastq.gz", "/data/h_vangard_1/macrae_linton_data/2118/2118-JB-13-ATTGCGCG-GGCCTCCA_S341_R2_001.fastq.gz" ],
    "LD360" =>
      [ "/data/h_vangard_1/macrae_linton_data/2118/2118-JB-14-TAACCGTA-TGCGCATA_S342_R1_001.fastq.gz", "/data/h_vangard_1/macrae_linton_data/2118/2118-JB-14-TAACCGTA-TGCGCATA_S342_R2_001.fastq.gz" ],
    "AM115" =>
      [ "/data/h_vangard_1/macrae_linton_data/2118/2118-JB-15-AATAGCTG-CACTCAAT_S343_R1_001.fastq.gz", "/data/h_vangard_1/macrae_linton_data/2118/2118-JB-15-AATAGCTG-CACTCAAT_S343_R2_001.fastq.gz" ],
    "PP411" =>
      [ "/data/h_vangard_1/macrae_linton_data/2118/2118-JB-16-GAGTCATA-ACGGTCCA_S344_R1_001.fastq.gz", "/data/h_vangard_1/macrae_linton_data/2118/2118-JB-16-GAGTCATA-ACGGTCCA_S344_R2_001.fastq.gz" ],
    "MK415" =>
      [ "/data/h_vangard_1/macrae_linton_data/2118/2118-JB-17-CTGAGGAA-TCTAGGCG_S345_R1_001.fastq.gz", "/data/h_vangard_1/macrae_linton_data/2118/2118-JB-17-CTGAGGAA-TCTAGGCG_S345_R2_001.fastq.gz" ],
    "MK416" =>
      [ "/data/h_vangard_1/macrae_linton_data/2118/2118-JB-18-TGATGTAA-ATGTTGTT_S346_R1_001.fastq.gz", "/data/h_vangard_1/macrae_linton_data/2118/2118-JB-18-TGATGTAA-ATGTTGTT_S346_R2_001.fastq.gz" ],
    "ZR350" =>
      [ "/data/h_vangard_1/macrae_linton_data/2118/2118-JB-19-GGTCCGCT-CTGGCAAG_S347_R1_001.fastq.gz", "/data/h_vangard_1/macrae_linton_data/2118/2118-JB-19-GGTCCGCT-CTGGCAAG_S347_R2_001.fastq.gz" ],
    "VR213" =>
      [ "/data/h_vangard_1/macrae_linton_data/2118/2118-JB-20-ACCGGCCG-GAATACCT_S348_R1_001.fastq.gz", "/data/h_vangard_1/macrae_linton_data/2118/2118-JB-20-ACCGGCCG-GAATACCT_S348_R2_001.fastq.gz" ],
    "CW356" =>
      [ "/data/h_vangard_1/macrae_linton_data/2118/2118-JB-21-CAAGACGT-TAGGCTCG_S349_R1_001.fastq.gz", "/data/h_vangard_1/macrae_linton_data/2118/2118-JB-21-CAAGACGT-TAGGCTCG_S349_R2_001.fastq.gz" ],
    "CM427" =>
      [ "/data/h_vangard_1/macrae_linton_data/2118/2118-JB-22-ACATGAGT-GCGTCCAC_S350_R1_001.fastq.gz", "/data/h_vangard_1/macrae_linton_data/2118/2118-JB-22-ACATGAGT-GCGTCCAC_S350_R2_001.fastq.gz" ],
    "M431" =>
      [ "/data/h_vangard_1/macrae_linton_data/2118/2118-JB-23-ATACCAAC-ACAGTAAG_S351_R1_001.fastq.gz", "/data/h_vangard_1/macrae_linton_data/2118/2118-JB-23-ATACCAAC-ACAGTAAG_S351_R2_001.fastq.gz" ],
    "AE561" =>
      [ "/data/h_vangard_1/macrae_linton_data/2118/2118-JB-24-TCTGGTAT-CGCTTAGA_S352_R1_001.fastq.gz", "/data/h_vangard_1/macrae_linton_data/2118/2118-JB-24-TCTGGTAT-CGCTTAGA_S352_R2_001.fastq.gz" ],
    "KC562" =>
      [ "/data/h_vangard_1/macrae_linton_data/2118/2118-JB-25-TCAGAAGG-CTCGAATA_S353_R1_001.fastq.gz", "/data/h_vangard_1/macrae_linton_data/2118/2118-JB-25-TCAGAAGG-CTCGAATA_S353_R2_001.fastq.gz" ],
    "JE563" =>
      [ "/data/h_vangard_1/macrae_linton_data/2118/2118-JB-26-CAGCACGG-GCACCACC_S354_R1_001.fastq.gz", "/data/h_vangard_1/macrae_linton_data/2118/2118-JB-26-CAGCACGG-GCACCACC_S354_R2_001.fastq.gz" ],
    "AB577" =>
      [ "/data/h_vangard_1/macrae_linton_data/2118/2118-JB-27-AACTTATC-TCAATGGA_S355_R1_001.fastq.gz", "/data/h_vangard_1/macrae_linton_data/2118/2118-JB-27-AACTTATC-TCAATGGA_S355_R2_001.fastq.gz" ],
    "DL024" =>
      [ "/data/h_vangard_1/macrae_linton_data/2118/2118-JB-28-GTTAATTA-AGGCGTTC_S356_R1_001.fastq.gz", "/data/h_vangard_1/macrae_linton_data/2118/2118-JB-28-GTTAATTA-AGGCGTTC_S356_R2_001.fastq.gz" ],
    "CR108" =>
      [ "/data/h_vangard_1/macrae_linton_data/2118/2118-JB-29-TGGAGTAC-CGAATCTA_S357_R1_001.fastq.gz", "/data/h_vangard_1/macrae_linton_data/2118/2118-JB-29-TGGAGTAC-CGAATCTA_S357_R2_001.fastq.gz" ],
    "KP150" =>
      [ "/data/h_vangard_1/macrae_linton_data/2118/2118-JB-30-GTGCAGAC-ATACTTGT_S358_R1_001.fastq.gz", "/data/h_vangard_1/macrae_linton_data/2118/2118-JB-30-GTGCAGAC-ATACTTGT_S358_R2_001.fastq.gz" ],
    "KP151" =>
      [ "/data/h_vangard_1/macrae_linton_data/2118/2118-JB-31-GCGTTGGT-GTGACGGA_S359_R1_001.fastq.gz", "/data/h_vangard_1/macrae_linton_data/2118/2118-JB-31-GCGTTGGT-GTGACGGA_S359_R2_001.fastq.gz" ],
    "HB154" =>
      [ "/data/h_vangard_1/macrae_linton_data/2118/2118-JB-32-CTCAACGC-TATCCGAG_S360_R1_001.fastq.gz", "/data/h_vangard_1/macrae_linton_data/2118/2118-JB-32-CTCAACGC-TATCCGAG_S360_R2_001.fastq.gz" ],
  },
  merge_fastq => 0,

  is_paired        => 1,
  perform_cutadapt => 0,
  adapter          => "AGATCGGAAGAGC",
  min_read_length  => 30,

  covered_bed                 => "/scratch/cqs/references/exomeseq/IDT/xgen-exome-research-panel-targetsae255a1532796e2eaa53ff00001c1b3c.nochr.bed",
  perform_gatk_callvariants   => 1,
  gatk_callvariants_vqsr_mode => 0,
  
  filter_variants_by_allele_frequency => 0,
  filter_variants_by_allele_frequency_percentage => 0.9,
  filter_variants_by_allele_frequency_maf => 0.3,
  
  #annotation_genes            => "LDLR APOB PCSK9 LDLRAP1 STAP1 LIPA ABCG5 ABCGB APOE LPA PNPLA5 CH25H INSIG2 SIRT1",

  perform_cnv_cnMOPs => 0,
  perform_vep        => 0,

  perform_cnv_gatk4_cohort => 0,

  cnv_xhmm_preprocess_intervals => 0,
  perform_cnv_xhmm              => 0,
};

my $config = performExomeSeq_gatk_b37( $def, 1 );
1;

