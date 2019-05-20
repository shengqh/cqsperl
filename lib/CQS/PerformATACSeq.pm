#!/usr/bin/perl
package CQS::PerformATACSeq;

use strict;
use warnings;
use Pipeline::ATACSeq;
use Hash::Merge qw( merge );

require Exporter;
our @ISA = qw(Exporter);

our %EXPORT_TAGS = (
  'all' => [
    qw(
      performATACSeq_gencode_hg19
      performATACSeq_gencode_mm10
      performATACSeq_ucsc_hg19
      performATACSeq_ucsc_mm10)
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

    perform_cleanbam  => 1,
    remove_chromosome => "M",
    keep_chromosome   => "chr",

    peak_caller => "macs2",
    macs2_peak_type        => "broad",
  };
}

sub common_hg19_options {
  return {
    #clean option
    blacklist_file => "/scratch/cqs/shengq2/references/mappable_region/hg19/wgEncodeDacMapabilityConsensusExcludable.bed",

    #macs2
    macs2_genome      => "hs",
    enhancer_cpg_path => "/scratch/cqs/shengq2/references/ucsc/hg19_cpg_islands.bed",
    
    #homer
    homer_genome => "hg19"
  };
}

sub gencode_hg19_options {
  return merge(
    merge( common_options(), common_hg19_options() ),
    {
      #aligner database
      bowtie2_index => "/scratch/cqs/shengq2/references/gencode/GRCh37.p13/bowtie2_index_2.2.6/GRCh37.p13.genome",
      bowtie1_fasta => "/scratch/cqs/shengq2/references/gencode/GRCh37.p13/bowtie_index_1.1.2/GRCh37.p13.genome.fa",
      bowtie1_index => "/scratch/cqs/shengq2/references/gencode/GRCh37.p13/bowtie_index_1.1.2/GRCh37.p13.genome",
      bwa_fasta     => "/scratch/cqs/shengq2/references/gencode/GRCh37.p13/bwa_index_0.7.12/GRCh37.p13.genome.fa",

      #enhancer
      enhancer_genome_path => "/scratch/cqs/shengq2/references/gencode/GRCh37.p13/GRCh37.p13.chromosomes/",
    }
  );
}

sub ucsc_hg19_options {
  return merge(
    merge( common_options(), common_hg19_options() ),
    {
      #aligner database
      bowtie2_index => "/scratch/cqs/shengq2/references/ucsc/illumina/hg19/Sequence/Bowtie2Index/genome",
      bowtie1_fasta => "/scratch/cqs/shengq2/references/ucsc/illumina/hg19/Sequence/BowtieIndex/genome.fa",
      bowtie1_index => "/scratch/cqs/shengq2/references/ucsc/illumina/hg19/Sequence/BowtieIndex/genome",
      bwa_fasta     => "/scratch/cqs/shengq2/references/ucsc/illumina/hg19/Sequence/BWAIndex/genome.fa",

      #enhancer
      enhancer_genome_path => "/scratch/cqs/shengq2/references/ucsc/illumina/hg19/Sequence/Chromosomes/",
    }
  );
}

sub common_mm10_options() {
  return {
    #clean option
    blacklist_file => "/scratch/cqs/references/mappable_region/mm10/mm10.blacklist.bed",

    #macs2
    macs2_genome => "mm",

    #enhancer
    enhancer_cpg_path => "/scratch/cqs/references/ucsc/mm10_cpg_islands.bed",

    #chipqc
    chipqc_genome      => "mm10",
    chipqc_chromosomes => 'chr1,chr2,chr3,chr4,chr5,chr6,chr7,chr8,chr9,chr10,chr11,chr12,chr13,chr14,chr15,chr16,chr17,chr18,chr19',

    homer_genome => "mm10",
  };
}

sub gencode_mm10_options {
  return merge(
    merge( common_options(), common_mm10_options() ),
    {
      #aligner database
      bowtie2_index => "/scratch/cqs/shengq2/references/gencode/mm10/bowtie2_index_2.2.6/GRCm38.p5.genome",
      bowtie1_fasta => "/scratch/cqs/shengq2/references/gencode/mm10/bowtie_index_1.1.2/GRCm38.p5.genome.fa",
      bowtie1_index => "/scratch/cqs/shengq2/references/gencode/mm10/bowtie_index_1.1.2/GRCm38.p5.genome",
      bwa_fasta     => "/scratch/cqs/shengq2/references/gencode/mm10/bwa_index_0.7.17/GRCm38.p5.genome.fa",

      #enhancer
      enhancer_genome_path => "/scratch/cqs/shengq2/references/gencode/mm10/GRCm38.p5.chromosomes",
    }
  );
}

sub ucsc_mm10_options {
  return merge(
    merge( common_options(), common_mm10_options() ),
    {
      #aligner database
      bowtie2_index => "/scratch/cqs/references/illumina_iGenomes/Mus_musculus/UCSC/mm10/Sequence/Bowtie2Index/genome",
      bowtie1_fasta => "/scratch/cqs/references/illumina_iGenomes/Mus_musculus/UCSC/mm10/Sequence/BowtieIndex/genome.fa",
      bowtie1_index => "/scratch/cqs/references/illumina_iGenomes/Mus_musculus/UCSC/mm10/Sequence/BowtieIndex/genome",
      bwa_fasta     => "/scratch/cqs/references/illumina_iGenomes/Mus_musculus/UCSC/mm10/Sequence/BWAIndex/genome.fa",

      #enhancer
      enhancer_genome_path => "/scratch/cqs/references/illumina_iGenomes/Mus_musculus/UCSC/mm10/Sequence/Chromosomes/",
    }
  );
}

sub performATACSeq_gencode_hg19 {
  my ( $userdef, $perform ) = @_;
  my $def = merge( $userdef, gencode_hg19_options() );

  my $config = performATACSeq( $def, $perform );
  return $config;
}

sub performATACSeq_gencode_mm10 {
  my ( $userdef, $perform ) = @_;
  my $def = merge( $userdef, gencode_mm10_options() );

  my $config = performATACSeq( $def, $perform );
  return $config;
}

sub performATACSeq_ucsc_hg19 {
  my ( $userdef, $perform ) = @_;
  my $def = merge( $userdef, ucsc_hg19_options() );

  my $config = performATACSeq( $def, $perform );
  return $config;
}

sub performATACSeq_ucsc_mm10 {
  my ( $userdef, $perform ) = @_;
  my $def = merge( $userdef, ucsc_mm10_options() );

  my $config = performATACSeq( $def, $perform );
  return $config;
}

1;