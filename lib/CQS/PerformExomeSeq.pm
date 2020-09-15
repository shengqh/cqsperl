#!/usr/bin/perl
package CQS::PerformExomeSeq;

use strict;
use warnings;
use Storable qw(dclone);
use CQS::StringUtils;
use Pipeline::ExomeSeq;
use Hash::Merge qw( merge );

require Exporter;
our @ISA = qw(Exporter);

our %EXPORT_TAGS = ( 'all' => [qw(
  global_definition
  gatk_hg38_genome 
  performExomeSeq_gatk_hg38 
  gatk_hg19_genome 
  performExomeSeq_gatk_hg19 
  gencode_mm10_genome
  performExomeSeq_gencode_mm10
  )] );

our @EXPORT = ( @{ $EXPORT_TAGS{'all'} } );

our $VERSION = '0.01';

sub global_definition {
  return {
    constraint => "haswell",

    gatk4_docker_command => "singularity exec -e /scratch/cqs_share/softwares/singularity/cqs-gatk4.simg ",
    gatk4_docker_init    => "source activate gatk  ",

    docker_command => "singularity exec -e /scratch/cqs_share/softwares/singularity/cqs-exomeseq.simg ",
    bamplot_docker_command => "singularity exec -e /scratch/cqs_share/softwares/singularity/bamplot.simg ",
    docker_init    => "",
    gatk3_jar      => "/opt/gatk3.jar",
    picard_jar     => "/opt/picard.jar",
    mutect_docker_command => "singularity exec -e /scratch/cqs_share/softwares/singularity/mutect.simg ",
    muTect_jar     => "/opt/mutect-1.1.7.jar",

    vcf2maf_pl => "/scratch/cqs/softwares/mskcc-vcf2maf/vcf2maf.pl",
    vep_path   => "/scratch/cqs/softwares/ensembl-vep",
    vep_data   => "/scratch/cqs/references/vep_data",
    cluster    => "slurm",

    #cromwell
    singularity_image_files=> {
#      "broadinstitute.gatk.4.1.4.1.simg" => "/scratch/cqs_share/softwares/singularity/gatk.4.1.4.1.simg",
      "broadinstitute.gatk.latest.simg" => "/scratch/cqs_share/softwares/singularity/gatk.latest.simg",
      "broadinstitute.gotc.latest.simg" => "/scratch/cqs_share/softwares/singularity/gotc.latest.simg",
      "python.latest.simg" => "/scratch/cqs_share/softwares/singularity/python.latest.simg",
      "gatk.latest.simg"=>"/scratch/cqs_share/softwares/singularity/gatk.latest.simg",
      "gotc.latest.simg"=>"/scratch/cqs_share/softwares/singularity/gotc.latest.simg",
    },

    wdl => {
      "cromwell_jar" => "/scratch/cqs_share/softwares/cromwell-51.jar",
      "cromwell_option_file" => "/scratch/cqs_share/softwares/cromwell/cromwell.options.json",
      "local" => {
        #"cromwell_config_file" => "/scratch/cqs_share/softwares/cromwell/cromwell.examples.local.conf",
        "cromwell_config_file" => "/home/zhaos/source/perl_cqs/test/cromwell/cromwell.examples.local.conf",
        "mutect2" => {
          "perform_mutect2_pon" => 0,
          "wdl_file" => "/scratch/cqs_share/softwares/cqsperl/data/wdl/mutect2.wdl",
        },
        "mutect2_pon" => {
          "wdl_file" => "/scratch/cqs_share/softwares/cqsperl/data/wdl/mutect2_pon.wdl",
        },
        "paired_fastq_to_unmapped_bam" => {
          "wdl_file" => "/scratch/cqs_share/softwares/gatk-workflows/seq-format-conversion/paired-fastq-to-unmapped-bam.wdl",
          "input_file" => "/scratch/cqs_share/softwares/gatk-workflows/seq-format-conversion/paired-fastq-to-unmapped-bam.inputs.json",
        },
        "paired_fastq_to_processed_bam" => {
          "wdl_file" => "/home/zhaos/source/perl_cqs/workflow/gatk4-data-processing/processing-for-variant-discovery-gatk4-fromPairEndFastq.wdl",
        },
        "somaticCNV_pon" => {
          "wdl_file" => "/scratch/cqs/zhaos/tools/gatk/scripts/cnv_wdl/somatic/cnv_somatic_panel_workflow.wdl"
        },
        "somaticCNV" => {
          "wdl_file" => "/scratch/cqs/zhaos/tools/gatk/scripts/cnv_wdl/somatic/cnv_somatic_pair_workflow.wdl"
        }
      }
    }

  };
}

