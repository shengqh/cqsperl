#!/usr/bin/perl
package CQS::PerformRNAseq;

use strict;
use warnings;
use Pipeline::RNASeq;
use Hash::Merge qw( merge );

require Exporter;
our @ISA = qw(Exporter);

our %EXPORT_TAGS = (
  'all' => [
    qw(gencode_hg19_genome
      performRNASeq_gencode_hg19
      performRNASeqTask_gencode_hg19
      gatk_b37_genome
      performRNASeq_gatk_b37
      performRNASeqTask_gatk_b37
      gencode_mm10_genome
      performRNASeq_gencode_mm10
      performRNASeqTask_gencode_mm10
      ensembl_Mmul1_genome
      performRNASeq_ensembl_Mmul1
      performRNASeqTask_ensembl_Mmul1
      )
  ]
);

our @EXPORT = ( @{ $EXPORT_TAGS{'all'} } );

our $VERSION = '0.01';

sub global_definition {
  return {
    constraint                => "haswell",
    gatk_jar                  => "/scratch/cqs/shengq2/local/bin/gatk/GenomeAnalysisTK.jar",
    picard_jar                => "/scratch/cqs/shengq2/local/bin/picard/picard.jar",
    cqstools                  => "/home/shengq2/cqstools/cqstools.exe",
    perform_star_featurecount => 1,
  };
}

sub common_hg19_genome() {
  return {
    webgestalt_organism => "hsapiens",
    dbsnp               => "/scratch/cqs/shengq2/references/gatk/b37/dbsnp_150.b37.vcf",
    annovar_param       => "-protocol refGene,avsnp147,cosmic70 -operation g,f,f --remove",
    annovar_db          => "/scratch/cqs/shengq2/references/annovar/humandb/",
    gsea_jar            => "/home/zhaos/bin/gsea-3.0.jar",
    gsea_db             => "/scratch/cqs/zhaos/reference/GSEA/human/V60",
  };
}

sub gencode_hg19_genome {
  return merge(
    merge( global_definition(), common_hg19_genome() ),
    {
      #genome database
      fasta_file     => "/scratch/cqs/shengq2/references/gencode/hg19/GRCh37.p13.genome.fa",
      star_index     => "/scratch/cqs/shengq2/references/gencode/hg19/STAR_index_2.5.2b_gencodeV19_sjdb99",
      transcript_gtf => "/scratch/cqs/shengq2/references/gencode/hg19/gencode.v19.chr_patch_hapl_scaff.annotation.gtf",
      name_map_file  => "/scratch/cqs/shengq2/references/gencode/hg19/gencode.v19.chr_patch_hapl_scaff.annotation.map",
    }
  );
}

sub gatk_b37_genome {
  return merge(
    merge( global_definition(), common_hg19_genome() ),
    {
      #genome database
      fasta_file     => "/scratch/cqs/shengq2/references/gatk/b37/human_g1k_v37.fasta",
      star_index     => "/scratch/cqs/shengq2/references/gatk/b37/STAR_index_2.5.3a_ensembl_v75_sjdb99",
      transcript_gtf => "/scratch/cqs/shengq2/references/gatk/b37/Homo_sapiens.GRCh37.75.MT.gtf",
      name_map_file  => "/scratch/cqs/shengq2/references/gatk/b37/Homo_sapiens.GRCh37.75.MT.map",
    }
  );
}

sub common_mm10_genome() {
  return {
    webgestalt_organism => "mmusculus",
    dbsnp               => "/scratch/cqs/shengq2/references/dbsnp/mm10/mouse_GRCm38_v142_M.vcf",
    annovar_param       => "-protocol refGene -operation g --remove",
    annovar_db          => "/scratch/cqs/shengq2/references/annovar/mm10db/",
    perform_gsea        => 0,
  };
}

sub gencode_mm10_genome {
  return merge(
    merge( global_definition(), common_mm10_genome() ),
    {
      #genome database
      fasta_file     => "/scratch/cqs/shengq2/references/gencode/mm10/GRCm38.p5.genome.fa",
      star_index     => "/scratch/cqs/shengq2/references/gencode/mm10/STAR_index_2.5.3a_vM15_sjdb100",
      transcript_gtf => "/scratch/cqs/shengq2/references/gencode/mm10/gencode.vM15.chr_patch_hapl_scaff.annotation.gtf",
      name_map_file  => "/scratch/cqs/shengq2/references/gencode/mm10/gencode.vM15.chr_patch_hapl_scaff.annotation.map",
    }
  );
}

sub ensembl_Mmul1_genome {
  return merge(
    global_definition(),
    {
      perform_gsea        => 0,
      #genome database
      fasta_file     => "/scratch/cqs/shengq2/references/illumina/Mmul_1/Sequence/WholeGenomeFasta/genome.fa",
      star_index     => "/scratch/cqs/shengq2/references/illumina/Mmul_1/Sequence/WholeGenomeFasta/STAR_index_2.5.3a_ensembl_Mmul_1_sjdb99",
      transcript_gtf => "/scratch/cqs/shengq2/references/illumina/Mmul_1/Sequence/WholeGenomeFasta/genes.gtf",
      name_map_file  => "/scratch/cqs/shengq2/references/illumina/Mmul_1/Sequence/WholeGenomeFasta/genes.map",
    }
  );
}

sub performRNASeq_gencode_hg19 {
  my ( $userdef, $perform ) = @_;
  my $def = merge( $userdef, gencode_hg19_genome() );
  my $config = performRNASeq( $def, $perform );
  return $config;
}

sub performRNASeqTask_gencode_hg19 {
  my ( $userdef, $task ) = @_;
  my $def = merge( $userdef, gencode_hg19_genome() );
  performRNASeqTask( $def, $task );
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

sub performRNASeq_gencode_mm10 {
  my ( $userdef, $perform ) = @_;
  my $def = merge( $userdef, gencode_mm10_genome() );
  my $config = performRNASeq( $def, $perform );
  return $config;
}

sub performRNASeqTask_gencode_mm10 {
  my ( $userdef, $task ) = @_;
  my $def = merge( $userdef, gencode_mm10_genome() );
  performRNASeqTask( $def, $task );
}

sub performRNASeq_ensembl_Mmul1 {
  my ( $userdef, $perform ) = @_;
  my $def = merge( $userdef, ensembl_Mmul1_genome() );
  my $config = performRNASeq( $def, $perform );
  return $config;
}

sub performRNASeqTask_ensembl_Mmul1 {
  my ( $userdef, $task ) = @_;
  my $def = merge( $userdef, ensembl_Mmul1_genome() );
  performRNASeqTask( $def, $task );
}

1;
