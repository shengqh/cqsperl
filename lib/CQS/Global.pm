#!/usr/bin/perl
package CQS::Global;

use strict;
use warnings;
use CQS::ConfigUtils;

require Exporter;
our @ISA = qw(Exporter);

sub get_binding {
  my $no_home = shift;

  if(!defined $no_home){
    $no_home = 0;
  }

  #print("no_home = $no_home");

  my $result = "";
  my @folders = qw(/panfs /data /dors /nobackup /tmp);
  if(!$no_home){
    my $userName =  $ENV{'LOGNAME'};
    push(@folders, "/home/$userName");
  }

  for my $folder (@folders){
    if (-d $folder) {
      if ($result eq "") {
        $result=$folder
      }else{
        $result=$result . "," . $folder
      }
    }
  }
  return($result);
}

our $bind_folders = get_binding();

our %EXPORT_TAGS = (
  'all' => [
    qw(
      get_binding
      singularity_prefix
      images
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

sub images {
  return {
    exomeseq => singularity_prefix() . " /data/cqs/softwares/singularity/cqs-exomeseq.20231031.sif "
  }
}

sub singularity_prefix {
  my ($by_run, $no_home) = @_;

  if(!defined $by_run){
    $by_run = 0;
  }

  if(!defined $no_home){
    $no_home = 0;
  }

  my $cmd = $by_run ? "run" : "exec";
  return("singularity $cmd -c -e -B " . get_binding($no_home) . " -H `pwd` ");
}

sub global_options {
  return {
    emailType => "FAIL",
    
    #constraint => "haswell",
    sratoolkit_setting_file => "/data/cqs/softwares/cqsperl/config/vdb-config/user-settings.mkfg",

    BWA_docker_command => images()->{"exomeseq"},
    bamplot_docker_command => singularity_prefix() . " /data/cqs/softwares/singularity/bamplot.simg ",
    chipqc_docker_command => singularity_prefix() . " /data/cqs/softwares/singularity/cqs-chipseq.chipqc.simg ",
    gatk4_docker_command => singularity_prefix() . " /data/cqs/softwares/singularity/cqs-gatk4.simg ",
    bamsnap_docker_command => singularity_prefix() . " /data/cqs/softwares/singularity/cqs-bamsnap.simg ",

    star_fusion_docker_command => singularity_prefix() . " /data/cqs/softwares/singularity/star-fusion.simg ",

    
    deepvariant_docker_command => singularity_prefix() . " /data/cqs/softwares/singularity/deepvariant-1.6.1.sif ",
    glnexus_docker_command => singularity_prefix() . " /data/cqs/softwares/singularity/glnexus.v1.2.7.sif ",

    bamsnap_option => "--no_gene_track",
    multiqc_docker_command => singularity_prefix() . " /data/cqs/softwares/singularity/multiqc.sif ",
    report_docker_command => singularity_prefix() . " /data/cqs/softwares/singularity/report.sif ",
    sratools_docker_command  => singularity_prefix() . " /data/cqs/softwares/singularity/sra-tools.3.2.1.sif ",
    crc_docker_command => singularity_prefix() . " /data/cqs/softwares/singularity/novartis.20210408.simg ",
    genepos_docker_command => singularity_prefix() . " /data/cqs/softwares/singularity/cqs-chipseq.simg ",
    fastq_screen_configuration_file => "/data/cqs/softwares/FastQ-Screen/fastq_screen.conf",

    correlation_docker_command => singularity_prefix() . " /data/cqs/softwares/singularity/cqs_correlation.20250616.sif",
    deseq2_docker_command => singularity_prefix() . " /data/cqs/softwares/singularity/cqs_correlation.20250616.sif",

    cellbender_docker_command => singularity_prefix() . " /data/cqs/softwares/singularity/cellbender.0.3.2.sif ",

    slamdunk_docker_command => singularity_prefix() . " /data/cqs/softwares/singularity/slamdunk.v0.4.3.sif ",
    nextgenmap_docker_command => singularity_prefix() . " /data/cqs/softwares/singularity/nextgenmap.v0.5.5.sif ",

    umitools_docker_command => singularity_prefix() . " /data/cqs/softwares/singularity/umitools.1.0.0.sif ",

    tetranscripts_docker_command => singularity_prefix() . "/data/cqs/softwares/singularity/tetranscripts.v2.2.3.sif",

    cutruntools2_docker_command => singularity_prefix() . " /data/cqs/softwares/singularity/cutruntools2.sif",
    cutruntools2_path => "/opt/CUT-RUNTools-2.0",
  };
}

sub mm10_options {
  return merge_hash_right_precedent(global_options(), {
    #biomart
    #For mm10, we have to use the ensembl 102 which corresponds to GRCm38.p6. The mouse genome became GRCm39 since ensembl 103.
    biomart_host      => "https://nov2020.archive.ensembl.org/",
    biomart_dataset   => "mmusculus_gene_ensembl",
    biomart_symbolKey => "mgi_symbol",
    biomart_add_chr => 1,

    blacklist_file => "/data/cqs/references/blacklist_files/mm10-blacklist.v2.bed",

    #macs2
    macs2_genome => "mm",

    #enhancer
    enhancer_cpg_path => "/data/cqs/references/ucsc/mm10_cpg_islands.bed",

    #chipqc
    chipqc_genome      => "mm10",
    chipqc_chromosomes => 'chr1,chr2,chr3,chr4,chr5,chr6,chr7,chr8,chr9,chr10,chr11,chr12,chr13,chr14,chr15,chr16,chr17,chr18,chr19',

    active_gene_genome => "/data/cqs/references/ucsc/mm10_refseq.ucsc",
    rose_genome => "MM10",

    #annotation
    homer_genome => "mm10",

    #visualization
    bamplot_option  => "-g MM10 -y uniform --save-temp",
    dataset_name => "mm10",
    add_chr => 1,

    bamsnap_option => "",
    bamsnap_raw_option => {
      "-refversion" => "mm10"
    }
  });
}

sub hg19_options {
  return merge_hash_right_precedent(global_options(), {
    #biomart
    biomart_host      => "https://grch37.ensembl.org",
    biomart_dataset   => "hsapiens_gene_ensembl",
    biomart_symbolKey => "hgnc_symbol",
    biomart_add_chr => 1,

    blacklist_file => "/data/cqs/references/blacklist_files/hg19-blacklist.v2.nochr.bed",

    #macs2
    macs2_genome => "hs",
    enhancer_cpg_path => "/data/cqs/references/mappable_region/hg19/hg19_cpg_islands.bed",
    
    #homer
    homer_genome => "hg19",

    #chipqc
    chipqc_genome      => "hg19",
    chipqc_chromosomes => 'chr1,chr2,chr3,chr4,chr5,chr6,chr7,chr8,chr9,chr10,chr11,chr12,chr13,chr14,chr15,chr16,chr17,chr18,chr19,chr20,chr21,chr22',

    active_gene_genome => "/data/cqs/references/ucsc/hg19_refseq.ucsc",
    rose_genome => "HG19",

    #visualization
    bamplot_option  => "-g HG19 -y uniform --save-temp",
    dataset_name => "hg19",
    add_chr => 1,

    bamsnap_option => "",
    bamsnap_raw_option => {
      "-refversion" => "hg19"
    }
  });
}

sub hg38_options {
  return merge_hash_right_precedent(global_options(), {
    #biomart
    biomart_host      => "https://www.ensembl.org",
    biomart_dataset   => "hsapiens_gene_ensembl",
    biomart_symbolKey => "hgnc_symbol",
    biomart_add_chr => 1,

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

    active_gene_genome => "/data/cqs/references/ucsc/hg38_refseq.ucsc",
    rose_genome => "HG38",

    #visualization
    bamplot_option  => "-g HG38 -y uniform --save-temp",
    dataset_name => "hg38",
    add_chr => 1,

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
    bwameth_fasta => "/data/cqs/references/gencode/GRCh38.p13/bwa_methylation_index/GRCh38.primary_assembly.genome.fa",
    genome_sizes => "/data/cqs/references/gencode/GRCh38.p13/GRCh38.primary_assembly.genome.sizes",

    #generated by cqstools gtf_buildmap
    gene_bed => "/data/cqs/references/gencode/GRCh38.p13/gencode.v38.annotation.gtf.map.bed",

    #enhancer
    enhancer_genome_path => "/data/cqs/references/gencode/GRCh38.p13/chromosomes/",
  };
}

sub gencode_mm10_databases {
  return {
    #aligner database
    fasta_file => "/data/cqs/references/gencode/GRCm38.p6/GRCm38.primary_assembly.genome.fa",
    bowtie2_index => "/data/cqs/references/gencode/GRCm38.p6/bowtie2_index_2.4.3/GRCm38.primary_assembly.genome",
    bowtie1_fasta => "/data/cqs/references/gencode/GRCm38.p6/bowtie_index_1.3.0/GRCm38.primary_assembly.genome.fa",
    bowtie1_index => "/data/cqs/references/gencode/GRCm38.p6/bowtie_index_1.3.0/GRCm38.primary_assembly.genome",
    bwa_fasta     => "/data/cqs/references/gencode/GRCm38.p6/bwa_index_0.7.17/GRCm38.primary_assembly.genome.fa",

    #generated by cqstools gtf_buildmap
    gene_bed => "/data/cqs/references/gencode/GRCm38.p6/gencode.vM25.annotation.gtf.map.bed",

    #enhancer
    enhancer_genome_path => "/data/cqs/references/gencode/GRCm38.p6/chromosomes",
  };
}

1;
