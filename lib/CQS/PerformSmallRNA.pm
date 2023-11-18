#!/usr/bin/perl
package CQS::PerformSmallRNA;

use strict;
use warnings;
use CQS::Global;
use CQS::ConfigUtils;
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
      performSmallRNA_hg38_v2022
      performSmallRNA_mm10
      performSmallRNA_rn6
      hg38_mm10_genome
      performSmallRNA_hg38_mm10
      supplement_genome)
  ]
);

our @EXPORT = ( @{ $EXPORT_TAGS{'all'} } );

our $VERSION = '5.0';

sub supplement_genome {
  return merge_hash_right_precedent(global_options(), {
    version    => 5,
    #constraint => "haswell",
    #cqstools   => "/home/shengq2/cqstools/cqstools.exe",
    docker_command => singularity_prefix() . " /data/cqs/softwares/singularity/cqs_smallrnaseq.20231105.sif ",

    #miRBase database
    bowtie1_miRBase_index => "/data/cqs/references/smallrna/mature.dna",

    #bowtie_bacteria_index_list_file => "/scratch/cqs_share/references/refseq/bacteria/20200321_assembly_summary.txt.files.list",
    #bowtie_viruses_index_list_file => "/scratch/cqs_share/references/refseq/viruses/20200326_assembly_summary.txt.files.list",

    search_refseq_bacteria => 1,
    #spcount => "python3 /data/cqs/softwares/spcount/src/debug.py",
    krona_taxonomy_folder => '/data/cqs/references/spcount/',
    refseq_bacteria_species => "/data/cqs/references/spcount/20220406_bacteria.taxonomy.txt",
    refseq_assembly_summary => '/data/cqs/references/spcount/20220406_assembly_summary_refseq.txt',
    refseq_taxonomy => '/data/cqs/references/spcount/20220406_taxonomy.txt',
    refseq_bacteria_bowtie_index => {
      'bacteria.001' => [ '/data/cqs/references/spcount/fasta/20220406_bacteria.001' ],
      'bacteria.002' => [ '/data/cqs/references/spcount/fasta/20220406_bacteria.002' ],
      'bacteria.003' => [ '/data/cqs/references/spcount/fasta/20220406_bacteria.003' ],
      'bacteria.004' => [ '/data/cqs/references/spcount/fasta/20220406_bacteria.004' ],
      'bacteria.005' => [ '/data/cqs/references/spcount/fasta/20220406_bacteria.005' ],
      'bacteria.006' => [ '/data/cqs/references/spcount/fasta/20220406_bacteria.006' ],
      'bacteria.007' => [ '/data/cqs/references/spcount/fasta/20220406_bacteria.007' ],
      'bacteria.008' => [ '/data/cqs/references/spcount/fasta/20220406_bacteria.008' ],
      'bacteria.009' => [ '/data/cqs/references/spcount/fasta/20220406_bacteria.009' ],
      'bacteria.010' => [ '/data/cqs/references/spcount/fasta/20220406_bacteria.010' ],
      'bacteria.011' => [ '/data/cqs/references/spcount/fasta/20220406_bacteria.011' ],
      'bacteria.012' => [ '/data/cqs/references/spcount/fasta/20220406_bacteria.012' ],
      'bacteria.013' => [ '/data/cqs/references/spcount/fasta/20220406_bacteria.013' ],
      'bacteria.014' => [ '/data/cqs/references/spcount/fasta/20220406_bacteria.014' ],
      'bacteria.015' => [ '/data/cqs/references/spcount/fasta/20220406_bacteria.015' ],
      'bacteria.016' => [ '/data/cqs/references/spcount/fasta/20220406_bacteria.016' ],
      'bacteria.017' => [ '/data/cqs/references/spcount/fasta/20220406_bacteria.017' ],
      'bacteria.018' => [ '/data/cqs/references/spcount/fasta/20220406_bacteria.018' ],
      'bacteria.019' => [ '/data/cqs/references/spcount/fasta/20220406_bacteria.019' ],
      'bacteria.020' => [ '/data/cqs/references/spcount/fasta/20220406_bacteria.020' ],
      'bacteria.021' => [ '/data/cqs/references/spcount/fasta/20220406_bacteria.021' ],
      'bacteria.022' => [ '/data/cqs/references/spcount/fasta/20220406_bacteria.022' ],
      'bacteria.023' => [ '/data/cqs/references/spcount/fasta/20220406_bacteria.023' ],
      'bacteria.024' => [ '/data/cqs/references/spcount/fasta/20220406_bacteria.024' ],
      'bacteria.025' => [ '/data/cqs/references/spcount/fasta/20220406_bacteria.025' ],
      'bacteria.026' => [ '/data/cqs/references/spcount/fasta/20220406_bacteria.026' ],
      'bacteria.027' => [ '/data/cqs/references/spcount/fasta/20220406_bacteria.027' ],
      'bacteria.028' => [ '/data/cqs/references/spcount/fasta/20220406_bacteria.028' ],
      'bacteria.029' => [ '/data/cqs/references/spcount/fasta/20220406_bacteria.029' ],
      'bacteria.030' => [ '/data/cqs/references/spcount/fasta/20220406_bacteria.030' ],
    },

    #human microbime database
    bowtie1_bacteria_group1_index => "/data/cqs/references/smallrna/20170206_Group1SpeciesAll",
    bacteria_group1_species_map   => "/data/cqs/references/smallrna/20170206_Group1SpeciesAll.species.map",

    #human enviroment bacteria database
    bowtie1_bacteria_group2_index => "/data/cqs/references/smallrna/20160907_Group2SpeciesAll",
    bacteria_group2_species_map   => "/data/cqs/references/smallrna/20160907_Group2SpeciesAll.species.map",

    #fungus database
    bowtie1_fungus_group4_index => "/data/cqs/references/smallrna/20160225_Group4SpeciesAll",
    fungus_group4_species_map   => "/data/cqs/references/smallrna/20160225_Group4SpeciesAll.species.map",

    #virus database
    #bowtie1_virus_group6_index => "/data/cqs/references/smallrna/20190424_Group6SpeciesAll.species",
    #virus_group6_species_map   => "/data/cqs/references/smallrna/20190424_Group6SpeciesAll.species.map",
    bowtie1_virus_group6_index => "/data/cqs/references/smallrna/20200305_viral_genomes",
    virus_group6_species_map   => "/data/cqs/references/smallrna/20200305_viral_genomes.map",

    #algae database
    bowtie1_algae_group5_index => "/data/cqs/references/smallrna/20200214_AlgaeSpeciesAll.species",
    algae_group5_species_map   => "/data/cqs/references/smallrna/20200214_AlgaeSpeciesAll.species.map",

    #UCSC tRNA database
    bowtie1_tRNA_index => "/data/cqs/references/smallrna/GtRNAdb2.20161214.mature",
    trna_category_map  => "/data/cqs/references/smallrna/GtRNAdb2.20161214.category.map",
    #trna_map was used in perform_nonhost_tRNA_coverage, somehow I lost this file.
    #trna_map           => "/data/cqs/references/smallrna/GtRNAdb2.20161214.map",

    #SILVA rRNA database
    bowtie1_rRNA_index => "/data/cqs/references/smallrna/SILVA_128.rmdup",
    rrna_category_map  => "/data/cqs/references/smallrna/SILVA_128.rmdup.category.map",

    blast_localdb => "/data/cqs/references/blastdb",

    hasERV => 0,

    customed_db => {
      "Bug" => {
        bowtie1_index => "/data/cqs/references/smallrna/20200415_BugsAll.species",
        species_map => "/data/cqs/references/smallrna/20200415_BugsAll.species.map",
      },
      "Rice" => {
        bowtie1_index => "/data/cqs/references/smallrna/rice/bowtie_index_1.3.1/Oryza_sativa.IRGSP-1.0.dna.toplevel",
        species_map => "/data/cqs/references/smallrna/rice/Oryza_sativa.IRGSP-1.0.dna.toplevel.species.map",
        gtf => "/data/cqs/references/smallrna/rice/Oryza_sativa.IRGSP-1.0.56.gtf",
      }
    },
  });
}

