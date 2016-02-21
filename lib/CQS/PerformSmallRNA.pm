#!/usr/bin/perl
package CQS::PerformSmallRNA;

use strict;
use warnings;
use Pipeline::SmallRNA;
use Pipeline::SmallRNAUtils;
use Hash::Merge qw( merge );

require Exporter;
our @ISA = qw(Exporter);

our %EXPORT_TAGS = (
  'all' => [
    qw(hg19_genome hg19_3utr hg38_genome mm10_genome mm10_3utr rn5_genome cel235_genome cfa3_genome performSmallRNA_hg19 performSmallRNATask_hg19 performSmallRNA_hg20 performSmallRNATask_hg20 performSmallRNA_mm10 performSmallRNATask_mm10 performSmallRNA_rn5 performSmallRNATask_rn5
      performSmallRNA_cel235 performSmallRNATask_cel235 performSmallRNA_cfa3 performSmallRNATask_cfa3 performSmallRNA_bta8 performSmallRNATask_bta8 performSmallRNA_eca2 performSmallRNATask_eca2 performSmallRNA_ssc3 performSmallRNATask_ssc3 performSmallRNA_ocu2 performSmallRNATask_ocu2
      performSmallRNA_oar3 performSmallRNATask_oar3 supplement_genome)
  ]
);

our @EXPORT = ( @{ $EXPORT_TAGS{'all'} } );

our $VERSION = '0.01';

my $mirBase20 = "/data/cqs/shengq1/reference/miRBase20/bowtie_index_1.1.1/mature.dna";
my $mirBase21 = "/data/cqs/shengq1/reference/miRBase21/bowtie_index_1.1.1/mature.dna";

sub supplement_genome {
  return {
    bowtie1_miRBase_index         => $mirBase21,
    bowtie1_tRNA_index            => "/scratch/cqs/shengq1/references/ucsc/GtRNAdb2/bowtie_index_1.1.2/GtRNAdb2.20160216.rmdup",
    bowtie1_rRNAS_index           => "/scratch/cqs/zhaos/vickers/reference/rRna/SILVA_123_SSURef_Nr99_tax_silva",
    bowtie1_rRNAL_index           => "/scratch/cqs/zhaos/vickers/reference/rRna/SILVA_123_LSURef_tax_silva",
    bowtie1_bacteria_group1_index => "/scratch/cqs/zhaos/vickers/reference/bacteria/group1/bacteriaDatabaseGroup1",
    bacteria_group1_log           => "/scratch/cqs/zhaos/vickers/reference/bacteria/group1/20150902.log",
    bowtie1_bacteria_group2_index => "/scratch/cqs/zhaos/vickers/reference/bacteria/group2/bowtie_index_1.1.2/bacteriaDatabaseGroup2",
    bacteria_group2_log           => "/scratch/cqs/zhaos/vickers/reference/bacteria/group2/20160219.log",
    bowtie1_fungus_group4_index   => "/scratch/cqs/zhaos/vickers/reference/bacteria/group4/bowtie_index_1.1.2/group4",
    fungus_group4_log             => "/scratch/cqs/zhaos/vickers/reference/bacteria/group4/20160210.log",
  };
}

#for miRBase analysis, we use the most recent version (corresponding to hg38) since the coordinates are not used in analysis.
sub hg19_genome {
  return merge(
    supplement_genome(),
    {
      #genome database
      mirbase_count_option  => "-p hsa",
      coordinate            => "/scratch/cqs/shengq1/references/smallrna/hg19_miRBase21_GtRNAdb2_ensembl75.bed",
      coordinate_fasta      => "/scratch/cqs/shengq1/references/smallrna/hg19_miRBase21_GtRNAdb2_ensembl75.bed.fa",
      bowtie1_index         => "/scratch/cqs/shengq1/references/broad/hg19/bowtie_index_1.1.2/hg19_16569_MT",
      gsnap_index_directory => "/scratch/cqs/shengq1/references/hg19_16569_MT/gsnap_index_k14_2015-06-23/",
      gsnap_index_name      => "hg19_16569_MT",
      star_index_directory  => "/scratch/cqs/shengq1/references/hg19_16569_MT/STAR_index_v37.75_2.4.2a_sjdb49"
    }
  );
}

