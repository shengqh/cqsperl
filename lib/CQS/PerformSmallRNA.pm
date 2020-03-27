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
    qw(hg19_genome
      hg19_3utr
      hg38_genome
      hg38_3utr
      mm10_genome
      mm10_3utr
      rn6_genome
      performSmallRNA_hg19
      performSmallRNA_hg38
      performSmallRNA_mm10
      performSmallRNA_rn6
      supplement_genome)
  ]
);

our @EXPORT = ( @{ $EXPORT_TAGS{'all'} } );

our $VERSION = '5.0';

sub supplement_genome {
  return {
    version    => 5,
    constraint => "haswell",
    #cqstools   => "/home/shengq2/cqstools/cqstools.exe",
    docker_command => "singularity exec -e /scratch/cqs/softwares/singularity/cqs-smallRNA.simg ",

    #miRBase database
    bowtie1_miRBase_index => "/scratch/cqs_share/references/mirbase/v22/bowtie_index_1.2.3/mature.dna",

    bowtie_bacteria_index_list_file => "/scratch/cqs_share/references/refseq/bacteria/20200321_assembly_summary.txt.files.list",
    bowtie_viruses_index_list_file => "/scratch/cqs_share/references/refseq/viruses/20200326_assembly_summary.txt.files.list",

    #human microbime database
    bowtie1_bacteria_group1_index => "/scratch/cqs_share/references/smallrna/20170206_Group1SpeciesAll",
    bacteria_group1_species_map   => "/scratch/cqs_share/references/smallrna/20170206_Group1SpeciesAll.species.map",

    #human enviroment bacteria database
    bowtie1_bacteria_group2_index => "/scratch/cqs_share/references/smallrna/20160907_Group2SpeciesAll",
    bacteria_group2_species_map   => "/scratch/cqs_share/references/smallrna/20160907_Group2SpeciesAll.species.map",

    #fungus database
    bowtie1_fungus_group4_index => "/scratch/cqs_share/references/smallrna/20160225_Group4SpeciesAll",
    fungus_group4_species_map   => "/scratch/cqs_share/references/smallrna/20160225_Group4SpeciesAll.species.map",

    #virus database
    #bowtie1_virus_group6_index => "/scratch/cqs_share/references/smallrna/20190424_Group6SpeciesAll.species",
    #virus_group6_species_map   => "/scratch/cqs_share/references/smallrna/20190424_Group6SpeciesAll.species.map",
    bowtie1_virus_group6_index => "/scratch/cqs_share/references/refseq/viral/20200305_viral_genomes",
    virus_group6_species_map   => "/scratch/cqs_share/references/refseq/viral/20200305_viral_genomes.map",

    #algae database
    bowtie1_algae_group5_index => "/scratch/cqs_share/references/smallrna/20200214_AlgaeSpeciesAll.species",
    algae_group5_species_map   => "/scratch/cqs_share/references/smallrna/20200214_AlgaeSpeciesAll.species.map",

    #UCSC tRNA database
    bowtie1_tRNA_index => "/scratch/cqs_share/references/smallrna/GtRNAdb2.20161214.mature",
    trna_category_map  => "/scratch/cqs_share/references/smallrna/GtRNAdb2.20161214.category.map",
    trna_map           => "/scratch/cqs_share/references/smallrna/GtRNAdb2.20161214.map",

    #SILVA rRNA database
    bowtie1_rRNA_index => "/scratch/cqs_share/references/smallrna/SILVA_128.rmdup",
    rrna_category_map  => "/scratch/cqs_share/references/smallrna/SILVA_128.rmdup.category.map",

    blast_localdb => "/scratch/cqs_share/references/blastdb",

    #bowtie1_all_nonHost_index => "/scratch/cqs_share/references/smallrna/v4/allnonhost/bowtie_index_1.1.2/AllNonHost",
    #all_nonHost_map           => "/scratch/cqs_share/references/smallrna/v4/allnonhost/AllNonHost.map",
  };
}

sub hg19_genome {
  return merge(
    supplement_genome(),
    {
      #genome database
      mirbase_count_option => "-p hsa",
      miRNA_coordinate     => "/scratch/cqs_share/references/smallrna/hg19_miRBase22_GtRNAdb2_gencode19_ncbi.miRNA.bed",
      coordinate           => "/scratch/cqs_share/references/smallrna/hg19_miRBase22_GtRNAdb2_gencode19_ncbi.bed",
      coordinate_fasta     => "/scratch/cqs_share/references/smallrna/hg19_miRBase22_GtRNAdb2_gencode19_ncbi.bed.fa",
      bowtie1_index        => "/scratch/cqs_share/references/smallrna/hg19_miRBase22_GtRNAdb2_gencode19_ncbi",

      #gsnap_index_directory => "/scratch/cqs_share/references/human/hg19/gsnap_index_k14_2016-08-08/",
      #gsnap_index_name      => "GRCh37.p13.genome",
      #star_index_directory  => "/scratch/cqs_share/references/human/hg19/STAR_index_2.5.3a_gencodeV19_sjdb99",

      tDRmapper       => "/scratch/cqs/zhaos/vickers/otherPipeline/tDRmapper/Scripts/TdrMappingScripts.pl",
      tDRmapper_fasta => "/scratch/cqs/zhaos/vickers/otherPipeline/tDRmapper/hg19_mature_and_pre.fa",

      hasYRNA   => 1,
      hasSnRNA  => 1,
      hasSnoRNA => 1,
    }
  );
}

