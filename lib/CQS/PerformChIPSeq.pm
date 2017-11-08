#!/usr/bin/perl
package CQS::PerformChIPSeq;

use strict;
use warnings;
use Pipeline::ChIPSeq;
use Hash::Merge qw( merge );

require Exporter;
our @ISA = qw(Exporter);

our %EXPORT_TAGS = (
  'all' => [
    qw(hg19_genome hg19_3utr hg38_genome mm10_genome mm10_3utr rn5_genome cel235_genome cfa3_genome performSmallRNA_hg19 performSmallRNATask_hg19 performSmallRNA_hg38 performSmallRNATask_hg38 performSmallRNA_mm10 performSmallRNATask_mm10 performSmallRNA_rn5 performSmallRNATask_rn5
      performSmallRNA_cel235 performSmallRNATask_cel235 performSmallRNA_cfa3 performSmallRNATask_cfa3 performSmallRNA_bta8 performSmallRNATask_bta8 performSmallRNA_eca2 performSmallRNATask_eca2 performSmallRNA_ssc3 performSmallRNATask_ssc3 performSmallRNA_ocu2 performSmallRNATask_ocu2
      performSmallRNA_oar3 performSmallRNATask_oar3 performSmallRNA_gga4 performSmallRNATask_gga4 performSmallRNA_fca6 performSmallRNATask_fca6 performSmallRNA_rheMac8 performSmallRNATask_rheMac8 performSmallRNA_chir1 performSmallRNATask_chir1 supplement_genome)
  ]
);

our @EXPORT = ( @{ $EXPORT_TAGS{'all'} } );

our $VERSION = '0.01';

sub common_options {
  return {
    version    => 1,
    constraint => "haswell",

    cqstools   => "/home/shengq2/cqstools/cqstools.exe",
    picard_jar => "/scratch/cqs/shengq2/local/bin/picard/picard.jar",

    perform_cutadapt => 0,

    aligner          => "bowtie2",
    perform_cleanbam => 1,

    peak_caller => "macs",

    perform_enhancer   => 0,
    enhancer_folder    => "/scratch/cqs/shengq2/local/bin/linlabpipeline",
    enhancer_gsea_path => "/scratch/cqs/shengq2/tools/gsea/gsea2-2.2.3.jar",
    enhancer_gmx_path  => "/scratch/cqs/shengq2/tools/gsea/c2.all.v5.2.symbols.gmt",

    rose_folder => "/scratch/cqs/shengq2/local/bin/bradnerlab",

    perform_chipqc => 1,
  };
}

sub hg19_options {
  return merge(
    common_options(),
    {
      #aligner database
      bowtie2_index => "/scratch/cqs/shengq2/references/ucsc/illumina/hg19/Sequence/Bowtie2Index/genome",
      bowtie1_fasta => "/scratch/cqs/shengq2/references/ucsc/illumina/hg19/Sequence/BowtieIndex/genome.fa",
      bowtie1_index => "/scratch/cqs/shengq2/references/ucsc/illumina/hg19/Sequence/BowtieIndex/genome",
      bwa_fasta     => "/scratch/cqs/shengq2/references/ucsc/illumina/hg19/Sequence/BWAIndex/genome.fa",

      #clean option
      remove_chromosome => "M",
      keep_chromosome   => "chr",
      blacklist_file    => "/scratch/cqs/shengq2/references/mappable_region/hg19/wgEncodeDacMapabilityConsensusExcludable.bed",

      #macs2
      macs2_genome => "hs",

      #enhancer
      enhancer_genome_path => "/scratch/cqs/shengq2/references/ucsc/hg19/",
      enhancer_cpg_path    => "/scratch/cqs/shengq2/references/ucsc/hg19_cpg_islands.bed",

      #chipqc
      chipqc_genome      => "hg19",
      chipqc_chromosomes => 'chr1,chr2,chr3,chr4,chr5,chr6,chr7,chr8,chr9,chr10,chr11,chr12,chr13,chr14,chr15,chr16,chr17,chr18,chr19,chr20,chr21,chr22',
    }
  );
}

sub performChIPSeq_hg19 {
  my ( $userdef, $perform ) = @_;
  my $def = merge( $userdef, hg19_options() );

  my $config = performChIPSeq( $def, $perform );
  return $config;
}

1;
