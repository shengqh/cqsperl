#!/usr/bin/perl
package CQS::PerformExomeSeq;

use strict;
use warnings;
use Pipeline::ExomeSeq;
use Hash::Merge qw( merge );

require Exporter;
our @ISA = qw(Exporter);

our %EXPORT_TAGS = ( 'all' => [qw(gatk_b37_genome performExomeSeq_gatk_b37)] );

our @EXPORT = ( @{ $EXPORT_TAGS{'all'} } );

our $VERSION = '0.01';

sub global_definition {
  return {
    constraint        => "haswell",
    gatk3_jar         => "/scratch/cqs/softwares/gatk3.jar",
    gatk4_jar         => "/scratch/cqs/softwares/gatk4.jar",
    gatk4_singularity => "/scratch/cqs/softwares/singularity/gatk4.simg",
    picard_jar        => "/scratch/cqs/shengq2/local/bin/picard/picard.jar",
    cqstools          => "/home/shengq2/cqstools/cqstools.exe",
    vcf2maf_pl        => "/scratch/cqs/softwares/mskcc-vcf2maf/vcf2maf.pl",
    vep_path          => "/scratch/cqs/softwares/ensembl-vep",
    vep_data          => "/scratch/cqs/references/vep_data",
  };
}

#for miRBase analysis, we use the most recent version (corresponding to hg38) since the coordinates are not used in analysis.
sub gatk_b37_genome {
  return merge(
    global_definition(),
    {
      #genome database
      ref_fasta_dict            => "/scratch/cqs/shengq2/references/gatk/b37/human_g1k_v37.dict",
      ref_fasta                 => "/scratch/cqs/shengq2/references/gatk/b37/human_g1k_v37.fasta",
      bwa_fasta                 => "/scratch/cqs/shengq2/references/gatk/b37/bwa_index_0.7.17/human_g1k_v37.fasta",
      contig_ploidy_priors_file => "/scratch/cqs/references/board/contig_ploidy_priors_homo_sapiens.tsv",
      transcript_gtf            => "/scratch/cqs/shengq2/references/gatk/b37/Homo_sapiens.GRCh37.82.MT.gtf",
      name_map_file             => "/scratch/cqs/shengq2/references/gatk/b37/Homo_sapiens.GRCh37.82.MT.map",
      dbsnp                     => "/scratch/cqs/shengq2/references/gatk/b37/dbsnp_150.b37.vcf.gz",
      hapmap                    => "/scratch/cqs/shengq2/references/gatk/b37/hapmap_3.3.b37.vcf",
      omni                      => "/scratch/cqs/shengq2/references/gatk/b37/1000G_omni2.5.b37.vcf",
      g1000                     => "/scratch/cqs/shengq2/references/gatk/b37/1000G_phase1.snps.high_confidence.b37.vcf",
      mills                     => "/scratch/cqs/shengq2/references/gatk/b37/Mills_and_1000G_gold_standard.indels.b37.vcf",
      cosmic                    => "/scratch/cqs/shengq2/references/cosmic/cosmic_v71_hg19_16569_MT.vcf",
      perform_annovar           => 1,
      annovar_buildver          => "hg19",
      annovar_param             => "-protocol refGene,avsnp147,cosmic70,exac03,clinvar_20180603 -operation g,f,f,f,f --remove",
      annovar_db                => "/scratch/cqs/shengq2/references/annovar/humandb/",
      species                   => "homo_sapiens",
      ncbi_build                => "GRCh37",
      vep_filter_vcf => "/scratch/cqs/references/board/ExAC.r1.sites.vep.vcf.gz"
    }
  );
}

sub performExomeSeq_gatk_b37 {
  my ( $userdef, $perform ) = @_;
  my $def = merge( $userdef, gatk_b37_genome() );
  my $config = performExomeSeq( $def, $perform );
  return $config;
}

sub performExomeSeqTask_gatk_b37 {
  my ( $userdef, $task ) = @_;
  my $def = merge( $userdef, gatk_b37_genome() );
  performExomeSeq( $def, $task );
}
1;
