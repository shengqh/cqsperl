#!/usr/bin/perl
package CQS::PerformExomeSeq;

use strict;
use warnings;
use Storable qw(dclone);
use CQS::StringUtils;
use Pipeline::ExomeSeq;
use CQS::Global;
use CQS::ConfigUtils;

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
  ucsc_mm10_genome
  performExomeSeq_ucsc_mm10
  ucsc_mm10_nochr_genome
  performExomeSeq_ucsc_mm10_nochr
  )] );

our @EXPORT = ( @{ $EXPORT_TAGS{'all'} } );

our $VERSION = '0.01';

sub global_definition {
  return merge_hash_right_precedent(global_options(), {
    #constraint => "haswell",

    gatk4_docker_command => singularity_prefix() . " /data/cqs/softwares/singularity/cqs-gatk-4.5.0.0.20240216.sif ",
    #gatk4_docker_init    => "source activate gatk  ",
    gotc_docker_command => singularity_prefix() . " /data/cqs/softwares/singularity/gotc.latest.simg ",

    docker_command => images()->{"exomeseq"},
    mafreport_docker_command => singularity_prefix() . " /data/cqs/softwares/singularity/mafreport.simg ",
    docker_init    => "",
    gatk3_jar      => "/opt/gatk3.jar",
    picard_jar     => "/opt/picard.jar",
    mutect_docker_command => singularity_prefix() . " /data/cqs/softwares/singularity/mutect.sif ",
    muTect_jar     => "/opt/mutect-1.1.7.jar",

    #this option came from mutect2 wdl file
    muTect2_option => "--downsampling-stride 20 --max-reads-per-alignment-start 6 --max-suspicious-reads-per-alignment-start 6",
    'Mutect2.run_orientation_bias_mixture_model_filter' => "true",

    # vcf2maf_pl => "/scratch/cqs/softwares/mskcc-vcf2maf/vcf2maf.pl",
    vep_path   => "/data/cqs/softwares/ensembl-vep",
    vep_data   => "/data/cqs/references/vep_data",
    cluster    => "slurm",

    #cromwell
    singularity_image_files=> {
      # "broadinstitute.gatk.latest.simg" => "/data/cqs/softwares/singularity/gatk.latest.simg",
      # "broadinstitute.gotc.latest.simg" => "/data/cqs/softwares/singularity/genomes-in-the-cloud.2.4.5-1590104571.simg",
      # "python.latest.simg" => "/data/cqs/softwares/singularity/python.2.7.simg",
      # "gatk.latest.simg"=>"/data/cqs/softwares/singularity/gatk.latest.simg",
      # "gotc.latest.simg"=>"/data/cqs/softwares/singularity/genomes-in-the-cloud.2.4.5-1590104571.simg",
    },

    wdl => {
      #"cromwell_jar" => "/data/cqs/softwares/cromwell/cromwell-53.1.jar",
      #"cromwell_jar" => "/data/cqs/softwares/cromwell/cromwell-64.jar",
      "cromwell_jar" => "/data/cqs/softwares/cromwell/cromwell-81.jar",
      "cromwell_option_file" => "/data/cqs/softwares/cqsperl/config/wdl/cromwell.options.json",
      "local" => {
        "cromwell_config_file" => "/data/cqs/softwares/cqsperl/config/wdl/cromwell.local.conf",
        #"cromwell_config_file" => "/home/zhaos/source/perl_cqs/test/cromwell/cromwell.examples.local.conf",
        "mutect2" => {
          "perform_mutect2_pon" => 0,
          "wdl_file" => "/data/cqs/softwares/cqsperl/data/wdl/mutect2.wdl",
          #new mutect2 wdl doesn't output correct file name, which make the trouble
          #"wdl_file" => "/data/cqs/softwares/gatk/scripts/mutect2_wdl/mutect2.wdl",
        },
        "mutect2_pon" => {
          "wdl_file" => "/data/cqs/softwares/cqsperl/data/wdl/mutect2_pon.wdl",
          #"wdl_file" => "/data/cqs/softwares/gatk/scripts/mutect2_wdl/mutect2_pon.wdl",
        },
        "paired_fastq_to_unmapped_bam" => {
          "wdl_file" => "/data/cqs/softwares/gatk-workflows/seq-format-conversion/paired-fastq-to-unmapped-bam.wdl",
          "input_file" => "/data/cqs/softwares/gatk-workflows/seq-format-conversion/paired-fastq-to-unmapped-bam.inputs.json",
        },
        "paired_fastq_to_processed_bam" => {
          "wdl_file" => "/data/cqs/softwares/cqsperl/config/wdl/processing-for-variant-discovery-gatk4-fromPairEndFastq.wdl",
        },
        "haplotypecaller" => {
          "wdl_file" => "/data/cqs/softwares/gatk-workflows/gatk4-germline-snps-indels/haplotypecaller-gvcf-gatk4.wdl",
        },
        "somaticCNV_pon" => {
          "wdl_file" => "/data/cqs/softwares/gatk-4.5.0.0/scripts/cnv_wdl/somatic/cnv_somatic_panel_workflow.wdl"
        },
        "somaticCNV" => {
          "wdl_file" => "/data/cqs/softwares/gatk-4.5.0.0/scripts/cnv_wdl/somatic/cnv_somatic_pair_workflow.wdl"
        },
        "CollectAllelicCounts" => {
          "wdl_file" => "/home/zhaos/source/ngsperl/lib/WDL/ExomeSeq/CollectAllelicCounts.wdl",
          "input_file" => "/home/zhaos/source/ngsperl/lib/WDL/ExomeSeq/CollectAllelicCounts.wdl.json"
        },
      }
    }

  });
}