sub supplement_genome_v2022 {
  return merge_hash_right_precedent(supplement_genome(), {
    version    => 2022,
    #miRBase database
    bowtie1_miRBase_index => "/data/cqs/references/smallrna/v202211/miRBase.v22.1/bowtie_index_1.3.1/mature.dna",

    #UCSC tRNA database
    bowtie1_tRNA_index => "/data/cqs/references/smallrna/v202211/GtRNAdb.v19/bowtie_index_1.3.1/GtRNAdb.v19.mature",
    trna_category_map  => "/data/cqs/references/smallrna/v202211/GtRNAdb.v19/GtRNAdb.v19.category.map",

    #SILVA rRNA database
    bowtie1_rRNA_index => "/data/cqs/references/smallrna/v202211/SILVA_138.1/bowtie_index_1.3.1/SILVA_138.1.rmdup",
    rrna_category_map  => "/data/cqs/references/smallrna/v202211/SILVA_138.1/SILVA_138.1.category.map",
  });
}

sub hg19_genome {
  return merge_hash_right_precedent(
    supplement_genome(),
    {
      #genome database
      mirbase_count_option => "-p hsa",
      miRNA_coordinate     => "/data/cqs/references/smallrna/hg19_miRBase22_GtRNAdb2_gencode19_ncbi.miRNA.bed",
      coordinate           => "/data/cqs/references/smallrna/hg19_miRBase22_GtRNAdb2_gencode19_ncbi.bed",
      coordinate_fasta     => "/data/cqs/references/smallrna/hg19_miRBase22_GtRNAdb2_gencode19_ncbi.bed.fa",
      bowtie1_index        => "/data/cqs/references/smallrna/hg19_miRBase22_GtRNAdb2_gencode19_ncbi",

      # tDRmapper       => "/scratch/cqs/zhaos/vickers/otherPipeline/tDRmapper/Scripts/TdrMappingScripts.pl",
      # tDRmapper_fasta => "/scratch/cqs/zhaos/vickers/otherPipeline/tDRmapper/hg19_mature_and_pre.fa",

      hasYRNA   => 1,
      hasSnRNA  => 1,
      hasSnoRNA => 1,

      software_version => {
        host => "GENCODE GRCh37.p13",
      }
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
  return merge_hash_right_precedent(
    supplement_genome(),
    {
      #genome database
      mirbase_count_option => "-p hsa",
      miRNA_coordinate     => "/data/cqs/references/smallrna/hg38_miRBase22_GtRNAdb2_gencode33_ncbi.miRNA.bed",
      coordinate           => "/data/cqs/references/smallrna/hg38_miRBase22_GtRNAdb2_gencode33_ncbi.bed",
      coordinate_fasta     => "/data/cqs/references/smallrna/hg38_miRBase22_GtRNAdb2_gencode33_ncbi.bed.fa",
      bowtie1_index        => "/data/cqs/references/smallrna/hg38_miRBase22_GtRNAdb2_gencode33_ncbi",

      hasYRNA   => 1,
      hasSnRNA  => 1,
      hasSnoRNA => 1,

      software_version => {
        host => "GENCODE GRCh38.p13",
      }
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

sub hg38_genome_v2022 {
  return merge_hash_right_precedent(
    supplement_genome_v2022(),
    {
      #genome database
      mirbase_count_option => "-p hsa",
      miRNA_coordinate     => "/data/cqs/references/smallrna/v202211/hg38/hg38_miRBase22_GtRNAdb19_gencode42.miRNA.bed",
      coordinate           => "/data/cqs/references/smallrna/v202211/hg38/hg38_miRBase22_GtRNAdb19_gencode42_HERVd.bed",
      coordinate_fasta     => "/data/cqs/references/smallrna/v202211/hg38/hg38_miRBase22_GtRNAdb19_gencode42_HERVd.bed.fa",
      bowtie1_index        => "/data/cqs/references/smallrna/v202211/hg38/bowtie_index_1.3.1/hg38_miRBase22_GtRNAdb19_gencode42",

      hasYRNA   => 1,
      hasSnRNA  => 1,
      hasSnoRNA => 1,
      hasERV => 1,

      software_version => {
        host => "GENCODE GRCh38.p13",
      }
    }
  );
}

sub mm10_genome {
  return merge_hash_right_precedent(
    supplement_genome(),
    {

      #genome database
      mirbase_count_option => "-p mmu",
      miRNA_coordinate     => "/data/cqs/references/smallrna/mm10_miRBase22_GtRNAdb2_gencode24_ncbi.miRNA.bed",
      coordinate           => "/data/cqs/references/smallrna/mm10_miRBase22_GtRNAdb2_gencode24_ncbi.bed",
      coordinate_fasta     => "/data/cqs/references/smallrna/mm10_miRBase22_GtRNAdb2_gencode24_ncbi.bed.fa",
      bowtie1_index        => "/data/cqs/references/smallrna/mm10_miRBase22_GtRNAdb2_gencode24_ncbi",

      tDRmapper       => "/scratch/cqs/zhaos/vickers/otherPipeline/tDRmapper/Scripts/TdrMappingScripts.pl",
      tDRmapper_fasta => "/scratch/cqs/zhaos/vickers/otherPipeline/tDRmapper/mm10_mature_pre_for_tdrMapper.fa",

      hasYRNA   => 0,
      hasSnRNA  => 1,
      hasSnoRNA => 1,

      software_version => {
        host => "GENCODE GRCm38.p6",
      }
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
  return merge_hash_right_precedent(
    supplement_genome(),
    {

      #genome database
      mirbase_count_option => "-p rno",
      miRNA_coordinate     => "/data/cqs/references/smallrna/rn6_miRBase22_GtRNAdb2_ensembl99_ncbi.miRNA.bed",
      coordinate           => "/data/cqs/references/smallrna/rn6_miRBase22_GtRNAdb2_ensembl99_ncbi.bed",
      coordinate_fasta     => "/data/cqs/references/smallrna/rn6_miRBase22_GtRNAdb2_ensembl99_ncbi.bed.fa",
      bowtie1_index        => "/data/cqs/references/smallrna/rn6_miRBase22_GtRNAdb2_ensembl99_ncbi",

      hasYRNA   => 1,
      hasSnRNA  => 1,
      hasSnoRNA => 1,

      software_version => {
        host => "Ensembl Rnor_6.0",
      }
    }
  );
}

sub hg38_mm10_genome {
  return merge(
    supplement_genome(),
    {
      #genome database
      mirbase_count_option => "-p hsa",
      miRNA_coordinate     => "/data/cqs/references/smallrna/hg38_gencode33_mm10_gencode24_miRBase22_GtRNAdb2_ncbi.miRNA.bed",
      coordinate           => "/data/cqs/references/smallrna/hg38_gencode33_mm10_gencode24_miRBase22_GtRNAdb2_ncbi.modified.bed",
      coordinate_fasta     => "/data/cqs/references/smallrna/hg38_gencode33_mm10_gencode24_miRBase22_GtRNAdb2_ncbi.modified.fasta",
      bowtie1_index        => "/data/cqs/references/smallrna/hg38_gencode33_mm10_gencode24_miRBase22_GtRNAdb2_ncbi",

      hasYRNA   => 1,
      hasSnRNA  => 1,
      hasSnoRNA => 1,

      is_mix_genome => 1,

      software_version => {
        host => "GENCODE GRCh38.p13/GRCm38.p6",
      }
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

sub performSmallRNA_hg38_v2022 {
  my ( $userdef, $perform ) = @_;
  my $def = getSmallRNADefinition( $userdef, hg38_genome_v2022() );

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

sub performSmallRNA_hg38_mm10 {
  my ( $userdef, $perform ) = @_;
  my $def = getSmallRNADefinition( $userdef, hg38_mm10_genome() );

  my $config = performSmallRNA( $def, $perform );
  return $config;
}


1;
