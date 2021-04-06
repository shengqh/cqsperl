#!/usr/bin/perl
package CQS::PerformChIPSeq;

use strict;
use warnings;
use Pipeline::ChIPSeq;
use CQS::Global;
use CQS::ConfigUtils;
use Hash::Merge qw( merge );

require Exporter;
our @ISA = qw(Exporter);

our %EXPORT_TAGS = (
  'all' => [
      "performChIPSeq_gencode_hg19",
      "performChIPSeq_gencode_hg38",
      "performChIPSeq_gencode_mm10",
      #"performChIPSeq_ucsc_hg19",
      #"performChIPSeq_ucsc_mm10"
  ]
);

our @EXPORT = ( @{ $EXPORT_TAGS{'all'} } );

our $VERSION = '0.01';

sub common_options {
  return merge(global_options(), {
    version    => 1,
    constraint => "haswell",

    docker_command => "singularity exec -e /data/cqs/softwares/singularity/cqs-chipseq.simg ",
    bamplot_docker_command => "singularity exec -e /scratch/cqs_share/softwares/singularity/bamplot.simg ",
    #chipqc_docker_command => "singularity exec -e /data/cqs/softwares/singularity/cqs-chipqc.simg ",
    bamsnap_docker_command => "singularity exec -e /data/cqs/softwares/singularity/bamsnap.simg ",
    picard_jar     => "/opt/picard.jar",

    perform_cutadapt => 0,

    aligner => "bowtie2",

    perform_cleanbam  => 1,
    remove_chromosome => "M",
    keep_chromosome   => "chr",

    peak_caller => "macs",

    perform_enhancer   => 0,
    enhancer_folder    => "/scratch/cqs_share/local/bin/linlabpipeline",
    enhancer_gsea_path => "/scratch/cqs_share/tools/gsea/gsea2-2.2.3.jar",
    enhancer_gmx_path  => "/scratch/cqs_share/tools/gsea/c2.all.v5.2.symbols.gmt",

    rose_folder => "/scratch/cqs_share/local/bin/bradnerlab",

    perform_chipqc => 1,

    homer_option => "",
  });
}

sub common_hg19_options {
  return {
    #clean option
    blacklist_file => "/scratch/cqs_share/references/hg19/wgEncodeDacMapabilityConsensusExcludable.bed",

    #macs2
    macs2_genome      => "hs",
    enhancer_cpg_path => "/scratch/cqs_share/references/hg19/hg19_cpg_islands.bed",

    #chipqc
    chipqc_genome      => "hg19",
    chipqc_chromosomes => 'chr1,chr2,chr3,chr4,chr5,chr6,chr7,chr8,chr9,chr10,chr11,chr12,chr13,chr14,chr15,chr16,chr17,chr18,chr19,chr20,chr21,chr22',

    homer_genome => "hg19",
    
    bamplot_option  => "-g HG19 -y uniform -r --save-temp",
  };
}

sub gencode_hg19_options {
  return merge_hash_right_precedent(
    merge_hash_right_precedent( common_options(), common_hg19_options() ),
    {
      #aligner database
      bowtie2_index => "/scratch/cqs_share/references/gencode/GRCh37.p13/bowtie2_index_2.3.5.1/Homo_sapiens_assembly19",
      bowtie1_fasta => "/scratch/cqs_share/references/gencode/GRCh37.p13/bowtie_index_1.2.3/Homo_sapiens_assembly19.fa",
      bowtie1_index => "/scratch/cqs_share/references/gencode/GRCh37.p13/bowtie_index_1.2.3/Homo_sapiens_assembly19",
      bwa_fasta     => "/scratch/cqs_share/references/gencode/GRCh37.p13/bwa_index_0.7.17/Homo_sapiens_assembly19.fa",

      #enhancer
      #enhancer_genome_path => "/scratch/cqs_share/references/gencode/GRCh37.p13/GRCh37.p13.chromosomes/",
    }
  );
}