sub gatk_hg38_genome {
  my $is_wgs = shift;
  my $global_hg38 = merge_hash_right_precedent(hg38_options(), global_definition());
  my $result = merge_hash_right_precedent(
    $global_hg38,
    {
      ref_fasta      => "/data/cqs/references/broad/hg38/v0/Homo_sapiens_assembly38.fasta",
      ref_fasta_dict => "/data/cqs/references/broad/hg38/v0/Homo_sapiens_assembly38.dict",
      bwa_fasta      => "/data/cqs/references/broad/hg38/v0/bwa_index_0.7.17/Homo_sapiens_assembly38.fasta",

      has_chr_in_chromosome_name => 1,

      is_wgs => (defined $is_wgs) ? $is_wgs : 0,

      contig_ploidy_priors_file => "/data/cqs/references/broad/hg38/contig_ploidy_priors_homo_sapiens.chr.tsv",
      transcript_gtf => "/data/cqs/references/broad/hg38/v0/gencode.v27.primary_assembly.annotation.gtf",

      eval_interval_list => "/data/cqs/references/broad/hg38/v0/wgs_evaluation_regions.hg38.interval_list",
      wgs_calling_regions_file => "/data/cqs/references/broad/hg38/v0/wgs_calling_regions.hg38.interval_list",
      blacklist_file => "/data/cqs/references/blacklist_files/hg38-blacklist.v2.bed",
      interval_list_file => "/data/cqs/references/broad/hg38/v0/hg38_wgs_scattered_calling_intervals.txt",
      known_indels_sites_VCFs => [ "/data/cqs/references/broad/hg38/v0/Mills_and_1000G_gold_standard.indels.hg38.vcf.gz",
        "/data/cqs/references/broad/hg38/v0/Homo_sapiens_assembly38.known_indels.vcf.gz"
      ],

      germline_resource => "/data/h_vangard_1/references/broad/gatk-best-practices/somatic-hg38/af-only-gnomad.hg38.vcf.gz",
      variants_for_contamination => "/data/h_vangard_1/references/broad/gatk-best-practices/somatic-hg38/small_exac_common_3.hg38.vcf.gz",

      dbsnp            => "/data/cqs/references/broad/hg38/v0/Homo_sapiens_assembly38.dbsnp138.vcf.gz",
      hapmap           => "/data/cqs/references/broad/hg38/v0/hapmap_3.3.hg38.vcf.gz",
      omni             => "/data/cqs/references/broad/hg38/v0/1000G_omni2.5.hg38.vcf.gz",
      g1000            => "/data/cqs/references/broad/hg38/v0/1000G_phase1.snps.high_confidence.hg38.vcf.gz",
      mills            => "/data/cqs/references/broad/hg38/v0/Mills_and_1000G_gold_standard.indels.hg38.vcf.gz",
      axiomPoly        => "/data/cqs/references/broad/hg38/v0/Axiom_Exome_Plus.genotypes.all_populations.poly.hg38.vcf.gz",
      perform_annovar  => 1,
      annovar_buildver => "hg38",
      annovar_param => "-protocol refGene,cytoBand,avsnp150,cosmic70,exac03,1000g2015aug_all,1000g2015aug_afr,1000g2015aug_amr,1000g2015aug_eas,1000g2015aug_eur,1000g2015aug_sas,gnomad30_genome,clinvar_20190305 -operation g,r,f,f,f,f,f,f,f,f,f,f,f --remove",
      annovar_db => "/data/cqs/references/annovar/humandb/",
      annovar_filter => "--exac_key ExAC_ALL --g1000_key 1000g2015aug_all --gnomad_key AF",
      species    => "homo_sapiens",
      ncbi_build => "GRCh38",
      plotCNVGenes      => 1,
      biomart_host      => "https://www.ensembl.org",
      biomart_dataset   => "hsapiens_gene_ensembl",
      biomart_symbolKey => "hgnc_symbol",

      panel_of_normals => "/data/h_vangard_1/references/broad/gatk-best-practices/somatic-hg38/1000g_pon.hg38.vcf.gz",

      #https://github.com/oicr-gsi/fingerprint_maps
      hapmap_file       => "/data/cqs/references/hg38/hg38_hapmap.txt",

      wdl => {
        local => {
          "mutect2" => {
            "input_file" => "/data/cqs/softwares/cqsperl/data/wdl/local/mutect2.inputs.hg38.json",
          },
          "mutect2_pon" => {
            "input_file" => "/data/cqs/softwares/cqsperl/data/wdl/local/mutect2_pon.inputs.hg38.json",
          },
          "paired_fastq_to_processed_bam" => {
            "input_file" => "/data/cqs/softwares/cqsperl/config/wdl/processing-for-variant-discovery-gatk4.hg38.wgs.inputs.json",
          },
          "somaticCNV_pon" => {
            "input_file" => "/nobackup/h_cqs/shengq2/program/cqsperl/config/wdl/cnv_somatic_panel_workflow.hg38.wdl.json",
          },
          "somaticCNV" => {
            "input_file" => "/nobackup/h_cqs/shengq2/program/cqsperl/config/wdl/cnv_somatic_pair_workflow.hg38.wdl.json",
          },
        }
      }
    }
  );

  if($result->{is_wgs}){
    $result->{covered_bed} = $result->{wgs_calling_regions_file};
  }

  return($result);
}

