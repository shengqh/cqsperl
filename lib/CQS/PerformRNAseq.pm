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
      gatk_b37_genome
      performRNASeq_gatk_b37
      gencode_hg38_genome
      performRNASeq_gencode_hg38
      yan_hg38_genome
      performRNASeq_yan_hg38
      gencode_mm10_genome
      performRNASeq_gencode_mm10
      yan_mm10_genome
      performRNASeq_yan_mm10
      ensembl_Mmul1_genome
      performRNASeq_ensembl_Mmul1
      ensembl_Mmul8_genome
      performRNASeq_ensembl_Mmul8
      ncbi_UMD311_genome
      performRNASeq_ncbi_UMD311
      ensembl_CanFam3_1_genome
      performRNASeq_ensembl_CanFam3_1
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
    dbsnp               => "/scratch/cqs/references/human/b37/dbsnp_150.b37.vcf.gz",
    annovar_param       => "-protocol refGene,avsnp147,cosmic70 -operation g,f,f --remove",
    annovar_buildver    => "hg19",
    annovar_db          => "/scratch/cqs/references/annovar/humandb/",
    gsea_jar            => "/home/zhaos/bin/gsea-3.0.jar",
    gsea_db             => "/scratch/cqs/references/GSEA/v6.1",
    gsea_categories     => "'h.all.v6.1.symbols.gmt', 'c2.all.v6.1.symbols.gmt', 'c5.all.v6.1.symbols.gmt', 'c6.all.v6.1.symbols.gmt', 'c7.all.v6.1.symbols.gmt'",
    perform_webgestalt  => 1,
    perform_gsea        => 1,
  };
}

sub gencode_hg19_genome {
  return merge(
    merge( global_definition(), common_hg19_genome() ),
    {
      #genome database
      fasta_file     => "/scratch/cqs/references/human/gencode_GRCh37.p13/GRCh37.p13.genome.fa",
      star_index     => "/scratch/cqs/references/human/gencode_GRCh37.p13/STAR_index_2.7.1a_gencodeV19_sjdb100",
      transcript_gtf => "/scratch/cqs/references/human/gencode_GRCh37.p13/gencode.v19.chr_patch_hapl_scaff.annotation.gtf",
      name_map_file  => "/scratch/cqs/references/human/gencode_GRCh37.p13/gencode.v19.chr_patch_hapl_scaff.annotation.map",
    }
  );
}

sub gatk_b37_genome {
  return merge(
    merge( global_definition(), common_hg19_genome() ),
    {
      #genome database
      fasta_file     => "/scratch/cqs/references/human/b37/human_g1k_v37.fasta",
      star_index     => "/scratch/cqs/references/human/b37/STAR_index_2.7.1a_ensembl_v75_sjdb100",
      transcript_gtf => "/scratch/cqs/references/human/b37/Homo_sapiens.GRCh37.75.MT.gtf",
      name_map_file  => "/scratch/cqs/references/human/b37/Homo_sapiens.GRCh37.75.MT.map",
    }
  );
}

sub common_hg38_genome() {
  return {
    webgestalt_organism => "hsapiens",
    dbsnp               => "/scratch/cqs/references/human/b37/dbsnp_150.b37.vcf.gz",
    annovar_param       => "-protocol refGene,avsnp147,cosmic70 -operation g,f,f --remove",
    annovar_buildver    => "hg38",
    annovar_db          => "/scratch/cqs/references/annovar/humandb/",
    gsea_jar            => "/scratch/cqs/softwares/gsea-3.0.jar",
    gsea_db             => "/scratch/cqs/references/GSEA/v6.1",
    gsea_categories     => "'h.all.v6.1.symbols.gmt', 'c2.all.v6.1.symbols.gmt', 'c5.all.v6.1.symbols.gmt', 'c6.all.v6.1.symbols.gmt', 'c7.all.v6.1.symbols.gmt'",
    perform_webgestalt  => 1,
    perform_gsea        => 1,
  };
}

sub gencode_hg38_genome() {
  return merge(
    merge( global_definition(), common_hg38_genome() ),
    {
      #genome database
      fasta_file     => "/scratch/cqs/references/human/gencode_GRCh38.p12/GRCh38.p12.genome.fa",
      star_index     => "/scratch/cqs/references/human/gencode_GRCh38.p12/STAR_index_2.7.1a_gencodeV29_sjdb100",
      transcript_gtf => "/scratch/cqs/references/human/gencode_GRCh38.p12/gencode.v29.chr_patch_hapl_scaff.annotation.gtf",
      name_map_file  => "/scratch/cqs/references/human/gencode_GRCh38.p12/gencode.v29.chr_patch_hapl_scaff.annotation.gtf.map",
    }
  );
}

