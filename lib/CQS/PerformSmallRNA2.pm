#!/usr/bin/perl
package CQS::PerformSmallRNA2;

use strict;
use warnings;
use Pipeline::SmallRNA;
use Pipeline::SmallRNAUtils;
use Hash::Merge qw( merge );

require Exporter;
our @ISA = qw(Exporter);

our %EXPORT_TAGS = (
  'all' => [
    qw(hg19_genome hg19_3utr hg38_genome mm10_genome mm10_3utr rn5_genome cel235_genome cfa3_genome performSmallRNA_hg19 performSmallRNATask_hg19 performSmallRNA_hg38 performSmallRNATask_hg38 performSmallRNA_mm10 performSmallRNATask_mm10 performSmallRNA_rn5 performSmallRNATask_rn5
      performSmallRNA_cel235 performSmallRNATask_cel235 performSmallRNA_cfa3 performSmallRNATask_cfa3 performSmallRNA_bta8 performSmallRNATask_bta8 performSmallRNA_eca2 performSmallRNATask_eca2 performSmallRNA_ssc3 performSmallRNATask_ssc3 performSmallRNA_ocu2 performSmallRNATask_ocu2
      performSmallRNA_oar3 performSmallRNATask_oar3 performSmallRNA_gga4 performSmallRNATask_gga4 performSmallRNA_fca6 performSmallRNATask_fca6 performSmallRNA_rheMac3 performSmallRNATask_rheMac3 performSmallRNA_chir1 performSmallRNATask_chir1 supplement_genome)
  ]
);

our @EXPORT = ( @{ $EXPORT_TAGS{'all'} } );

our $VERSION = '0.01';

my $mirBase20 = "/data/cqs/shengq1/reference/miRBase20/bowtie_index_1.1.1/mature.dna";
my $mirBase21 = "/data/cqs/shengq1/reference/miRBase21/bowtie_index_1.1.1/mature.dna";

sub supplement_genome {
  return {
    #miRBase database
    bowtie1_miRBase_index => $mirBase21,

    #human microbime database
    bowtie1_bacteria_group1_index => "/scratch/cqs/zhaos/vickers/reference/bacteria/group1/bowtie_index_1.1.2/bacteriaDatabaseGroup1",
    bacteria_group1_log           => "/scratch/cqs/zhaos/vickers/reference/bacteria/group1/20160907_Group1SpeciesAll.txt.log",
    bacteria_group1_species_map   => "/scratch/cqs/zhaos/vickers/reference/bacteria/group1/20160907_Group1SpeciesAll.species.map",

    #human enviroment bacteria database
    bowtie1_bacteria_group2_index => "/scratch/cqs/zhaos/vickers/reference/bacteria/group2/bowtie_index_1.1.2/bacteriaDatabaseGroup2",
    bacteria_group2_log           => "/scratch/cqs/zhaos/vickers/reference/bacteria/group2/20160907_Group2SpeciesAll.txt.log",
    bacteria_group2_species_map   => "/scratch/cqs/zhaos/vickers/reference/bacteria/group2/20160907_Group2SpeciesAll.species.map",

    #fungus database
    bowtie1_fungus_group4_index => "/scratch/cqs/zhaos/vickers/reference/bacteria/group4/bowtie_index_1.1.2/group4",
    fungus_group4_log           => "/scratch/cqs/zhaos/vickers/reference/bacteria/group4/20160225_group4.txt",
    fungus_group4_species_map   => "/scratch/cqs/zhaos/vickers/reference/bacteria/group4/20160225_Group4SpeciesAll.species.map",

    #UCSC tRNA database
    bowtie1_tRNA_index => "/scratch/cqs/shengq1/references/ucsc/GtRNAdb2/bowtie_index_1.1.2/GtRNAdb2.20160216.rmdup",
    trna_category_map  => "/scratch/cqs/shengq1/references/ucsc/GtRNAdb2/GtRNAdb2.20160216.category.map",

    #SILVA rRNA database
    bowtie1_rRNA_index => "/scratch/cqs/shengq1/references/rRNA/bowtie_index_1.1.2/SILVA_123.rmdup",
    rrna_category_map  => "/scratch/cqs/shengq1/references/rRNA/SILVA_123.category.map",

    #    bowtie1_rRNAS_index           => "/scratch/cqs/shengq1/references/rRNA/bowtie_index_1.1.2/SILVA_123_SSURef_Nr99_tax_silva.rmdup",
    #    bowtie1_rRNAL_index           => "/scratch/cqs/shengq1/references/rRNA/bowtie_index_1.1.2/SILVA_123_LSURef_tax_silva.rmdup",
    #    rrnaL_category_map            => "/scratch/cqs/shengq1/references/smallrna/SILVA_123_LSURef_tax_silva.category.map",
    #    rrnaS_category_map            => "/scratch/cqs/shengq1/references/smallrna/SILVA_123_SSURef_Nr99_tax_silva.category.map",
  };
}

