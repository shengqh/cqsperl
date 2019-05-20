#!/usr/bin/perl
package CQS::PerformExomeSeq;

use strict;
use warnings;
use Pipeline::ExomeSeq;
use Hash::Merge qw( merge );

require Exporter;
our @ISA = qw(Exporter);

our %EXPORT_TAGS = ( 'all' => [qw(gatk_hg38_genome performExomeSeq_gatk_hg38 gatk_b37_genome performExomeSeq_gatk_b37 performExomeSeq_gencode_mm10)] );

our @EXPORT = ( @{ $EXPORT_TAGS{'all'} } );

our $VERSION = '0.01';

sub global_definition {
  return {
    constraint        => "haswell",
    gatk3_jar         => "/scratch/cqs/softwares/gatk3.jar",
    gatk4_jar         => "/scratch/cqs/softwares/gatk4.jar",
    gatk4_singularity => "/scratch/cqs/softwares/singularity/gatk.4.1.0.0.simg",
    picard_jar        => "/scratch/cqs/shengq2/local/bin/picard/picard.jar",
    cqstools          => "/home/shengq2/cqstools/cqstools.exe",
    vcf2maf_pl        => "/scratch/cqs/softwares/mskcc-vcf2maf/vcf2maf.pl",
    vep_path          => "/scratch/cqs/softwares/ensembl-vep",
    vep_data          => "/scratch/cqs/references/vep_data",
    cluster           => "slurm",
  };
}
sub gatk_hg38_genome {
  return merge(
    global_definition(),
    {
      ref_fasta_dict            => "/scratch/cqs/baiy7/Tim_proj/Family_WGS/genome/hg38/Homo_sapiens_assembly38.dict",
      ref_fasta                 => "/scratch/cqs/baiy7/Tim_proj/Family_WGS/genome/hg38/Homo_sapiens_assembly38.fasta",
      bwa_fasta                 => "/scratch/cqs/baiy7/Tim_proj/Family_WGS/genome/hg38/Homo_sapiens_assembly38.fasta",
#      contig_ploidy_priors_file => "/scratch/cqs/references/broad/contig_ploidy_priors_homo_sapiens.tsv",
      transcript_gtf            => "/scratch/cqs/references/broad/hg38/v0/gencode.v27.primary_assembly.annotation.gtf",
#      name_map_file             => "/scratch/cqs/shengq2/references/gatk/b37/Homo_sapiens.GRCh37.82.MT.map",
      dbsnp                     => "/scratch/cqs/references/broad/hg38/v0/Homo_sapiens_assembly38.dbsnp138.vcfgz",
      hapmap                    => "/scratch/cqs/references/broad/hg38/v0/hapmap_3.3.hg38.vcf.gz",
      omni                      => "/scratch/cqs/references/broad/hg38/v0/1000G_omni2.5.hg38.vcf.gz",
      g1000                     => "/scratch/cqs/references/broad/hg38/v0/1000G_phase1.snps.high_confidence.hg38.vcf.gz",
      mills                     => "/scratch/cqs/references/broad/hg38/v0/Mills_and_1000G_gold_standard.indels.hg38.vcf.gz",
      axiomPoly                 => "/scratch/cqs/references/broad/hg38/v0Axiom_Exome_Plus.genotypes.all_populations.poly.hg38.vcf.gz",
      perform_annovar           => 1,
      annovar_buildver          => "hg38",
      annovar_param             => "-protocol refGene,avsnp147,cosmic70,exac03,1000g2015aug_all,1000g2015aug_afr,1000g2015aug_amr,1000g2015aug_eas,1000g2015aug_eur,1000g2015aug_sas,gnomad_genome,clinvar_20180603 -operation g,f,f,f,f,f,f,f,f,f,f,f --remove",
      annovar_db                => "/scratch/cqs/references/annovar/humandb/",
      species                   => "homo_sapiens",
      ncbi_build                => "GRCh38",
    }
  );
}
sub gatk_b37_genome {
  return merge(
    global_definition(),
    {
      #genome database
      ref_fasta_dict            => "/scratch/cqs/shengq2/references/gatk/b37/human_g1k_v37.dict",
      ref_fasta                 => "/scratch/cqs/shengq2/references/gatk/b37/human_g1k_v37.fasta",
      bwa_fasta                 => "/scratch/cqs/shengq2/references/gatk/b37/bwa_index_0.7.17/human_g1k_v37.fasta",
      contig_ploidy_priors_file => "/scratch/cqs/references/broad/contig_ploidy_priors_homo_sapiens.tsv",
      transcript_gtf            => "/scratch/cqs/shengq2/references/gatk/b37/Homo_sapiens.GRCh37.82.MT.gtf",
      name_map_file             => "/scratch/cqs/shengq2/references/gatk/b37/Homo_sapiens.GRCh37.82.MT.map",
      dbsnp                     => "/scratch/cqs/shengq2/references/gatk/b37/dbsnp_150.b37.vcf.gz",
      hapmap                    => "/scratch/cqs/shengq2/references/gatk/b37/hapmap_3.3.b37.vcf",
      omni                      => "/scratch/cqs/shengq2/references/gatk/b37/1000G_omni2.5.b37.vcf",
      g1000                     => "/scratch/cqs/shengq2/references/gatk/b37/1000G_phase1.snps.high_confidence.b37.vcf",
      mills                     => "/scratch/cqs/shengq2/references/gatk/b37/Mills_and_1000G_gold_standard.indels.b37.vcf",
      axiomPoly                 => "/scratch/cqs/references/broad/hg19/v0/Axiom_Exome_Plus.genotypes.all_populations.poly.vcf.gz",
      cosmic                    => "/scratch/cqs/shengq2/references/cosmic/cosmic_v71_hg19_16569_MT.vcf",
      perform_annovar           => 1,
      annovar_buildver          => "hg19",
      annovar_param             => "-protocol refGene,avsnp147,cosmic70,exac03,1000g2015aug_all,1000g2015aug_afr,1000g2015aug_amr,1000g2015aug_eas,1000g2015aug_eur,1000g2015aug_sas,gnomad_genome,clinvar_20180603 -operation g,f,f,f,f,f,f,f,f,f,f,f --remove",
      annovar_db                => "/scratch/cqs/references/annovar/humandb/",
      species                   => "homo_sapiens",
      ncbi_build                => "GRCh37",
      vep_filter_vcf => "/scratch/cqs/references/broad/ExAC.r1.sites.vep.vcf.gz"
    }
  );
}