sub yan_hg38_genome() {
  return merge(
    merge( global_definition(), common_hg38_genome() ),
    {
      #genome database
      fasta_file     => "/scratch/h_vangard_1/guoy1/reference/hg38/hg38chr.fa",
      star_index     => "/scratch/h_vangard_1/guoy1/reference/hg38/star_index",
      transcript_gtf => "/scratch/h_vangard_1/guoy1/reference/annotation3/hg38/Homo_sapiens.GRCh38.86_chr1-22-X-Y-MT.gtf",
      name_map_file  => "/scratch/h_vangard_1/guoy1/reference/annotation3/hg38/Homo_sapiens.GRCh38.86_chr1-22-X-Y-MT.gtf.map",

      #software
      star_location => "/scratch/cqs/shengq2/tools/STAR-2.5.2a/bin/Linux_x86_64_static/STAR",
      star_option =>
        "--outSAMstrandField intronMotif --outFilterIntronMotifs RemoveNoncanonical --sjdbGTFfile /scratch/h_vangard_1/guoy1/reference/annotation3/hg38/Homo_sapiens.GRCh38.86_chr1-22-X-Y-MT.gtf",
    }
  );
}

sub common_mm10_genome() {
  return {
    webgestalt_organism => "mmusculus",
    dbsnp               => "/scratch/cqs/references/dbsnp/mouse_10090_b150_GRCm38p4.vcf.gz",
    annovar_buildver    => "mm10",
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
      fasta_file     => "/scratch/cqs/references/mouse/mm10/GRCm38.p6.genome.fa",
      star_index     => "/scratch/cqs/references/mouse/mm10/STAR_index_2.7.1a_gencodeVM19_sjdb100",
      transcript_gtf => "/scratch/cqs/references/mouse/mm10/gencode.vM19.chr_patch_hapl_scaff.annotation.gtf",
      name_map_file  => "/scratch/cqs/references/mouse/mm10/gencode.vM19.chr_patch_hapl_scaff.annotation.gtf.map",
    }
  );
}

sub yan_mm10_genome {
  return merge(
    merge( global_definition(), common_mm10_genome() ),
    {
      #genome database
      fasta_file     => "/scratch/h_vangard_1/guoy1/reference/mm10/star_index/mm10.fa",
      star_index     => "/scratch/h_vangard_1/guoy1/reference/mm10/star_index",
      transcript_gtf => "/scratch/h_vangard_1/guoy1/reference/annotation3/mm10/Mus_musculus.GRCm38.82_chr1-19-X-Y-M.gtf",
      name_map_file  => "/scratch/h_vangard_1/guoy1/reference/annotation3/mm10/Mus_musculus.GRCm38.82_chr1-19-X-Y-M.gtf.map",

      #software
      star_location => "/scratch/cqs/shengq2/tools/STAR-2.5.2a/bin/Linux_x86_64_static/STAR",
      star_option =>
        "--outSAMstrandField intronMotif --outFilterIntronMotifs RemoveNoncanonical --sjdbGTFfile /scratch/h_vangard_1/guoy1/reference/annotation3/mm10/Mus_musculus.GRCm38.82_chr1-19-X-Y-M.gtf",
    }
  );
}

sub ensembl_Mmul1_genome {
  return merge(
    global_definition(),
    {
      perform_gsea => 0,

      #genome database
      fasta_file     => "/scratch/cqs/shengq2/references/illumina/Mmul_1/Sequence/WholeGenomeFasta/genome.fa",
      star_index     => "/scratch/cqs/shengq2/references/illumina/Mmul_1/Sequence/WholeGenomeFasta/STAR_index_2.5.3a_ensembl_Mmul_1_sjdb99",
      transcript_gtf => "/scratch/cqs/shengq2/references/illumina/Mmul_1/Sequence/WholeGenomeFasta/genes.gtf",
      name_map_file  => "/scratch/cqs/shengq2/references/illumina/Mmul_1/Sequence/WholeGenomeFasta/genes.map",
    }
  );
}