#for miRBase analysis, we use the most recent version (corresponding to hg38) since the coordinates are not used in analysis.
sub hg19_genome {
  return merge(
    supplement_genome(),
    {
      #genome database
      mirbase_count_option  => "-p hsa",
      coordinate            => "/scratch/cqs/shengq1/references/smallrna/v2/hg19_miRBase21_GtRNAdb2_gencodeV25_SILVA.bed",
      coordinate_fasta      => "/scratch/cqs/shengq1/references/smallrna/v2/hg19_miRBase21_GtRNAdb2_gencodeV25_SILVA.bed.fa",
      bowtie1_index         => "/scratch/cqs/shengq1/references/genome_rrna/hg19/bowtie_index_1.1.2/hg19_gencodeP13_SILVA",
      gsnap_index_directory => "/scratch/cqs/shengq1/references/gencode/hg19/gsnap_index_k14_2016-08-08/",
      gsnap_index_name      => "GRCh37.p13.genome",
      star_index_directory  => "/scratch/cqs/shengq1/references/gencode/hg19/STAR_index_2.5.2b_gencodeV25_sjdb99"
    }
  );
}

sub hg19_3utr {
  my $bowtie1 = hg19_genome()->{bowtie1_index};
  return {
    search_3utr   => 1,
    bowtie1_index => $bowtie1,
    fasta_file    => $bowtie1 . ".fa",
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
      coordinate            => "/scratch/cqs/shengq1/references/smallrna/v2/hg38_miRBase21_GtRNAdb2_gencodeV25_SILVA.bed",
      coordinate_fasta      => "/scratch/cqs/shengq1/references/smallrna/v2/hg38_miRBase21_GtRNAdb2_gencodeV25_SILVA.bed.fa",
      bowtie1_index         => "/scratch/cqs/shengq1/references/genome_rrna/hg38/bowtie_index_1.1.2/hg38_gencodeP5_SILVA",
      gsnap_index_directory => "/scratch/cqs/shengq1/references/gencode/hg38/gsnap_index_k14_2016-08-08",
      gsnap_index_name      => "GRCh38.p5.genome",
      star_index_directory  => "/scratch/cqs/shengq1/references/gencode/hg38/STAR_index_2.5.2b_gencodeV25_sjdb99"
    }
  );
}

sub hg38_3utr {
  my $bowtie1 = hg38_genome()->{bowtie1_index};
  return {
    search_3utr   => 1,
    bowtie1_index => $bowtie1,
    fasta_file    => $bowtie1 . ".fa",
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
      coordinate            => "/scratch/cqs/shengq1/references/smallrna/v2/mm10_miRBase21_GtRNAdb2_ensembl85_SILVA.bed",
      coordinate_fasta      => "/scratch/cqs/shengq1/references/smallrna/v2/mm10_miRBase21_GtRNAdb2_ensembl85_SILVA.bed.fa",
      bowtie1_index         => "/scratch/cqs/shengq1/references/genome_rrna/mm10/bowtie_index_1.1.2/mm10_gencodeP4_SILVA",
      gsnap_index_directory => "/scratch/cqs/shengq1/references/gencode/mm10/gsnap_index_k14_2016-08-08/",
      gsnap_index_name      => "GRCm38.p4.genome",
      star_index_directory  => "/scratch/cqs/shengq1/references/gencode/mm10/STAR_index_2.5.2b_gencodeVM10_sjdb99"
    }
  );
}