sub gatk_hg38_genome {
  return merge(
    global_definition(),
    {
      ref_fasta      => "/scratch/cqs_share/references/broad/hg38/v0/Homo_sapiens_assembly38.fasta",
      ref_fasta_dict => "/scratch/cqs_share/references/broad/hg38/v0/Homo_sapiens_assembly38.dict",
      bwa_fasta      => "/scratch/cqs_share/references/broad/hg38/v0/bwa_index_0.7.17/Homo_sapiens_assembly38.fasta",

      has_chr_in_chromosome_name => 1,

      contig_ploidy_priors_file => "/scratch/cqs_share/references/broad/contig_ploidy_priors_homo_sapiens.chr.tsv",
      transcript_gtf => "/scratch/cqs_share/references/broad/hg38/v0/gencode.v27.primary_assembly.annotation.gtf",

      blacklist_file => "/scratch/cqs_share/references/blacklist_files/hg38-blacklist.v2.bed",

      dbsnp            => "/scratch/cqs_share/references/broad/hg38/v0/Homo_sapiens_assembly38.dbsnp138.vcf.gz",
      hapmap           => "/scratch/cqs_share/references/broad/hg38/v0/hapmap_3.3.hg38.vcf.gz",
      omni             => "/scratch/cqs_share/references/broad/hg38/v0/1000G_omni2.5.hg38.vcf.gz",
      g1000            => "/scratch/cqs_share/references/broad/hg38/v0/1000G_phase1.snps.high_confidence.hg38.vcf.gz",
      mills            => "/scratch/cqs_share/references/broad/hg38/v0/Mills_and_1000G_gold_standard.indels.hg38.vcf.gz",
      axiomPoly        => "/scratch/cqs_share/references/broad/hg38/v0/Axiom_Exome_Plus.genotypes.all_populations.poly.hg38.vcf.gz",
      perform_annovar  => 1,
      annovar_buildver => "hg38",
      annovar_param => "-protocol refGene,avsnp150,cosmic70,exac03,1000g2015aug_all,1000g2015aug_afr,1000g2015aug_amr,1000g2015aug_eas,1000g2015aug_eur,1000g2015aug_sas,gnomad211_genome,clinvar_20190305,topmed05 -operation g,f,f,f,f,f,f,f,f,f,f,f,f --remove",
      annovar_db => "/scratch/cqs_share/references/annovar/humandb/",
      annovar_filter => "--exac_key ExAC_ALL --g1000_key 1000g2015aug_all --gnomad_key AF --topmed_key TOPMed",
      species    => "homo_sapiens",
      ncbi_build => "GRCh38",
      plotCNVGenes      => 1,
      biomart_host      => "www.ensembl.org",
      biomart_dataset   => "hsapiens_gene_ensembl",
      biomart_symbolKey => "hgnc_symbol",

      wdl => {
        local => {
          "mutect2" => {
            "input_file" => "/scratch/cqs_share/softwares/cqsperl/data/wdl/local/mutect2.inputs.hg38.json",
          },
          "mutect2_pon" => {
            "input_file" => "/scratch/cqs_share/softwares/cqsperl/data/wdl/local/mutect2_pon.inputs.hg38.json",
          },
          "paired_fastq_to_processed_bam" => {
            "input_file" => "/home/zhaos/source/perl_cqs/workflow/gatk4-data-processing/processing-for-variant-discovery-gatk4.hg38.wgs.inputs.json",
          },
          "somaticCNV_pon" => {
            "input_file" => "/home/zhaos/source/perl_cqs/workflow/gatk-scripts-cnv_wdl-somatic/cnv_somatic_panel_workflow.wdl.json",
          },
          "somaticCNV" => {
            "input_file" => "/home/zhaos/source/perl_cqs/workflow/gatk-scripts-cnv_wdl-somatic/cnv_somatic_pair_workflow.wdl.json",
          }
        }
      }
    }
  );
}