sub gatk_hg19_genome {
  my $is_wgs = shift;
  my $global_hg19 = merge_hash_right_precedent(hg19_options(), global_definition());
  my $result = merge_hash_right_precedent(
    $global_hg19,
    {
      ref_fasta      => "/data/cqs/references/broad/hg19/v0/Homo_sapiens_assembly19.fasta",
      ref_fasta_dict => "/data/cqs/references/broad/hg19/v0/Homo_sapiens_assembly19.dict",
      bwa_fasta      => "/data/cqs/references/broad/hg19/v0/bwa_index_0.7.17/Homo_sapiens_assembly19.fasta",

      is_wgs => (defined $is_wgs) ? $is_wgs : 0,

      has_chr_in_chromosome_name => 0,

      contig_ploidy_priors_file => "/data/cqs/references/broad/hg19/contig_ploidy_priors_homo_sapiens.noChr.tsv",
      transcript_gtf => "/data/cqs/references/broad/hg19/v0/Homo_sapiens.GRCh37.75.gtf",
      name_map_file  => "/data/cqs/references/broad/hg19/v0/Homo_sapiens.GRCh37.75.gtf.map",

      eval_interval_list => "/data/cqs/references/broad/hg19/v0/wgs_evaluation_regions.v1.interval_list",
      wgs_calling_regions_file => "/data/cqs/references/broad/hg19/v0/wgs_calling_regions.v1.interval_list",
      blacklist_file => "/data/cqs/references/blacklist_files/hg19-blacklist.v2.nochr.bed",
      interval_list_file => "/data/cqs/references/broad/hg19/v0/hg19_wgs_scattered_calling_intervals.txt",
      known_indels_sites_VCFs => [ "/data/cqs/references/broad/hg19/v0/Mills_and_1000G_gold_standard.indels.b37.vcf.gz",
        "/data/cqs/references/broad/hg19/v0/Homo_sapiens_assembly19.known_indels.vcf"
      ],

      germline_resource => "/data/h_vangard_1/references/broad/gatk-best-practices/somatic-b37/af-only-gnomad.raw.sites.vcf",
      panel_of_normals => "/data/h_vangard_1/references/broad/gatk-best-practices/somatic-b37/Mutect2-exome-panel.vcf",

      "CNVSomaticPairWorkflow.read_count_pon" => "/data/cqs/references/broad/hg19/v0/cnv/wes-do-gc.pon.hdf5",
      "CNVSomaticPairWorkflow.intervals" => "/data/cqs/references/broad/hg19/v0/cnv/ice_targets.tsv.interval_list",

      dbsnp            => "/data/cqs/references/broad/hg19/v0/dbsnp_138.b37.vcf.gz",
      hapmap           => "/data/cqs/references/broad/hg19/v0/hapmap_3.3.b37.vcf.gz",
      mills            => "/data/cqs/references/broad/hg19/v0/Mills_and_1000G_gold_standard.indels.b37.vcf.gz",
      omni             => "/data/cqs/references/broad/hg19/v0/1000G_omni2.5.b37.vcf.gz",
      g1000            => "/data/cqs/references/broad/hg19/v0/1000G_phase1.snps.high_confidence.b37.vcf.gz",
      axiomPoly        => "/data/cqs/references/broad/hg19/v0/Axiom_Exome_Plus.genotypes.all_populations.poly.vcf.gz",
      perform_annovar  => 1,
      annovar_buildver => "hg19",
      annovar_param => "-protocol refGene,cytoBand,avsnp150,cosmic70,exac03,1000g2015aug_all,1000g2015aug_afr,1000g2015aug_amr,1000g2015aug_eas,1000g2015aug_eur,1000g2015aug_sas,gnomad211_genome,clinvar_20190305,topmed03 -operation g,r,f,f,f,f,f,f,f,f,f,f,f,f --remove",
      annovar_db => "/data/cqs/references/annovar/humandb/",
      annovar_filter => "--exac_key ExAC_ALL --g1000_key 1000g2015aug_all --gnomad_key AF --topmed_key TOPMed",
      species    => "homo_sapiens",
      ncbi_build => "GRCh37",
      plotCNVGenes      => 1,
      biomart_host      => "https://grch37.ensembl.org",
      biomart_dataset   => "hsapiens_gene_ensembl",
      biomart_symbolKey => "hgnc_symbol",

      hapmap_file       => "/data/cqs/references/hg19/hg19_nochr_hapmap.txt",

      wdl => {
        local => {
          "mutect2" => {
            "input_file" => "/data/cqs/softwares/cqsperl/data/wdl/local/mutect2.inputs.hg19.json",
          },
          "mutect2_pon" => {
            "input_file" => "/data/cqs/softwares/cqsperl/data/wdl/local/mutect2_pon.inputs.hg19.json",
          },
          "paired_fastq_to_processed_bam" => {
            "input_file" => "missing",
          },
          "haplotypecaller" => {
            "input_file" => "/data/cqs/softwares/gatk-workflows/gatk4-germline-snps-indels/haplotypecaller-gvcf-gatk4.wdl",
          },
          "somaticCNV_pon" => {
            "input_file" => "/data/cqs/softwares/cqsperl/config/wdl/cnv_somatic_panel_workflow.hg19.wdl.json",
          },
          "somaticCNV" => {
            "input_file" => "/data/cqs/softwares/cqsperl/config/wdl/cnv_somatic_pair_workflow.hg19.wdl.json",
          },
        },
      }
    }
  );

  if($result->{is_wgs}){
    $result->{covered_bed} = $result->{wgs_calling_regions_file};
  }

  return($result);
}