sub common_hg38_options {
  return {
    #clean option
    #https://github.com/Boyle-Lab/Blacklist/raw/master/lists/hg38-blacklist.v2.bed.gz
    blacklist_file => "/scratch/cqs_share/references/mappable_region/hg38/hg38-blacklist.v2.bed",

    #macs2
    macs2_genome      => "hs",
    #wget http://hgdownload.cse.ucsc.edu/goldenPath/hg38/database/cpgIslandExt.txt.gz
    #zcat cpgIslandExt.txt.gz | cut -f 2,3,4,5 cpgIslandExt.txt > hg38_cpg_islands.bed
    enhancer_cpg_path => "/scratch/cqs_share/references/mappable_region/hg38/hg38_cpg_islands.bed",

    #chipqc
    chipqc_genome      => "hg38",
    chipqc_chromosomes => 'chr1,chr2,chr3,chr4,chr5,chr6,chr7,chr8,chr9,chr10,chr11,chr12,chr13,chr14,chr15,chr16,chr17,chr18,chr19,chr20,chr21,chr22',

    homer_genome => "hg38",
    
    bamplot_option  => "-g HG38 -y uniform -r --save-temp",
  };
}

sub gencode_hg38_options {
  return merge_hash_right_precedent(
    merge_hash_right_precedent( common_options(), common_hg38_options() ),
    {
      #aligner database
      bowtie2_index => "/scratch/cqs_share/references/gencode/GRCh38.p13/bowtie2_index_2.3.5.1/GRCh38.primary_assembly.genome",
      bowtie1_fasta => "/scratch/cqs_share/references/gencode/GRCh38.p13/bowtie_index_1.2.3/GRCh38.primary_assembly.genome.fa",
      bowtie1_index => "/scratch/cqs_share/references/gencode/GRCh38.p13/bowtie_index_1.2.3/GRCh38.primary_assembly.genome",
      bwa_fasta     => "/scratch/cqs_share/references/gencode/GRCh38.p13/bwa_index_0.7.17/GRCh38.primary_assembly.genome.fa",

      #enhancer
      #enhancer_genome_path => "/scratch/cqs_share/references/gencode/GRCh37.p13/GRCh37.p13.chromosomes/",
    }
  );
}

# sub ucsc_hg19_options {
#   return merge_hash_right_precedent(
#     merge_hash_right_precedent( common_options(), common_hg19_options() ),
#     {
#       #aligner database
#       bowtie2_index => "/scratch/cqs_share/references/illumina_iGenomes/Homo_sapiens/UCSC/hg19/Sequence/Bowtie2Index/genome",
#       bowtie1_fasta => "/scratch/cqs_share/references/illumina_iGenomes/Homo_sapiens/UCSC/hg19/Sequence/BowtieIndex/genome.fa",
#       bowtie1_index => "/scratch/cqs_share/references/illumina_iGenomes/Homo_sapiens/UCSC/hg19/Sequence/BowtieIndex/genome",
#       bwa_fasta     => "/scratch/cqs_share/references/illumina_iGenomes/Homo_sapiens/UCSC/hg19/Sequence/BWAIndex/genome.fa",

#       #enhancer
#       enhancer_genome_path => "/scratch/cqs_share/references/illumina_iGenomes/Homo_sapiens/UCSC/hg19/Sequence/Chromosomes/",
#     }
#   );
# }

sub common_mm10_options() {
  return {
    #clean option
    blacklist_file => "/scratch/cqs_share/references/mm10/mm10.blacklist.bed",

    #macs2
    macs2_genome => "mm",

    #enhancer
    enhancer_cpg_path => "/scratch/cqs_share/references/mm10/mm10_cpg_islands.bed",

    #chipqc
    chipqc_genome      => "mm10",
    chipqc_chromosomes => 'chr1,chr2,chr3,chr4,chr5,chr6,chr7,chr8,chr9,chr10,chr11,chr12,chr13,chr14,chr15,chr16,chr17,chr18,chr19',

    homer_genome => "mm10",

    biomart_host      => "www.ensembl.org",
    biomart_dataset   => "mmusculus_gene_ensembl",
    biomart_symbolKey => "mgi_symbol",

    bamplot_option  => "-g MM10 -y uniform -r --save-temp",
  };
}