sub gatk_hg19_genome {
  return merge(
    global_definition(),
    {
      ref_fasta      => "/scratch/cqs_share/references/broad/hg19/v0/Homo_sapiens_assembly19.fasta",
      ref_fasta_dict => "/scratch/cqs_share/references/broad/hg19/v0/Homo_sapiens_assembly19.dict",
      bwa_fasta      => "/scratch/cqs_share/references/broad/hg19/v0/bwa_index_0.7.17/Homo_sapiens_assembly19.fasta",

      has_chr_in_chromosome_name => 0,

      contig_ploidy_priors_file => "/scratch/cqs_share/references/broad/contig_ploidy_priors_homo_sapiens.noChr.tsv",
      transcript_gtf => "/scratch/cqs_share/references/broad/hg19/v0/Homo_sapiens.GRCh37.75.gtf",
      name_map_file  => "/scratch/cqs_share/references/broad/hg19/v0/Homo_sapiens.GRCh37.75.gtf.map",

      blacklist_file => "/scratch/cqs_share/references/blacklist_files/hg19-blacklist.v2.nochr.bed",

      dbsnp            => "/scratch/cqs_share/references/broad/hg19/v0/dbsnp_138.b37.vcf.gz",
      hapmap           => "/scratch/cqs_share/references/broad/hg19/v0/hapmap_3.3.b37.vcf.gz",
      mills            => "/scratch/cqs_share/references/broad/hg19/v0/Mills_and_1000G_gold_standard.indels.b37.vcf.gz",
      omni             => "/scratch/cqs_share/references/broad/hg19/v0/1000G_omni2.5.b37.vcf.gz",
      g1000            => "/scratch/cqs_share/references/broad/hg19/v0/1000G_phase1.snps.high_confidence.b37.vcf.gz",
      axiomPoly        => "/scratch/cqs_share/references/broad/hg19/v0/Axiom_Exome_Plus.genotypes.all_populations.poly.vcf.gz",
      perform_annovar  => 1,
      annovar_buildver => "hg19",
      annovar_param => "-protocol refGene,avsnp150,cosmic70,exac03,1000g2015aug_all,1000g2015aug_afr,1000g2015aug_amr,1000g2015aug_eas,1000g2015aug_eur,1000g2015aug_sas,gnomad211_genome,clinvar_20190305,topmed03 -operation g,f,f,f,f,f,f,f,f,f,f,f,f --remove",
      annovar_db => "/scratch/cqs_share/references/annovar/humandb/",
      annovar_filter => "--exac_key ExAC_ALL --g1000_key 1000g2015aug_all --gnomad_key AF --topmed_key TOPMed",
      species    => "homo_sapiens",
      ncbi_build => "GRCh37",
      plotCNVGenes      => 1,
      biomart_host      => "grch37.ensembl.org",
      biomart_dataset   => "hsapiens_gene_ensembl",
      biomart_symbolKey => "hgnc_symbol",

      wdl => {
        local => {
          "mutect2" => {
            "input_file" => "/scratch/cqs_share/softwares/cqsperl/data/wdl/local/mutect2.inputs.hg19.json",
          },
          "mutect2_pon" => {
            "input_file" => "/scratch/cqs_share/softwares/cqsperl/data/wdl/local/mutect2_pon.inputs.hg19.json",
          },
          paired_fastq_to_processed_bam => {
            "input_file" => "missing",
          }
        }
      }
    }
  );
}

#sub gatk_b37_genome {
#  return merge(
#    global_definition(),
#    {
#      #genome database
#      ref_fasta_dict            => "/scratch/cqs/shengq2/references/gatk/b37/human_g1k_v37.dict",
#      ref_fasta                 => "/scratch/cqs/shengq2/references/gatk/b37/human_g1k_v37.fasta",
#      bwa_fasta                 => "/scratch/cqs/shengq2/references/gatk/b37/bwa_index_0.7.17/human_g1k_v37.fasta",
#
#      has_chr_in_chromosome_name => 0,
#
#      contig_ploidy_priors_file => "/scratch/cqs/references/broad/contig_ploidy_priors_homo_sapiens.tsv",
#      transcript_gtf            => "/scratch/cqs/shengq2/references/gatk/b37/Homo_sapiens.GRCh37.82.MT.gtf",
#      name_map_file             => "/scratch/cqs/shengq2/references/gatk/b37/Homo_sapiens.GRCh37.82.MT.map",
#      dbsnp                     => "/scratch/cqs/shengq2/references/gatk/b37/dbsnp_150.b37.vcf.gz",
#      hapmap                    => "/scratch/cqs/shengq2/references/gatk/b37/hapmap_3.3.b37.vcf",
#      omni                      => "/scratch/cqs/shengq2/references/gatk/b37/1000G_omni2.5.b37.vcf",
#      g1000                     => "/scratch/cqs/shengq2/references/gatk/b37/1000G_phase1.snps.high_confidence.b37.vcf",
#      mills                     => "/scratch/cqs/shengq2/references/gatk/b37/Mills_and_1000G_gold_standard.indels.b37.vcf",
#      axiomPoly                 => "/scratch/cqs/references/broad/hg19/v0/Axiom_Exome_Plus.genotypes.all_populations.poly.vcf.gz",
#      cosmic                    => "/scratch/cqs/shengq2/references/cosmic/cosmic_v71_hg19_16569_MT.vcf",
#      perform_annovar           => 1,
#      annovar_buildver          => "hg19",
#      annovar_param =>
#"-protocol refGene,avsnp147,cosmic70,exac03,1000g2015aug_all,1000g2015aug_afr,1000g2015aug_amr,1000g2015aug_eas,1000g2015aug_eur,1000g2015aug_sas,gnomad_genome,clinvar_20180603 -operation g,f,f,f,f,f,f,f,f,f,f,f --remove",
#      annovar_db        => "/scratch/cqs/references/annovar/humandb/",
#      species           => "homo_sapiens",
#      ncbi_build        => "GRCh37",
#      vep_filter_vcf    => "/scratch/cqs/references/broad/ExAC.r1.sites.vep.vcf.gz",
#      plotCNVGenes      => 1,
#      biomart_host      => "grch37.ensembl.org",
#      biomart_dataset   => "hsapiens_gene_ensembl",
#      biomart_symbolKey => "hgnc_symbol",
#    }
#  );
#}

