#!/usr/bin/perl
package CQS::Global;

use strict;
use warnings;
use CQS::ConfigUtils;

require Exporter;
our @ISA = qw(Exporter);

our $singularity_prefix_str = "singularity exec -c -B /gpfs51,/dors,/gpfs23,/scratch,/gpfs52,/data,/home,/nobackup,/tmp -H `pwd` -e";

our %EXPORT_TAGS = (
  'all' => [
    qw(
      singularity_prefix_str
      singularity_prefix
      global_options
      mm10_options
      hg19_options
      hg38_options
      gencode_hg19_databases
      gencode_hg38_databases
      gencode_mm10_databases
    )
  ]
);

our @EXPORT = ( @{ $EXPORT_TAGS{'all'} } );

our $VERSION = '0.01';

sub singularity_prefix {
  return ($singularity_prefix_str);
}

sub global_options {
  return {
    constraint => "haswell",
    sratoolkit_setting_file => "/scratch/cqs_share/softwares/cqsperl/config/vdb-config/user-settings.mkfg",
    BWA_docker_command => singularity_prefix() . " /data/cqs/softwares/singularity/cqs-exomeseq.simg ",
    bamplot_docker_command => singularity_prefix() . " /data/cqs/softwares/singularity/bamplot.simg ",
    chipqc_docker_command => singularity_prefix() . " /data/cqs/softwares/singularity/cqs-chipseq.chipqc.simg ",
    gatk4_docker_command => singularity_prefix() . " /data/cqs/softwares/singularity/cqs-gatk4.simg ",
    bamsnap_docker_command => singularity_prefix() . " /data/cqs/softwares/singularity/cqs-bamsnap.simg ",
    bamsnap_option => "--no_gene_track",
    multiqc_docker_command => singularity_prefix() . " /data/cqs/softwares/singularity/multiqc.sif ",
  };
}

sub mm10_options {
  return merge_hash_right_precedent(global_options(), {
    #biomart
    biomart_host      => "aug2020.archive.ensembl.org",
    biomart_dataset   => "mmusculus_gene_ensembl",
    biomart_symbolKey => "mgi_symbol",

    blacklist_file => "/data/cqs/references/blacklist_files/mm10-blacklist.v2.bed",

    #macs2
    macs2_genome => "mm",

    #enhancer
    enhancer_cpg_path => "/data/cqs/references/ucsc/mm10_cpg_islands.bed",

    #chipqc
    chipqc_genome      => "mm10",
    chipqc_chromosomes => 'chr1,chr2,chr3,chr4,chr5,chr6,chr7,chr8,chr9,chr10,chr11,chr12,chr13,chr14,chr15,chr16,chr17,chr18,chr19',

    active_gene_genome => "mm10",

    #annotation
    homer_genome => "mm10",

    #visualization
    bamplot_option  => "-g MM10 -y uniform -r --save-temp",

    bamsnap_option => "",
    bamsnap_raw_option => {
      "-refversion" => "mm10"
    }
  });
}

sub hg19_options {
  return merge_hash_right_precedent(global_options(), {
    #biomart
    biomart_host      => "grch37.ensembl.org",
    biomart_dataset   => "hsapiens_gene_ensembl",
    biomart_symbolKey => "hgnc_symbol",

    blacklist_file => "/data/cqs/references/blacklist_files/hg19-blacklist.v2.nochr.bed",

    #macs2
    macs2_genome => "hs",
    enhancer_cpg_path => "/data/cqs/references/mappable_region/hg19/hg19_cpg_islands.bed",
    
    #homer
    homer_genome => "hg19",

    #chipqc
    chipqc_genome      => "hg19",
    chipqc_chromosomes => 'chr1,chr2,chr3,chr4,chr5,chr6,chr7,chr8,chr9,chr10,chr11,chr12,chr13,chr14,chr15,chr16,chr17,chr18,chr19,chr20,chr21,chr22',

    active_gene_genome => "hg19",

    #visualization
    bamplot_option  => "-g HG19 -y uniform -r --save-temp",

    bamsnap_option => "",
    bamsnap_raw_option => {
      "-refversion" => "hg19"
    }
  });
}

