#!/usr/bin/perl
package CQS::PerformRNASeq;

use strict;
use warnings;
use Pipeline::RNASeq;
use Hash::Merge qw( merge );

require Exporter;
our @ISA = qw(Exporter);

our %EXPORT_TAGS = ( 'all' => [ qw(gatk_b37_genome performRNASeq_gatk_b37) ] );

our @EXPORT = ( @{ $EXPORT_TAGS{'all'} } );

our $VERSION = '0.01';

sub global_definition {
  return {
    constraint => "haswell",
    gatk_jar   => "/scratch/cqs/shengq2/local/bin/gatk/GenomeAnalysisTK.jar",
    picard_jar => "/scratch/cqs/shengq2/local/bin/picard/picard.jar",
    cqstools   => "/home/shengq2/cqstools/cqstools.exe",
  };
}

#for miRBase analysis, we use the most recent version (corresponding to hg38) since the coordinates are not used in analysis.
sub gatk_b37_genome {
  return merge(
    global_definition(),
    {
      #genome database
      transcript_gtf => "/scratch/cqs/shengq2/references/gatk/b37/Homo_sapiens.GRCh37.82.MT.gtf",
      name_map_file  => "/scratch/cqs/shengq2/references/gatk/b37/Homo_sapiens.GRCh37.82.MT.map",
      star_index     => "/scratch/cqs/shengq2/references/gatk/b37/STAR_index_2.5.2b_ensembl_v82_sjdb99",
      fasta_file     => "/scratch/cqs/shengq2/references/gatk/b37/STAR_index_2.5.2b_ensembl_v82_sjdb99/human_g1k_v37.fasta",
      dbsnp          => "/scratch/cqs/shengq2/references/gatk/b37/dbsnp_150.b37.vcf",
      annovar_param  => "-protocol refGene,avsnp147,cosmic70 -operation g,f,f --remove",
      annovar_db     => "/scratch/cqs/shengq2/references/annovar/humandb/"
    }
  );
}

sub performRNASeq_gatk_b37 {
  my ( $userdef, $perform ) = @_;
  my $def = merge( $userdef, gatk_b37_genome() );
  my $config = performRNASeq( $def, $perform );
  return $config;
}

sub performRNASeqTask_gatk_b37 {
  my ( $userdef, $task ) = @_;
  my $def = merge( $userdef, gatk_b37_genome() );
  performRNASeqTask( $def, $task );
}
1;