#sub gatk_b37_genome {
#  return merge_hash_right_precedent(
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
  my $global_mm10 = merge_hash_right_precedent(mm10_options(), global_definition());
  return merge_hash_right_precedent(
    $global_mm10,
    {
      #genome database
      ref_fasta        => "/data/cqs/references/gencode/GRCm38.p6/GRCm38.primary_assembly.genome.fa",
      ref_fasta_dict   => "/data/cqs/references/gencode/GRCm38.p6/GRCm38.primary_assembly.genome.dict",
      bwa_fasta        => "/data/cqs/references/gencode/GRCm38.p6/bwa_index_0.7.17/GRCm38.primary_assembly.genome.fa",

      has_chr_in_chromosome_name => 1,

      transcript_gtf   => "/data/cqs/references/gencode/GRCm38.p6/gencode.vM24.annotation.gtf",
      name_map_file    => "/data/cqs/references/gencode/GRCm38.p6/gencode.vM24.annotation.gtf.map",

      blacklist_file => "/data/cqs/references/blacklist_files/mm10-blacklist.v2.bed",

      dbsnp            => "/data/cqs/references/dbsnp/mouse_10090_b150_GRCm38.p4.vcf.gz",
      perform_annovar  => 1,
      annovar_buildver => "mm10",
      annovar_param    => "-protocol refGene,cytoBand -operation g,r --remove",
      annovar_db       => "/data/cqs/references/annovar/mousedb/",

      species    => "mus_musculus",
      ncbi_build               => "GRCm38",
      perform_vep              => 0,
      perform_cnv_gatk4_cohort => 0,

      wdl => {
        local => {
          "mutect2" => {
            perform_mutect2_pon => 1,
            "input_file" => "/data/cqs/softwares/cqsperl/data/wdl/local/mutect2.inputs.mm10.json",
          },
          "mutect2_pon" => {
            "wdl_file" => "/data/cqs/softwares/cqsperl/data/wdl/mutect2_pon.no_gnomad.wdl",
            "input_file" => "/data/cqs/softwares/cqsperl/data/wdl/local/mutect2_pon.inputs.mm10.json",
          },
          paired_fastq_to_processed_bam => {
            "input_file" => "/home/zhaos/source/perl_cqs/workflow/gatk4-data-processing/processing-for-variant-discovery-gatk4.mm10.inputs.json",
          }
        }
      }
    }
  );
}