sub hg19_3utr {
  return {
    search_3utr   => 1,
    bowtie1_index => hg19_genome()->{bowtie1_index},
    fasta_file    => "/scratch/cqs/shengq1/references/broad/hg19/bowtie_index_1.1.2/hg19_16569_MT.fa",
    utr3_db       => "/scratch/cqs/shengq1/references/3utr/20151218_ucsc_hg19_refgene_3utr.bed",
    refgene_file  => "/scratch/cqs/shengq1/references/3utr/20151218_ucsc_hg19_refgene.tsv",
  };
}

sub hg38_genome {
  return merge(
    supplement_genome(),
    {

      #genome database
      mirbase_count_option  => "-p hsa",
      coordinate            => "/scratch/cqs/shengq1/references/smallrna/hg38_miRBase21_GtRNAdb2_ensembl83.bed",
      coordinate_fasta      => "/scratch/cqs/shengq1/references/smallrna/hg38_miRBase21_GtRNAdb2_ensembl83.bed.fa",
      bowtie1_index         => "/scratch/cqs/shengq1/references/broad/hg38/bowtie_index_1.1.2/Homo_sapiens_assembly38",
      gsnap_index_directory => "/scratch/cqs/shengq1/references/hg38_MT/gsnap_index_k14_2015-06-23/",
      gsnap_index_name      => "hg38_MT",
      star_index_directory  => "/scratch/cqs/shengq1/references/hg38_MT/STAR_index_v38.81_2.4.2a_sjdb49"
    }
  );
}

sub hg38_3utr {
  return {
    search_3utr   => 1,
    bowtie1_index => hg38_genome()->{bowtie1_index},
    fasta_file    => "/scratch/cqs/shengq1/references/broad/hg38/bowtie_index_1.1.2/Homo_sapiens_assembly38.fa",
    utr3_db       => "/scratch/cqs/shengq1/references/3utr/20151218_ucsc_hg38_refgene_3utr.bed",
    refgene_file  => "/scratch/cqs/shengq1/references/3utr/20151218_ucsc_hg38_refgene.tsv",
  };
}

sub mm10_genome {
  return merge(
    supplement_genome(),
    {

      #genome database
      mirbase_count_option  => "-p mmu",
      coordinate            => "/scratch/cqs/shengq1/references/smallrna/mm10_miRBase21_ucsc-tRNA_ensembl78.bed",
      coordinate_fasta      => "/scratch/cqs/shengq1/references/smallrna/mm10_miRBase21_ucsc-tRNA_ensembl78.bed.fa",
      bowtie1_index         => "/scratch/cqs/shengq1/references/mm10_sorted_M/bowtie_index_1.1.2/mm10",
      gsnap_index_directory => "/scratch/cqs/shengq1/references/mm10_sorted_M/gsnap_index_k14_2015-06-23/",
      gsnap_index_name      => "mm10",
      star_index_directory  => "/scratch/cqs/shengq1/references/mm10_sorted_M/STAR_index_v38.78_2.5.0b_sjdb49"
    }
  );
}

sub mm10_3utr {
  return {
    search_3utr   => 1,
    bowtie1_index => mm10_genome()->{bowtie1_index},
    fasta_file    => "/scratch/cqs/shengq1/references/mm10/mm10.fa",
    utr3_db       => "/scratch/cqs/shengq1/references/3utr/20151218_ucsc_mm10_refgene_3utr.bed",
    refgene_file  => "/scratch/cqs/shengq1/references/3utr/20151218_ucsc_mm10_refgene.tsv",
  };
}

sub rn5_genome {
  return merge(
    supplement_genome(),
    {

      #genome database
      mirbase_count_option  => "-p rno",
      coordinate            => "/scratch/cqs/shengq1/references/smallrna/rn5_miRBase21_ucsc-tRNA_ensembl78.bed",
      coordinate_fasta      => "/scratch/cqs/shengq1/references/smallrna/rn5_miRBase21_ucsc-tRNA_ensembl78.bed.fa",
      bowtie1_index         => "/scratch/cqs/shengq1/references/rn5/bowtie_index_1.1.2/rn5",
      gsnap_index_directory => "/scratch/cqs/shengq1/references/rn5/gsnap_index_k14_2015-06-23/",
      gsnap_index_name      => "rn5",
      star_index_directory  => "/scratch/cqs/shengq1/references/rn5/STAR_index_v79_2.4.2a_sjdb49"
    }
  );
}