sub hg38_options {
  return merge_hash_right_precedent(global_options(), {
    #biomart
    biomart_host      => "www.ensembl.org",
    biomart_dataset   => "hsapiens_gene_ensembl",
    biomart_symbolKey => "hgnc_symbol",

    #clean option
    #https://github.com/Boyle-Lab/Blacklist/raw/master/lists/hg38-blacklist.v2.bed.gz
    blacklist_file => "/data/cqs/references/blacklist_files/hg38-blacklist.v2.bed",

    #macs2
    macs2_genome => "hs",

    #wget http://hgdownload.cse.ucsc.edu/goldenPath/hg38/database/cpgIslandExt.txt.gz
    #zcat cpgIslandExt.txt.gz | cut -f 2,3,4,5 cpgIslandExt.txt > hg38_cpg_islands.bed
    enhancer_cpg_path => "/data/cqs/references/mappable_region/hg38/hg38_cpg_islands.bed",
    
    #homer
    homer_genome => "hg38",

    #chipqc
    chipqc_genome      => "hg38",
    chipqc_chromosomes => 'chr1,chr2,chr3,chr4,chr5,chr6,chr7,chr8,chr9,chr10,chr11,chr12,chr13,chr14,chr15,chr16,chr17,chr18,chr19,chr20,chr21,chr22',

    active_gene_genome => "hg38",

    #visualization
    bamplot_option  => "-g HG38 -y uniform -r --save-temp",

    bamsnap_option => "",
    bamsnap_raw_option => {
      "-refversion" => "hg38"
    }
  });
}

sub gencode_hg19_databases {
  return {
    #aligner database
    bowtie2_index => "/data/cqs/references/gencode/GRCh37.p13/bowtie2_index_2.4.3/GRCh37.primary_assembly.genome",
    bowtie1_fasta => "/data/cqs/references/gencode/GRCh37.p13/bowtie_index_1.3.0/GRCh37.primary_assembly.genome.fa",
    bowtie1_index => "/data/cqs/references/gencode/GRCh37.p13/bowtie_index_1.3.0/GRCh37.primary_assembly.genome",
    bwa_fasta     => "/data/cqs/references/gencode/GRCh37.p13/bwa_index_0.7.17/GRCh37.primary_assembly.genome.fa",

    #generated by cqstools gtf_buildmap
    gene_bed => "/data/cqs/references/gencode/GRCh37.p13/gencode.v19.annotation.gtf.map.bed",

    #enhancer
    enhancer_genome_path => "/data/cqs/references/gencode/GRCh37.p13/chromosomes/",
  };
}

sub gencode_hg38_databases {
  return {
    #aligner database
    fasta_file     => "/data/cqs/references/gencode/GRCh38.p13/GRCh38.primary_assembly.genome.fa",
    bowtie2_index => "/data/cqs/references/gencode/GRCh38.p13/bowtie2_index_2.4.3/GRCh38.primary_assembly.genome",
    bowtie1_fasta => "/data/cqs/references/gencode/GRCh38.p13/bowtie_index_1.3.0/GRCh38.primary_assembly.genome.fa",
    bowtie1_index => "/data/cqs/references/gencode/GRCh38.p13/bowtie_index_1.3.0/GRCh38.primary_assembly.genome",
    bwa_fasta     => "/data/cqs/references/gencode/GRCh38.p13/bwa_index_0.7.17/GRCh38.primary_assembly.genome.fa",

    #generated by cqstools gtf_buildmap
    gene_bed => "/data/cqs/references/gencode/GRCh38.p13/gencode.v38.annotation.gtf.map.bed",

    #enhancer
    enhancer_genome_path => "/data/cqs/references/gencode/GRCh38.p13/chromosomes/",
  };
}

sub gencode_mm10_databases {
  return {
    #aligner database
    bowtie2_index => "/data/cqs/references/gencode/GRCm38.p6/bowtie2_index_2.4.3/GRCm38.primary_assembly.genome",
    bowtie1_fasta => "/data/cqs/references/gencode/GRCm38.p6/bowtie_index_1.3.0/GRCm38.primary_assembly.genome.fa",
    bowtie1_index => "/data/cqs/references/gencode/GRCm38.p6/bowtie_index_1.3.0/GRCm38.primary_assembly.genome",
    bwa_fasta     => "/data/cqs/references/gencode/GRCm38.p6/bwa_index_0.7.17/GRCm38.primary_assembly.genome.fa",

    #generated by cqstools gtf_buildmap
    gene_bed => "/data/cqs/references/gencode/GRCm38.p6/gencode.vM26.annotation.gtf.map.bed",

    #enhancer
    enhancer_genome_path => "/data/cqs/references/gencode/GRCm38.p6/chromosomes",
  };
}

1;