sub ensembl_Mmul8_genome {
  return merge(
    global_definition(),
    {
      perform_gsea => 0,

      #genome database
      fasta_file     => "/scratch/cqs/references/macaca_mulatta/Macaca_mulatta.Mmul_8.0.1.dna.toplevel.fa",
      star_index     => "/scratch/cqs/references/macaca_mulatta/STAR_index_2.5.3a_v8.0.1.95_sjdb100",
      transcript_gtf => "/scratch/cqs/references/macaca_mulatta/Macaca_mulatta.Mmul_8.0.1.95.gtf",
      name_map_file  => "/scratch/cqs/references/macaca_mulatta/Macaca_mulatta.Mmul_8.0.1.95.gtf.map",
    }
  );
}

sub ncbi_UMD311_genome {
  return merge(
    global_definition(),
    {
      perform_gsea => 0,

      #genome database
      fasta_file          => "/scratch/cqs/references/Bos_taurus/NCBI/UMD_3.1.1/Sequence/WholeGenomeFasta/genome.fa",
      star_index          => "/scratch/cqs/references/Bos_taurus/NCBI/UMD_3.1.1/Sequence/WholeGenomeFasta/STAR_index_2.5.3a_ncbi_UMD_3_1_1_sjdb99",
      transcript_gtf      => "/scratch/cqs/references/Bos_taurus/NCBI/UMD_3.1.1/Sequence/WholeGenomeFasta/genes.gtf",
      name_map_file       => "/scratch/cqs/references/Bos_taurus/NCBI/UMD_3.1.1/Sequence/WholeGenomeFasta/genes.map",
      featureCount_option => "-g gene_name"
    }
  );
}

sub ensembl_CanFam3_1_genome {
  return merge(
    global_definition(),
    {
      perform_gsea => 0,

      #genome database
      fasta_file          => "/scratch/cqs/references/canis_familiaris/Canis_familiaris.CanFam3.1.dna.toplevel.fa",
      star_index          => "/scratch/cqs/references/canis_familiaris/STAR_index_2.5.3a_v3.1.96_sjdb100",
      transcript_gtf      => "/scratch/cqs/references/canis_familiaris/Canis_familiaris.CanFam3.1.96.gtf",
      name_map_file       => "/scratch/cqs/references/canis_familiaris/Canis_familiaris.CanFam3.1.96.gtf.map",
    }
  );
}

sub performRNASeq_gencode_hg19 {
  my ( $userdef, $perform ) = @_;
  my $def = merge( $userdef, gencode_hg19_genome() );
  my $config = performRNASeq( $def, $perform );
  return $config;
}

sub performRNASeq_gatk_b37 {
  my ( $userdef, $perform ) = @_;
  my $def = merge( $userdef, gatk_b37_genome() );
  my $config = performRNASeq( $def, $perform );
  return $config;
}

sub performRNASeq_gencode_hg38 {
  my ( $userdef, $perform ) = @_;
  my $def = merge( $userdef, gencode_hg38_genome() );
  my $config = performRNASeq( $def, $perform );
  return $config;
}

sub performRNASeq_yan_hg38 {
  my ( $userdef, $perform ) = @_;
  my $def = merge( $userdef, yan_hg38_genome() );
  my $config = performRNASeq( $def, $perform );
  return $config;
}

sub performRNASeq_gencode_mm10 {
  my ( $userdef, $perform ) = @_;
  my $def = merge( $userdef, gencode_mm10_genome() );
  my $config = performRNASeq( $def, $perform );
  return $config;
}

sub performRNASeq_yan_mm10 {
  my ( $userdef, $perform ) = @_;
  my $def = merge( $userdef, yan_mm10_genome() );
  my $config = performRNASeq( $def, $perform );
  return $config;
}

sub performRNASeq_ensembl_Mmul1 {
  my ( $userdef, $perform ) = @_;
  my $def = merge( $userdef, ensembl_Mmul1_genome() );
  my $config = performRNASeq( $def, $perform );
  return $config;
}

sub performRNASeq_ensembl_Mmul8 {
  my ( $userdef, $perform ) = @_;
  my $def = merge( $userdef, ensembl_Mmul8_genome() );
  my $config = performRNASeq( $def, $perform );
  return $config;
}

sub performRNASeq_ncbi_UMD311 {
  my ( $userdef, $perform ) = @_;
  my $def = merge( $userdef, ncbi_UMD311_genome() );
  my $config = performRNASeq( $def, $perform );
  return $config;
}

sub performRNASeq_ensembl_CanFam3_1 {
  my ( $userdef, $perform ) = @_;
  my $def = merge( $userdef, ensembl_CanFam3_1_genome() );
  my $config = performRNASeq( $def, $perform );
  return $config;
}

1;