sub gencode_mm10_options {
  return merge_hash_right_precedent(
    merge_hash_right_precedent( common_options(), common_mm10_options() ),
    {
      #aligner database
      bowtie2_index => "/scratch/cqs_share/references/gencode/GRCm38.p6/bowtie2_index_2.3.5.1/GRCm38.primary_assembly.genome",
      bowtie1_fasta => "/scratch/cqs_share/references/gencode/GRCm38.p6/bowtie_index_1.2.3/GRCm38.primary_assembly.genome.fa",
      bowtie1_index => "/scratch/cqs_share/references/gencode/GRCm38.p6/bowtie_index_1.2.3/GRCm38.primary_assembly.genome",
      bwa_fasta     => "/scratch/cqs_share/references/gencode/GRCm38.p6/bwa_index_0.7.17/GRCm38.primary_assembly.genome.fa",

      #enhancer
      #enhancer_genome_path => "/scratch/cqs_share/references/gencode/mm10/GRCm38.p5.chromosomes",
    }
  );
}

# sub ucsc_mm10_options {
#   return merge_hash_right_precedent(
#     merge_hash_right_precedent( common_options(), common_mm10_options() ),
#     {
#       #aligner database
#       bowtie2_index => "/scratch/cqs_share/references/illumina_iGenomes/Mus_musculus/UCSC/mm10/Sequence/Bowtie2Index/genome",
#       bowtie1_fasta => "/scratch/cqs_share/references/illumina_iGenomes/Mus_musculus/UCSC/mm10/Sequence/BowtieIndex/genome.fa",
#       bowtie1_index => "/scratch/cqs_share/references/illumina_iGenomes/Mus_musculus/UCSC/mm10/Sequence/BowtieIndex/genome",
#       bwa_fasta     => "/scratch/cqs_share/references/illumina_iGenomes/Mus_musculus/UCSC/mm10/Sequence/BWAIndex/genome.fa",

#       #enhancer
#       enhancer_genome_path => "/scratch/cqs_share/references/illumina_iGenomes/Mus_musculus/UCSC/mm10/Sequence/Chromosomes/",
#     }
#   );
# }

sub performChIPSeq_gencode_hg19 {
  my ( $userdef, $perform ) = @_;
  my $def = merge_hash_left_precedent( $userdef, gencode_hg19_options() );

  my $config = performChIPSeq( $def, $perform );
  return $config;
}

sub performChIPSeq_gencode_hg38 {
  my ( $userdef, $perform ) = @_;
  my $def = merge_hash_left_precedent( $userdef, gencode_hg38_options() );

  my $config = performChIPSeq( $def, $perform );
  return $config;
}

sub performChIPSeq_gencode_mm10 {
  my ( $userdef, $perform ) = @_;
  my $def = merge_hash_left_precedent( $userdef, gencode_mm10_options() );

  my $config = performChIPSeq( $def, $perform );
  return $config;
}

# sub performChIPSeq_ucsc_hg19 {
#   my ( $userdef, $perform ) = @_;
#   my $def = merge_hash_left_precedent( $userdef, ucsc_hg19_options() );

#   my $config = performChIPSeq( $def, $perform );
#   return $config;
# }

# sub performChIPSeq_ucsc_mm10 {
#   my ( $userdef, $perform ) = @_;
#   my $def = merge_hash_left_precedent( $userdef, ucsc_mm10_options() );

#   my $config = performChIPSeq( $def, $perform );
#   return $config;
# }

1;