sub cel235_genome {
  return merge(
    supplement_genome(),
    {

      #genome database
      mirbase_count_option  => "-p cel",
      coordinate            => "/scratch/cqs/shengq1/references/smallrna/cel235_miRBase21_ensembl78.bed",
      coordinate_fasta      => "/scratch/cqs/shengq1/references/smallrna/cel235_miRBase21_ensembl78.bed.fa",
      bowtie1_index         => "/scratch/cqs/zhangp2/reference/wormbase/bowtie_index_1.1.0/Caenorhabditis_elegans.WBcel235.dna.toplevel",
      gsnap_index_directory => "/scratch/cqs/shengq1/references/cel235/gsnap_index_k14_2015-06-23/",
      gsnap_index_name      => "cel235",
      star_index_directory  => "/scratch/cqs/shengq1/references/cel235/STAR_index_v78_2.4.2a_sjdb49"
    }
  );
}

sub cfa3_genome {
  return merge(
    supplement_genome(),
    {
      #genome database
      mirbase_count_option => "-p cfa",
      coordinate           => "/scratch/cqs/zhaos/vickers/reference/Canis_lupus_familiaris/cfa3_miRBase21_ucsc-tRNA_ensembl83.bed",
      coordinate_fasta     => "/scratch/cqs/zhaos/vickers/reference/Canis_lupus_familiaris/cfa3_miRBase21_ucsc-tRNA_ensembl83.bed.fa",

      bowtie1_index         => "/scratch/cqs/zhaos/vickers/reference/Canis_lupus_familiaris/bowtie_index_1.1.2/canFam3",
      gsnap_index_directory => "/scratch/cqs/zhaos/vickers/reference/Canis_lupus_familiaris/gsnap_index_k14_2015-06-23",
      gsnap_index_name      => "canFam3",

      #      star_index_directory  => "/scratch/cqs/shengq1/references/cel235/STAR_index_v78_2.4.2a_sjdb49"
    }
  );
}

sub bta8_genome {
  return merge(
    supplement_genome(),
    {
      #genome database
      mirbase_count_option => "-p bta",
      coordinate           => "/scratch/cqs/zhaos/vickers/reference/Bos_taurus/bta31_miRBase21_ucsc-tRNA_ensembl83.bed",
      coordinate_fasta     => "/scratch/cqs/zhaos/vickers/reference/Bos_taurus/bta31_miRBase21_ucsc-tRNA_ensembl83.bed.fa",

      bowtie1_index         => "/scratch/cqs/zhaos/vickers/reference/Bos_taurus/bowtie_index_1.1.2/bosTau8",
      gsnap_index_directory => "/scratch/cqs/zhaos/vickers/reference/Bos_taurus/gsnap_index_k14_2015-06-23",
      gsnap_index_name      => "bosTau8",

      #      star_index_directory  => "/scratch/cqs/shengq1/references/cel235/STAR_index_v78_2.4.2a_sjdb49"
    }
  );
}

sub eca2_genome {
  return merge(
    supplement_genome(),
    {
      #genome database
      mirbase_count_option => "-p eca",
      coordinate           => "/scratch/cqs/zhaos/vickers/reference/Equus_caballus/eca2_miRBase21_ucsc-tRNA_ensembl83.bed",
      coordinate_fasta     => "/scratch/cqs/zhaos/vickers/reference/Equus_caballus/eca2_miRBase21_ucsc-tRNA_ensembl83.bed.fa",

      bowtie1_index         => "/scratch/cqs/zhaos/vickers/reference/Equus_caballus/bowtie_index_1.1.2/equCab2",
      gsnap_index_directory => "/scratch/cqs/zhaos/vickers/reference/Equus_caballus/gsnap_index_k14_2015-06-23",
      gsnap_index_name      => "equCab2",

      #      star_index_directory  => "/scratch/cqs/shengq1/references/cel235/STAR_index_v78_2.4.2a_sjdb49"
    }
  );
}