sub gencode_mm10_genome {
  return merge(
    global_definition(),
    {
      #genome database
      ref_fasta        => "/scratch/cqs_share/references/gencode/GRCm38.p6/GRCm38.primary_assembly.genome.fa",
      ref_fasta_dict   => "/scratch/cqs_share/references/gencode/GRCm38.p6/GRCm38.primary_assembly.genome.dict",
      bwa_fasta        => "/scratch/cqs_share/references/gencode/GRCm38.p6/bwa_index_0.7.17/GRCm38.primary_assembly.genome.fa",

      has_chr_in_chromosome_name => 1,

      transcript_gtf   => "/scratch/cqs_share/references/gencode/GRCm38.p6/gencode.vM24.annotation.gtf",
      name_map_file    => "/scratch/cqs_share/references/gencode/GRCm38.p6/gencode.vM24.annotation.gtf.map",

      blacklist_file => "/scratch/cqs_share/references/blacklist_files/mm10-blacklist.v2.bed",

      dbsnp            => "/scratch/cqs_share/references/dbsnp/mouse_10090_b150_GRCm38.p4.vcf.gz",
      perform_annovar  => 1,
      annovar_buildver => "mm10",
      annovar_param    => "-protocol refGene -operation g --remove",
      annovar_db       => "/scratch/cqs_share/references/annovar/mousedb/",

      species    => "mus_musculus",
      ncbi_build               => "GRCm38",
      perform_vep              => 0,
      perform_cnv_gatk4_cohort => 0,

      wdl => {
        local => {
          "mutect2" => {
            perform_mutect2_pon => 1,
            "input_file" => "/scratch/cqs_share/softwares/cqsperl/data/wdl/local/mutect2.inputs.mm10.json",
          },
          "mutect2_pon" => {
            "wdl_file" => "/scratch/cqs_share/softwares/cqsperl/data/wdl/mutect2_pon.no_gnomad.wdl",
            "input_file" => "/scratch/cqs_share/softwares/cqsperl/data/wdl/local/mutect2_pon.inputs.mm10.json",
          },
          paired_fastq_to_processed_bam => {
            "input_file" => "/home/zhaos/source/perl_cqs/workflow/gatk4-data-processing/processing-for-variant-discovery-gatk4.mm10.inputs.json",
          }
        }
      }
    }
  );
}

sub performExomeSeq_gatk_hg38 {
  my ( $userdef, $perform ) = @_;
  my $def = merge( $userdef, gatk_hg38_genome() );
  my $config = performExomeSeq( $def, $perform );
  return $config;
}

sub performExomeSeq_gatk_hg19 {
  my ( $userdef, $perform ) = @_;
  my $def = merge( $userdef, gatk_hg19_genome() );
  my $config = performExomeSeq( $def, $perform );
  return $config;
}

#sub performExomeSeq_gatk_b37 {
#  my ( $userdef, $perform ) = @_;
#  my $def = merge( $userdef, gatk_b37_genome() );
#  my $config = performExomeSeq( $def, $perform );
#  return $config;
#}
#
sub performExomeSeq_gencode_mm10 {
  my ( $userdef, $perform ) = @_;
  my $def = merge( $userdef, gencode_mm10_genome() );
  my $config = performExomeSeq( $def, $perform );
  return $config;
}

1;
