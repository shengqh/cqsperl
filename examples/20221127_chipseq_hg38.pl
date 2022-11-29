#!/usr/bin/perl
use strict;
use warnings;

use CQS::FileUtils;
use CQS::PerformChIPSeq;
use CQS::ClassFactory;

my $def = {
  task_name        => "chipseq_hg38",
  email            => "quanhu.sheng.1\@vumc.org",
  target_dir       => create_directory_or_die("/scratch/h_vangard_1/shengq2/test/chipseq_hg38"),
  add_folder_index => 0,

  files => {
    "No_Treatment_1"       => ["/data/cqs/example_data/chipseq/batch01_S1_R1_001.fastq.gz"],
    "TNF_Veh_1"            => ["/data/cqs/example_data/chipseq/batch01_S2_R1_001.fastq.gz"],
    "THZ_TNF_1"          => ["/data/cqs/example_data/chipseq/batch01_S5_R1_001.fastq.gz"],
    "No_Treatment_Input_1" => ["/data/cqs/example_data/chipseq/batch01_S6_R1_001.fastq.gz"],
    "TNF_Veh_Input_1"      => ["/data/cqs/example_data/chipseq/batch01_S7_R1_001.fastq.gz"],
    "THZ_TNF_Input_1"    => ["/data/cqs/example_data/chipseq/batch01_S10_R1_001.fastq.gz"],

    "No_Treatment_2"       => ["/data/cqs/example_data/chipseq/batch02_S8_R1_001.fastq.gz"],
    "TNF_Veh_2"            => ["/data/cqs/example_data/chipseq/batch02_S1_R1_001.fastq.gz"],
    "THZ_TNF_2"            => ["/data/cqs/example_data/chipseq/batch02_S3_R1_001.fastq.gz"],
    "No_Treatment_Input_2" => ["/data/cqs/example_data/chipseq/batch02_S4_R1_001.fastq.gz"],
    "TNF_Veh_Input_2"      => ["/data/cqs/example_data/chipseq/batch02_S5_R1_001.fastq.gz"],
    "THZ_TNF_Input_2"      => ["/data/cqs/example_data/chipseq/batch02_S7_R1_001.fastq.gz"],
  },
  treatments => {
    "No_Treatment_1" => ["No_Treatment_1"],
    "TNF_Veh_1"      => ["TNF_Veh_1"],
    "THZ_TNF_1"    => ["THZ_TNF_1"],
    "No_Treatment_2" => ["No_Treatment_2"],
    "TNF_Veh_2"      => ["TNF_Veh_2"],
    "THZ_TNF_2"    => ["THZ_TNF_2"],
  },
  controls => {
    "No_Treatment_1" => ["No_Treatment_Input_1"],
    "TNF_Veh_1"      => ["TNF_Veh_Input_1"],
    "THZ_TNF_1"    => ["THZ_TNF_Input_1"],
    "No_Treatment_2" => ["No_Treatment_Input_2"],
    "TNF_Veh_2"      => ["TNF_Veh_Input_2"],
    "THZ_TNF_2"    => ["THZ_TNF_Input_2"],
 },

  is_paired_end => 0,

  perform_cutadapt => 1,
  adapter          => "AGATCGGAAGAGCACACGTCTGAACTCCAGTCAC",    #trueseq adapter
  cutadapt_option  => "-O 1",
  min_read_length  => 30,

  aligner       => "bowtie2",

  perform_cleanbam  => 1,
  minimum_maq       => 10,
  remove_chromosome => "M",
  keep_chromosome   => "chr",

  #peak
  peak_caller => "macs",

  perform_chipqc     => 1,
  perform_diffbind   => 1,
  perform_homer      => 1,

  annotation_genes => "EDN1,NANOG,POU5F1,JUN,EGFL7",
  annotation_genes_shift => 1000, #including possible TF range
  annotation_genes_add_chr => 1, #add chr to chromosome
  biomart_host      => "www.ensembl.org",
  biomart_dataset   => "hsapiens_gene_ensembl",
  biomart_symbolKey => "hgnc_symbol",
  perform_bamsnap => 1,

  perform_activeGene => 0,
  active_gene_genome => "hg38",
  crc_docker_command => "singularity exec -B /scratch -e /data/cqs/softwares/singularity/novartis.20210330.simg ",

  design_table       => {
    "Pol2" => {
      "No_Treatment_1" => {
        Condition => "No_Treatment",
        Replicate => "1"
      },
      "TNF_Veh_1" => {
        Condition => "TNF_Veh",
        Replicate => "1"
      },
      "THZ_TNF_1" => {
        Condition => "THZ_TNF",
        Replicate => "1"
      },
      "No_Treatment_2" => {
        Condition => "No_Treatment",
        Replicate => "2"
      },
      "TNF_Veh_2" => {
        Condition => "TNF_Veh",
        Replicate => "2"
      },
      "THZ_TNF_2" => {
        Condition => "THZ_TNF",
        Replicate => "2"
      },
      "Comparison" => [
         [ "TNF_Veh_vs_NoTreatment", "No_Treatment", "TNF_Veh" ],
         [ "THZ_TNF_vs_NoTreatment", "No_Treatment", "THZ_TNF" ],
      ],
      "MinOverlap" => {
        "No_Treatment" => 2,
        "TNF_Veh" => 2,
        "THZ_TNF" => 2,
      },
    },
  },

  perform_report => 1,
};

$def->{peak_caller} = "macs";
my $config = performChIPSeq_gencode_hg38($def, 0);
$config->{sequencetask}{target_dir} = $def->{target_dir} . "/sequencetask_macs";
performConfig($config);

$def->{peak_caller} = "macs2";
$config = performChIPSeq_gencode_hg38($def, 0);
$config->{sequencetask}{target_dir} = $def->{target_dir} . "/sequencetask_macs2";
performConfig($config);

1;