sub gencode_mm10_genome {
  return merge(
    global_definition(),
    {
      #genome database
      ref_fasta_dict            => "/scratch/cqs/references/mouse/gencode_GRCm38.p6/GRCm38.p6.genome.dict",
      ref_fasta                 => "/scratch/cqs/references/mouse/gencode_GRCm38.p6/GRCm38.p6.genome.fa",
      bwa_fasta                 => "/scratch/cqs/references/mouse/gencode_GRCm38.p6/bwa_index_0.7.17/GRCm38.p6.genome.fa",
      transcript_gtf            => "/scratch/cqs/references/mouse/gencode_GRCm38.p6/gencode.vM19.chr_patch_hapl_scaff.annotation.gtf",
      name_map_file             => "/scratch/cqs/references/mouse/gencode_GRCm38.p6/gencode.vM19.chr_patch_hapl_scaff.annotation.gtf.map",
      dbsnp                     => "/scratch/cqs/references/dbsnp/mouse_10090_b150_GRCm38p4.vcf.gz",
      perform_annovar           => 1,
      annovar_buildver          => "mm10",
      annovar_param             => "-protocol refGene -operation g --remove",
      annovar_db                => "/scratch/cqs/references/annovar/mousedb_20181217/",
      #species                   => "homo_sapiens",
      ncbi_build                => "GRCm38",
      perform_vep => 0,
      perform_cnv_gatk4_cohort  => 0,
    }
  );
}
sub performExomeSeq_gatk_hg38 {
  my ( $userdef, $perform ) = @_;
  my $def = merge( $userdef, gatk_hg38_genome() );
  my $config = performExomeSeq( $def, $perform );
  return $config;
}
sub performExomeSeq_gatk_b37 {
  my ( $userdef, $perform ) = @_;
  my $def = merge( $userdef, gatk_b37_genome() );
  my $config = performExomeSeq( $def, $perform );
  return $config;
}

sub performExomeSeq_gencode_mm10 {
  my ( $userdef, $perform ) = @_;
  my $def = merge( $userdef, gencode_mm10_genome() );
  my $config = performExomeSeq( $def, $perform );
  return $config;
}

1;