sub ssc3_genome {
  return merge(
    supplement_genome(),
    {
      #genome database
      mirbase_count_option => "-p ssc",
      coordinate           => "/scratch/cqs/zhaos/vickers/reference/Sus_scrofa/ssc3_miRBase21_ucsc-tRNA_ensembl83.bed",
      coordinate_fasta     => "/scratch/cqs/zhaos/vickers/reference/Sus_scrofa/ssc3_miRBase21_ucsc-tRNA_ensembl83.bed.fa",

      bowtie1_index => "/scratch/cqs/zhaos/vickers/reference/Sus_scrofa/bowtie_index_1.1.2/susScr3",

      #      gsnap_index_directory => "/scratch/cqs/zhaos/vickers/reference/Equus_caballus/gsnap_index_k14_2015-06-23",
      #      gsnap_index_name      => "equCab2",

      #      star_index_directory  => "/scratch/cqs/shengq1/references/cel235/STAR_index_v78_2.4.2a_sjdb49"
    }
  );
}

sub ocu2_genome {
  return merge(
    supplement_genome(),
    {
      #genome database
      mirbase_count_option => "-p ocu",
      coordinate           => "/gpfs21/scratch/cqs/zhaos/vickers/reference/Oryctolagus_cuniculus/ocu2_miRBase21_ucsc-tRNA_ensembl83.bed",
      coordinate_fasta     => "/gpfs21/scratch/cqs/zhaos/vickers/reference/Oryctolagus_cuniculus/ocu2_miRBase21_ucsc-tRNA_ensembl83.bed.fa",

      bowtie1_index => "/gpfs21/scratch/cqs/zhaos/vickers/reference/Oryctolagus_cuniculus/bowtie_index_1.1.2/oryCun2",

      #      gsnap_index_directory => "/scratch/cqs/zhaos/vickers/reference/Equus_caballus/gsnap_index_k14_2015-06-23",
      #      gsnap_index_name      => "equCab2",

      #      star_index_directory  => "/scratch/cqs/shengq1/references/cel235/STAR_index_v78_2.4.2a_sjdb49"
    }
  );
}

sub oar3_genome {
  return merge(
    supplement_genome(),
    {
      #genome database
      mirbase_count_option => "-p oar",
      coordinate           => "/scratch/cqs/zhaos/vickers/reference/Ovis_aries/oar3_miRBase21_ucsc-tRNA_ensembl83.bed",
      coordinate_fasta     => "/scratch/cqs/zhaos/vickers/reference/Ovis_aries/oar3_miRBase21_ucsc-tRNA_ensembl83.bed.fa",

      bowtie1_index => "/scratch/cqs/zhaos/vickers/reference/Ovis_aries/bowtie_index_1.1.2/oviAri3",

      #      gsnap_index_directory => "/scratch/cqs/zhaos/vickers/reference/Equus_caballus/gsnap_index_k14_2015-06-23",
      #      gsnap_index_name      => "equCab2",

      #      star_index_directory  => "/scratch/cqs/shengq1/references/cel235/STAR_index_v78_2.4.2a_sjdb49"
    }
  );
}

sub performSmallRNA_hg19 {
  my ( $userdef, $perform ) = @_;
  my $def = getSmallRNADefinition( $userdef, hg19_genome() );

  my $config = performSmallRNA( $def, $perform );
  return $config;
}

sub performSmallRNATask_hg19 {
  my ( $userdef, $task ) = @_;
  my $def = getSmallRNADefinition( $userdef, hg19_genome() );

  performSmallRNATask( $def, $task );
}

sub performSmallRNA_hg20 {
  my ( $userdef, $perform ) = @_;
  my $def = getSmallRNADefinition( $userdef, hg20_genome() );

  my $config = performSmallRNA( $def, $perform );
  return $config;
}

sub performSmallRNATask_hg20 {
  my ( $userdef, $task ) = @_;
  my $def = getSmallRNADefinition( $userdef, hg20_genome() );

  performSmallRNATask( $def, $task );
}