sub mm10_3utr {
  my $bowtie1 = mm10_genome()->{bowtie1_index};
  return {
    search_3utr   => 1,
    bowtie1_index => $bowtie1,
    fasta_file    => $bowtie1 . ".fa",
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
      coordinate            => "/scratch/cqs/shengq1/references/smallrna/v2/rn5_miRBase21_GtRNAdb2_ensembl79_SILVA.bed",
      coordinate_fasta      => "/scratch/cqs/shengq1/references/smallrna/v2/rn5_miRBase21_GtRNAdb2_ensembl79_SILVA.bed.fa",
      bowtie1_index         => "/scratch/cqs/shengq1/references/genome_rrna/rn5/bowtie_index_1.1.2/rn5_SILVA",
      gsnap_index_directory => "/scratch/cqs/shengq1/references/rn5/gsnap_index_k14_2016-08-08/",
      gsnap_index_name      => "rn5",
      star_index_directory  => "/scratch/cqs/shengq1/references/rn5/STAR_index_2.5.2b_ensemblV79_sjdb99"
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

sub gga4_genome {
  return merge(
    supplement_genome(),
    {
      #genome database
      mirbase_count_option => "-p gga",
      coordinate           => "/scratch/cqs/zhaos/vickers/reference/Gallus_gallus/galGal4_miRBase21_ucsc-tRNA_ensembl83.bed",
      coordinate_fasta     => "/scratch/cqs/zhaos/vickers/reference/Gallus_gallus/galGal4_miRBase21_ucsc-tRNA_ensembl83.bed.fa",

      bowtie1_index => "/scratch/cqs/zhaos/vickers/reference/Gallus_gallus/bowtie_index_1.1.2/galGal4",
    }
  );
}

sub fca6_genome {
  return merge(
    supplement_genome(),
    {
      #genome database
      mirbase_count_option => "-p fca",
      coordinate           => "/scratch/cqs/zhaos/vickers/reference/Felis_catus/felCat5_ucsc-tRNA_ensembl83.bed",
      coordinate_fasta     => "/scratch/cqs/zhaos/vickers/reference/Felis_catus/felCat5_ucsc-tRNA_ensembl83.bed.fa",

      bowtie1_index => "/scratch/cqs/zhaos/vickers/reference/Felis_catus/bowtie_index_1.1.2/felCat5",
    }
  );
}

sub rheMac3_genome {
  return merge(
    supplement_genome(),
    {
      #genome database
      mirbase_count_option => "-p mml",
      coordinate           => "/scratch/cqs/zhaos/vickers/reference/Macaca_mulatta/rheMac3_miRBase21_ucsc-tRNA.bed",
      coordinate_fasta     => "/scratch/cqs/zhaos/vickers/reference/Macaca_mulatta/rheMac3_miRBase21_ucsc-tRNA.bed.fa",

      bowtie1_index => "/scratch/cqs/zhaos/vickers/reference/Macaca_mulatta/bowtie_index_1.1.2/rheMac3",
    }
  );
}

sub chir1_genome {
  return merge(
    supplement_genome(),
    {
      #genome database
      mirbase_count_option => "-p chi",
      coordinate           => "/gpfs21/scratch/cqs/zhaos/vickers/reference/Capra_hircus/chir1_miRBase21.bed",
      coordinate_fasta     => "/gpfs21/scratch/cqs/zhaos/vickers/reference/Capra_hircus/chir1_miRBase21.bed.fa",

      bowtie1_index => "/gpfs21/scratch/cqs/zhaos/vickers/reference/Capra_hircus/bowtie_index_1.1.2/chi_ref_CHIR_1.0_All",
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

sub performSmallRNA_hg38 {
  my ( $userdef, $perform ) = @_;
  my $def = getSmallRNADefinition( $userdef, hg38_genome() );

  my $config = performSmallRNA( $def, $perform );
  return $config;
}

sub performSmallRNATask_hg38 {
  my ( $userdef, $task ) = @_;
  my $def = getSmallRNADefinition( $userdef, hg38_genome() );

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

sub performSmallRNA_gga4 {
  my ( $userdef, $perform ) = @_;
  my $def = getSmallRNADefinition( $userdef, gga4_genome() );

  my $config = performSmallRNA( $def, $perform );
  return $config;
}

sub performSmallRNATask_gga4 {
  my ( $userdef, $task ) = @_;
  my $def = getSmallRNADefinition( $userdef, gga4_genome() );

  performSmallRNATask( $def, $task );
}

sub performSmallRNA_fca6 {
  my ( $userdef, $perform ) = @_;
  my $def = getSmallRNADefinition( $userdef, fca6_genome() );

  my $config = performSmallRNA( $def, $perform );
  return $config;
}

sub performSmallRNATask_fca6 {
  my ( $userdef, $task ) = @_;
  my $def = getSmallRNADefinition( $userdef, fca6_genome() );

  performSmallRNATask( $def, $task );
}

sub performSmallRNA_rheMac3 {
  my ( $userdef, $perform ) = @_;
  my $def = getSmallRNADefinition( $userdef, rheMac3_genome() );

  my $config = performSmallRNA( $def, $perform );
  return $config;
}

sub performSmallRNATask_rheMac3 {
  my ( $userdef, $task ) = @_;
  my $def = getSmallRNADefinition( $userdef, rheMac3_genome() );

  performSmallRNATask( $def, $task );
}

sub performSmallRNA_chir1 {
  my ( $userdef, $perform ) = @_;
  my $def = getSmallRNADefinition( $userdef, chir1_genome() );

  my $config = performSmallRNA( $def, $perform );
  return $config;
}

sub performSmallRNATask_chir1 {
  my ( $userdef, $task ) = @_;
  my $def = getSmallRNADefinition( $userdef, chir1_genome() );

  performSmallRNATask( $def, $task );
}

1;