sub hg19_3utr {
  my $bowtie1 = hg19_genome()->{bowtie1_index};
  return {
    search_3utr   => 1,
    bowtie1_index => $bowtie1,
    fasta_file    => $bowtie1 . ".fasta",
    #utr3_db       => "/scratch/cqs/shengq2/references/3utr/20151218_ucsc_hg19_refgene_3utr.bed",
    #refgene_file  => "/scratch/cqs/shengq2/references/3utr/20151218_ucsc_hg19_refgene.tsv",
  };
}

sub hg38_genome {
  return merge(
    supplement_genome(),
    {
      #genome database
      mirbase_count_option => "-p hsa",
      miRNA_coordinate     => "/scratch/cqs_share/references/smallrna/hg38_miRBase22_GtRNAdb2_gencode33_ncbi.miRNA.bed",
      coordinate           => "/scratch/cqs_share/references/smallrna/hg38_miRBase22_GtRNAdb2_gencode33_ncbi.bed",
      coordinate_fasta     => "/scratch/cqs_share/references/smallrna/hg38_miRBase22_GtRNAdb2_gencode33_ncbi.bed.fa",
      bowtie1_index        => "/scratch/cqs_share/references/smallrna/hg38_miRBase22_GtRNAdb2_gencode33_ncbi",

      hasYRNA   => 1,
      hasSnRNA  => 1,
      hasSnoRNA => 1,
    }
  );
}

sub hg38_3utr {
  my $bowtie1 = hg38_genome()->{bowtie1_index};
  return {
    search_3utr   => 1,
    bowtie1_index => $bowtie1,
    fasta_file    => $bowtie1 . ".fasta",
    #utr3_db       => "/scratch/cqs/shengq2/references/3utr/20151218_ucsc_hg38_refgene_3utr.bed",
    #refgene_file  => "/scratch/cqs/shengq2/references/3utr/20151218_ucsc_hg38_refgene.tsv",
  };
}

sub mm10_genome {
  return merge(
    supplement_genome(),
    {

      #genome database
      mirbase_count_option => "-p mmu",
      miRNA_coordinate     => "/scratch/cqs_share/references/smallrna/mm10_miRBase22_GtRNAdb2_gencode24_ncbi.miRNA.bed",
      coordinate           => "/scratch/cqs_share/references/smallrna/mm10_miRBase22_GtRNAdb2_gencode24_ncbi.bed",
      coordinate_fasta     => "/scratch/cqs_share/references/smallrna/mm10_miRBase22_GtRNAdb2_gencode24_ncbi.bed.fa",
      bowtie1_index        => "/scratch/cqs_share/references/smallrna/mm10_miRBase22_GtRNAdb2_gencode24_ncbi",

      tDRmapper       => "/scratch/cqs/zhaos/vickers/otherPipeline/tDRmapper/Scripts/TdrMappingScripts.pl",
      tDRmapper_fasta => "/scratch/cqs/zhaos/vickers/otherPipeline/tDRmapper/mm10_mature_pre_for_tdrMapper.fa",

      hasSnRNA  => 1,
      hasSnoRNA => 1,
    }
  );
}

sub mm10_3utr {
  my $bowtie1 = mm10_genome()->{bowtie1_index};
  return {
    search_3utr   => 1,
    bowtie1_index => $bowtie1,
    fasta_file    => $bowtie1 . ".fasta",
    #utr3_db       => "/scratch/cqs/shengq2/references/3utr/20151218_ucsc_mm10_refgene_3utr.bed",
    #refgene_file  => "/scratch/cqs/shengq2/references/3utr/20151218_ucsc_mm10_refgene.tsv",
  };
}

sub rn6_genome {
  return merge(
    supplement_genome(),
    {

      #genome database
      mirbase_count_option => "-p rno",
      miRNA_coordinate     => "/scratch/cqs_share/references/smallrna/rn6_miRBase22_GtRNAdb2_ensembl99_ncbi.miRNA.bed",
      coordinate           => "/scratch/cqs_share/references/smallrna/rn6_miRBase22_GtRNAdb2_ensembl99_ncbi.bed",
      coordinate_fasta     => "/scratch/cqs_share/references/smallrna/rn6_miRBase22_GtRNAdb2_ensembl99_ncbi.bed.fa",
      bowtie1_index        => "/scratch/cqs_share/references/smallrna/rn6_miRBase22_GtRNAdb2_ensembl99_ncbi",
    }
  );
}

sub performSmallRNA_hg19 {
  my ( $userdef, $perform ) = @_;
  my $def = getSmallRNADefinition( $userdef, hg19_genome() );

  my $config = performSmallRNA( $def, $perform );
  return $config;
}

sub performSmallRNA_hg38 {
  my ( $userdef, $perform ) = @_;
  my $def = getSmallRNADefinition( $userdef, hg38_genome() );

  my $config = performSmallRNA( $def, $perform );
  return $config;
}

sub performSmallRNA_mm10 {
  my ( $userdef, $perform ) = @_;
  my $def = getSmallRNADefinition( $userdef, mm10_genome() );

  my $config = performSmallRNA( $def, $perform );
  return $config;
}

sub performSmallRNA_rn6 {
  my ( $userdef, $perform ) = @_;
  my $def = getSmallRNADefinition( $userdef, rn6_genome() );

  my $config = performSmallRNA( $def, $perform );
  return $config;
}

1;