sub performSmallRNA_mm10 {
  my ( $userdef, $perform ) = @_;
  my $def = getSmallRNADefinition( $userdef, mm10_genome() );

  my $config = performSmallRNA( $def, $perform );
  return $config;
}

sub performSmallRNATask_mm10 {
  my ( $userdef, $task ) = @_;
  my $def = getSmallRNADefinition( $userdef, mm10_genome() );

  performSmallRNATask( $def, $task );
}

sub performSmallRNA_rn5 {
  my ( $userdef, $perform ) = @_;
  my $def = getSmallRNADefinition( $userdef, rn5_genome() );

  my $config = performSmallRNA( $def, $perform );
  return $config;
}

sub performSmallRNATask_rn5 {
  my ( $userdef, $task ) = @_;
  my $def = getSmallRNADefinition( $userdef, rn5_genome() );

  performSmallRNATask( $def, $task );
}

sub performSmallRNA_cel235 {
  my ( $userdef, $perform ) = @_;
  my $def = getSmallRNADefinition( $userdef, cel235_genome() );

  my $config = performSmallRNA( $def, $perform );
  return $config;
}

sub performSmallRNATask_cel235 {
  my ( $userdef, $task ) = @_;
  my $def = getSmallRNADefinition( $userdef, cel235_genome() );

  performSmallRNATask( $def, $task );
}

sub performSmallRNA_cfa3 {
  my ( $userdef, $perform ) = @_;
  my $def = getSmallRNADefinition( $userdef, cfa3_genome() );

  my $config = performSmallRNA( $def, $perform );
  return $config;
}

sub performSmallRNATask_cfa3 {
  my ( $userdef, $task ) = @_;
  my $def = getSmallRNADefinition( $userdef, cfa3_genome() );

  performSmallRNATask( $def, $task );
}

sub performSmallRNA_bta8 {
  my ( $userdef, $perform ) = @_;
  my $def = getSmallRNADefinition( $userdef, bta8_genome() );

  my $config = performSmallRNA( $def, $perform );
  return $config;
}

sub performSmallRNATask_bta8 {
  my ( $userdef, $task ) = @_;
  my $def = getSmallRNADefinition( $userdef, bta8_genome() );

  performSmallRNATask( $def, $task );
}

sub performSmallRNA_eca2 {
  my ( $userdef, $perform ) = @_;
  my $def = getSmallRNADefinition( $userdef, eca2_genome() );

  my $config = performSmallRNA( $def, $perform );
  return $config;
}

sub performSmallRNATask_eca2 {
  my ( $userdef, $task ) = @_;
  my $def = getSmallRNADefinition( $userdef, eca2_genome() );

  performSmallRNATask( $def, $task );
}

sub performSmallRNA_ssc3 {
  my ( $userdef, $perform ) = @_;
  my $def = getSmallRNADefinition( $userdef, ssc3_genome() );

  my $config = performSmallRNA( $def, $perform );
  return $config;
}

sub performSmallRNATask_ssc3 {
  my ( $userdef, $task ) = @_;
  my $def = getSmallRNADefinition( $userdef, ssc3_genome() );

  performSmallRNATask( $def, $task );
}

sub performSmallRNA_ocu2 {
  my ( $userdef, $perform ) = @_;
  my $def = getSmallRNADefinition( $userdef, ocu2_genome() );

  my $config = performSmallRNA( $def, $perform );
  return $config;
}

sub performSmallRNATask_ocu2 {
  my ( $userdef, $task ) = @_;
  my $def = getSmallRNADefinition( $userdef, ocu2_genome() );

  performSmallRNATask( $def, $task );
}

sub performSmallRNA_oar3 {
  my ( $userdef, $perform ) = @_;
  my $def = getSmallRNADefinition( $userdef, oar3_genome() );

  my $config = performSmallRNA( $def, $perform );
  return $config;
}

sub performSmallRNATask_oar3 {
  my ( $userdef, $task ) = @_;
  my $def = getSmallRNADefinition( $userdef, oar3_genome() );

  performSmallRNATask( $def, $task );
}

1;