sub ucsc_mm10_genome {
  my $global_mm10 = merge_hash_right_precedent(mm10_options(), global_definition());
  return merge_hash_right_precedent(
    $global_mm10,
    {
      #genome database
      has_chr_in_chromosome_name => 1,
      fasta_file => "/data/cqs/references/ucsc/mm10/mm10.fa",
      ref_fasta => "/data/cqs/references/ucsc/mm10/mm10.fa",
      ref_fasta_dict => "/data/cqs/references/ucsc/mm10/mm10.dict",
      bwa_fasta        => "/data/cqs/references/ucsc/mm10/bwa_index_0.7.17/mm10.fa",
      blacklist_file => "/data/cqs/references/blacklist_files/mm10-blacklist.v2.bed",
      dbsnp => "/data/cqs/references/dbsnp/mouse_10090_b150_GRCm38.p4.vcf.gz",

      contig_ploidy_priors_file => "/data/cqs/references/broad/contig_ploidy_priors_mm10.tsv",

      perform_annovar  => 1,
      annovar_buildver => "mm10",
      annovar_param    => "-protocol refGene,cytoBand -operation g,r --remove",
      annovar_db       => "/data/cqs/references/annovar/mousedb/",

      species    => "mus_musculus",
      ncbi_build               => "GRCm38",
      perform_vep              => 0,
      perform_cnv_gatk4_cohort => 1,

      wdl => {
        local => {
          "mutect2" => {
            "input_file" => "/data/cqs/softwares/cqsperl/data/wdl/local/mutect2.inputs.ucsc.mm10.json",
          },
        }
      }
    }
  );
}

sub ucsc_mm10_nochr_genome {
  my $global_mm10 = merge_hash_right_precedent(mm10_options(), global_definition());
  return merge_hash_right_precedent(
    $global_mm10,
    {
      #genome database
      has_chr_in_chromosome_name => 0,
      fasta_file => "/data/cqs/references/ucsc/mm10_nochr_sorted/mm10.fa",
      ref_fasta => "/data/cqs/references/ucsc/mm10_nochr_sorted/mm10.fa",
      ref_fasta_dict => "/data/cqs/references/ucsc/mm10_nochr_sorted/mm10.dict",
      bwa_fasta        => "/data/cqs/references/ucsc/mm10_nochr_sorted/bwa_index_0.7.17/mm10.fa",
      blacklist_file => "/data/cqs/references/blacklist_files/mm10-blacklist.v2.nochr.bed",
      dbsnp => "/data/cqs/references/dbsnp/mouse_10090_b150_GRCm38.p4.nochr.vcf.gz",

      contig_ploidy_priors_file => "/data/cqs/references/broad/contig_ploidy_priors_mm10.nochr.tsv",

      perform_annovar  => 1,
      annovar_buildver => "mm10",
      annovar_param    => "-protocol refGene,cytoBand -operation g,r --remove",
      annovar_db       => "/data/cqs/references/annovar/mousedb/",

      species    => "mus_musculus",
      ncbi_build               => "GRCm38",
      perform_vep              => 0,
      perform_cnv_gatk4_cohort => 1,
    }
  );
}

sub performExomeSeq_gatk_hg38 {
  my ( $userdef, $perform ) = @_;
  my $def = merge_hash_left_precedent( $userdef, gatk_hg38_genome() );
  my $config = performExomeSeq( $def, $perform );
  return $config;
}

sub performExomeSeq_gatk_hg19 {
  my ( $userdef, $perform ) = @_;
  my $def = merge_hash_left_precedent( $userdef, gatk_hg19_genome() );
  my $config = performExomeSeq( $def, $perform );
  return $config;
}

#sub performExomeSeq_gatk_b37 {
#  my ( $userdef, $perform ) = @_;
#  my $def = merge_hash_left_precedent( $userdef, gatk_b37_genome() );
#  my $config = performExomeSeq( $def, $perform );
#  return $config;
#}
#
sub performExomeSeq_gencode_mm10 {
  my ( $userdef, $perform ) = @_;
  my $def = merge_hash_left_precedent( $userdef, gencode_mm10_genome() );
  my $config = performExomeSeq( $def, $perform );
  return $config;
}

sub performExomeSeq_ucsc_mm10 {
  my ( $userdef, $perform ) = @_;
  my $def = merge_hash_left_precedent( $userdef, ucsc_mm10_genome() );
  my $config = performExomeSeq( $def, $perform );
  return $config;
}

sub performExomeSeq_ucsc_mm10_nochr {
  my ( $userdef, $perform ) = @_;
  my $def = merge_hash_left_precedent( $userdef, ucsc_mm10_nochr_genome() );
  my $config = performExomeSeq( $def, $perform );
  return $config;
}

1;
