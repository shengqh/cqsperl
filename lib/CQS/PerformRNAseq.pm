#!/usr/bin/perl
package CQS::PerformRNAseq;

use strict;
use warnings;
use Pipeline::RNASeq;
use CQS::Global;
use CQS::ConfigUtils;

require Exporter;
our @ISA = qw(Exporter);

our %EXPORT_TAGS = (
  'all' => [
    qw(gencode_hg19_genome
      performRNASeq_gencode_hg19
      gencode_hg38_genome
      gencode_hg38_genome_v37
      performRNASeq_gencode_hg38
      performRNASeq_gencode_hg38_v37
      performRNASeq_gencode_hg38_v33
      gencode_mm10_genome
      performRNASeq_gencode_mm10
      ensembl_Mmul10_genome
      performRNASeq_ensembl_Mmul10
      ensembl_GRCz11_genome
      performRNASeq_ensembl_GRCz11
      ensembl_Rnor_6_genome
      performRNASeq_ensembl_Rnor_6
      )
  ]
  # 'all' => [
  #   qw(gencode_hg19_genome
  #     performRNASeq_gencode_hg19
  #     gatk_b37_genome
  #     performRNASeq_gatk_b37
  #     gencode_hg38_genome
  #     performRNASeq_gencode_hg38
  #     yan_hg38_genome
  #     performRNASeq_yan_hg38
  #     gencode_mm10_genome
  #     performRNASeq_gencode_mm10
  #     yan_mm10_genome
  #     performRNASeq_yan_mm10
  #     ensembl_Mmul1_genome
  #     performRNASeq_ensembl_Mmul1
  #     ensembl_Mmul8_genome
  #     performRNASeq_ensembl_Mmul8
  #     ncbi_UMD311_genome
  #     performRNASeq_ncbi_UMD311
  #     ensembl_CanFam3_1_genome
  #     performRNASeq_ensembl_CanFam3_1
  #     )
  # ]
);

our @EXPORT = ( @{ $EXPORT_TAGS{'all'} } );

our $VERSION = '0.01';

sub global_definition {
  my $gsea_db_ver = "v7.4";
  return merge_hash_right_precedent(global_options(), {
    constraint                => "haswell",
    perform_star_featurecount => 1,
    perform_qc3bam            => 0,
    qc3_perl                  => "/scratch/cqs_share/softwares/QC3/qc3.pl",
    docker_command            => singularity_prefix() . " /data/cqs/softwares/singularity/cqs-rnaseq.simg ",
    gatk_jar                  => "/opt/gatk3.jar",
    picard_jar                => "/opt/picard.jar",
    gsea_jar            => "gsea-cli.sh",
    gsea_db_ver         => $gsea_db_ver,
    gsea_db             => "/data/cqs/references/gsea/$gsea_db_ver",
    gsea_categories     => "'h.all.$gsea_db_ver.symbols.gmt', 'c2.all.$gsea_db_ver.symbols.gmt', 'c5.all.$gsea_db_ver.symbols.gmt', 'c6.all.$gsea_db_ver.symbols.gmt', 'c7.all.$gsea_db_ver.symbols.gmt'",

    software_version => {
      "GSEA" => ["v4"],
    }
  });
}

sub no_docker {
  return { gsea_jar => "gsea-cli.sh" };
}

sub common_human_genome {
  my ($userdef) = @_;

  my $result = merge_hash_right_precedent(
    global_definition(),
    {
      webgestalt_organism => "hsapiens",
      annovar_param       => "-protocol refGene,avsnp150,cosmic70 -operation g,f,f --remove",
      annovar_db          => "/data/cqs/references/annovar/humandb/",
      perform_webgestalt  => 1,
      perform_gsea        => 1,
    }
  );

  if ( ( defined $userdef ) and $userdef->{ignore_docker} ) {
    $result = merge_hash_right_precedent( $result, no_docker() );
  }

  return ($result);
}

sub common_hg19_genome {
  my ($userdef) = @_;
  return merge_hash_right_precedent(
    common_human_genome($userdef),
    {
      dbsnp            => "/data/cqs/references/dbsnp/dbSNP154.hg19.vcf.gz",
      annovar_buildver => "hg19",
    }
  );
}

sub gencode_hg19_genome {
  my ($userdef) = @_;
  return merge_hash_right_precedent(
    common_hg19_genome($userdef),
    {
      #genome database
      fasta_file     => "/data/cqs/references/gencode/GRCh37.p13/Homo_sapiens_assembly19.fasta",
      star_index     => "/data/cqs/references/gencode/GRCh37.p13/STAR_index_2.7.8a_v19_sjdb100",
      transcript_gtf => "/data/cqs/references/gencode/GRCh37.p13/gencode.v19.annotation.gtf",
      name_map_file  => "/data/cqs/references/gencode/GRCh37.p13/gencode.v19.annotation.gtf.map",
      software_version => {
        genome => "Gencode GRCh37.p13",
        gtf => "Gencode v19",
      }
    }
  );
}

# sub gatk_b37_genome {
#   my ($userdef) = @_;
#   return merge_hash_right_precedent(
#     common_hg19_genome($userdef),
#     {
#       #genome database
#       fasta_file     => "/scratch/cqs/references/human/b37/human_g1k_v37.fasta",
#       star_index     => "/scratch/cqs/references/human/b37/STAR_index_2.7.1a_ensembl_v75_sjdb100",
#       transcript_gtf => "/scratch/cqs/references/human/b37/Homo_sapiens.GRCh37.75.MT.gtf",
#       name_map_file  => "/scratch/cqs/references/human/b37/Homo_sapiens.GRCh37.75.MT.map",
#     }
#   );
# }

sub common_hg38_genome {
  my ($userdef) = @_;
  return merge_hash_right_precedent(
    common_human_genome($userdef),
    {
      dbsnp => "/data/cqs/references/dbsnp/dbSNP154.hg38.vcf.gz",
      annovar_buildver => "hg38",
    }
  );
}

sub get_gencode_hg38_genome {
  my ($userdef, $gtfVersion) = @_;
  return merge_hash_right_precedent(
    common_hg38_genome($userdef),
    {
      #genome database
      star_index     => "/data/cqs/references/gencode/GRCh38.p13/STAR_index_2.7.8a_${gtfVersion}_sjdb100",
      transcript_gtf => "/data/cqs/references/gencode/GRCh38.p13/gencode.${gtfVersion}.annotation.gtf",
      name_map_file  => "/data/cqs/references/gencode/GRCh38.p13/gencode.${gtfVersion}.annotation.gtf.map",
      gene_bed       => "/data/cqs/references/gencode/GRCh38.p13/gencode.${gtfVersion}.annotation.gtf.map.bed",
      software_version => {
        genome => "Gencode GRCh38.p13",
        gtf => "Gencode ${gtfVersion}",
      }
    }
  );
}

sub gencode_hg38_genome {
  my ($userdef) = @_;
  return(get_gencode_hg38_genome($userdef, "v38"));
}

sub gencode_hg38_genome_v37 {
  my ($userdef) = @_;
  return(get_gencode_hg38_genome($userdef, "v37"));
}

sub gencode_hg38_genome_v33 {
  my ($userdef) = @_;
  return(get_gencode_hg38_genome($userdef, "v33"));
}

# sub yan_hg38_genome() {
#   return merge_hash_right_precedent(
#     merge_hash_right_precedent( global_definition(), common_hg38_genome() ),
#     {
#       #genome database
#       fasta_file     => "/scratch/h_vangard_1/guoy1/reference/hg38/hg38chr.fa",
#       star_index     => "/scratch/h_vangard_1/guoy1/reference/hg38/star_index",
#       transcript_gtf => "/scratch/h_vangard_1/guoy1/reference/annotation3/hg38/Homo_sapiens.GRCh38.86_chr1-22-X-Y-MT.gtf",
#       name_map_file  => "/scratch/h_vangard_1/guoy1/reference/annotation3/hg38/Homo_sapiens.GRCh38.86_chr1-22-X-Y-MT.gtf.map",

#       #software
#       star_location => "/scratch/cqs/shengq2/tools/STAR-2.5.2a/bin/Linux_x86_64_static/STAR",
#       star_option =>
#         "--outSAMstrandField intronMotif --outFilterIntronMotifs RemoveNoncanonical --sjdbGTFfile /scratch/h_vangard_1/guoy1/reference/annotation3/hg38/Homo_sapiens.GRCh38.86_chr1-22-X-Y-MT.gtf",
#     }
#   );
# }

sub common_mm10_genome() {
  return merge_hash_right_precedent(mm10_options(), {
    webgestalt_organism => "mmusculus",
    perform_webgestalt  => 1,
    dbsnp               => "/data/cqs/references/dbsnp/mouse_10090_b150_GRCm38.p4.vcf.gz",
    annovar_buildver    => "mm10",
    annovar_param       => "-protocol refGene -operation g --remove",
    annovar_db          => "/data/cqs/references/annovar/mousedb/",
    perform_gsea        => 1,
    gsea_chip           => "/data/cqs/references/gsea/v7.4/Mouse_Gene_Symbol_Remapping_Human_Orthologs_MSigDB.v7.4.chip",
  });
}

sub gencode_mm10_genome {
  return merge_hash_right_precedent(
    merge_hash_right_precedent( global_definition(), common_mm10_genome() ),
    {
      #genome database
      fasta_file     => "/data/cqs/references/gencode/GRCm38.p6/GRCm38.primary_assembly.genome.fa",
      star_index     => "/data/cqs/references/gencode/GRCm38.p6/STAR_index_2.7.8a_vM24_sjdb100",
      transcript_gtf => "/data/cqs/references/gencode/GRCm38.p6/gencode.vM24.annotation.gtf",
      name_map_file  => "/data/cqs/references/gencode/GRCm38.p6/gencode.vM24.annotation.gtf.map",
      annotation_genes_add_chr => 1,
      software_version => {
        genome => "Gencode GRCm38.p6",
        gtf => "Gencode vM24",
      }
    }
  );
}

sub ensembl_Rnor_6_genome {
  die "contact tiger to build Rnor 6 genome. Thanks.";
  return merge_hash_right_precedent(
    global_definition(), 
    {
      perform_webgestalt  => 0,
      perform_gsea        => 1,
      gsea_chip           => "/data/cqs/references/gsea/v7.4/Rat_Gene_Symbol_Remapping_Human_Orthologs_MSigDB.v7.4.chip",

      #genome database
      fasta_file     => "/data/cqs/references/ensembl/Rnor6.0/Rattus_norvegicus.Rnor_6.0.dna.toplevel.fa",
      star_index     => "/data/cqs/references/ensembl/Rnor6.0/STAR_index_2.7.8a_ensembl_104_sjdb100",
      transcript_gtf => "/data/cqs/references/ensembl/Rnor6.0/Rattus_norvegicus.Rnor_6.0.104.gtf",
      name_map_file  => "/data/cqs/references/ensembl/Rnor6.0/Rattus_norvegicus.Rnor_6.0.104.gtf.map",
      software_version => {
        genome => "Ensembl Rnor6.0",
        gtf => "Ensembl v104",
      }
    }
  );
}

# sub yan_mm10_genome {
#   return merge_hash_right_precedent(
#     merge_hash_right_precedent( global_definition(), common_mm10_genome() ),
#     {
#       #genome database
#       fasta_file     => "/scratch/h_vangard_1/guoy1/reference/mm10/star_index/mm10.fa",
#       star_index     => "/scratch/h_vangard_1/guoy1/reference/mm10/star_index",
#       transcript_gtf => "/scratch/h_vangard_1/guoy1/reference/annotation3/mm10/Mus_musculus.GRCm38.82_chr1-19-X-Y-M.gtf",
#       name_map_file  => "/scratch/h_vangard_1/guoy1/reference/annotation3/mm10/Mus_musculus.GRCm38.82_chr1-19-X-Y-M.gtf.map",

#       #software
#       star_location => "/scratch/cqs/shengq2/tools/STAR-2.5.2a/bin/Linux_x86_64_static/STAR",
#       star_option =>
#         "--outSAMstrandField intronMotif --outFilterIntronMotifs RemoveNoncanonical --sjdbGTFfile /scratch/h_vangard_1/guoy1/reference/annotation3/mm10/Mus_musculus.GRCm38.82_chr1-19-X-Y-M.gtf",
#     }
#   );
# }

# sub ensembl_Mmul1_genome {
#   return merge_hash_right_precedent(
#     global_definition(),
#     {
#       perform_gsea => 0,

#       #genome database
#       fasta_file => "/scratch/cqs/shengq2/references/illumina/Mmul_1/Sequence/WholeGenomeFasta/genome.fa",

#       star_index     => "/scratch/cqs/shengq2/references/illumina/Mmul_1/Sequence/WholeGenomeFasta/STAR_index_2.7.1a_ensembl_Mmul_1_sjdb100",
#       transcript_gtf => "/scratch/cqs/shengq2/references/illumina/Mmul_1/Sequence/WholeGenomeFasta/genes.gtf",
#       name_map_file  => "/scratch/cqs/shengq2/references/illumina/Mmul_1/Sequence/WholeGenomeFasta/genes.map",
#     }
#   );
# }

# sub ensembl_Mmul8_genome {
#   return merge_hash_right_precedent(
#     global_definition(),
#     {
#       perform_gsea => 0,

#       #genome database
#       fasta_file => "/scratch/cqs/references/macaca_mulatta/Macaca_mulatta.Mmul_8.0.1.dna.toplevel.fa",

#       #star_index     => "/scratch/cqs/references/macaca_mulatta/STAR_index_2.5.3a_v8.0.1.95_sjdb100",
#       transcript_gtf => "/scratch/cqs/references/macaca_mulatta/Macaca_mulatta.Mmul_8.0.1.95.gtf",
#       name_map_file  => "/scratch/cqs/references/macaca_mulatta/Macaca_mulatta.Mmul_8.0.1.95.gtf.map",
#     }
#   );
# }

sub ensembl_Mmul10_genome {
  return merge_hash_right_precedent(
    global_definition(),
    {
      perform_gsea => 1,
      docker_command            => "singularity exec -e /scratch/cqs_share/softwares/singularity/cqs-rnaseq.simg ",
      fasta_file => "/scratch/cqs_share/references/ensembl/Mmul_10/Macaca_mulatta.Mmul_10.dna.primary_assembly.fa",
      star_index     => "/scratch/cqs_share/references/ensembl/Mmul_10/STAR_index_2.7.1a_v99_sjdb100",
      transcript_gtf => "/scratch/cqs_share/references/ensembl/Mmul_10/Macaca_mulatta.Mmul_10.99.chr.gtf",
      name_map_file  => "/scratch/cqs_share/references/ensembl/Mmul_10/Macaca_mulatta.Mmul_10.99.chr.gtf.map",
      software_version => {
        genome => "Ensembl Mmul 10",
        gtf => "Ensembl v99",
      }
    }
  );
}

sub ensembl_GRCz11_genome {
  return merge_hash_right_precedent(
    global_definition(),
    {
      perform_gsea => 0,

      #genome database
      fasta_file => "/data/cqs/references/zebrafish/GRCz11/Danio_rerio.GRCz11.dna.primary_assembly.fa",
      docker_command            => "singularity exec -e /scratch/cqs_share/softwares/singularity/cqs-rnaseq.simg ",

      star_index          => "/data/cqs/references/zebrafish/GRCz11/STAR_index",
      transcript_gtf      => "/data/cqs/references/zebrafish/GRCz11/Danio_rerio.GRCz11.102.gtf",
      name_map_file       => "/data/cqs/references/zebrafish/GRCz11/Danio_rerio.GRCz11.102.gtf.map",
      featureCount_option => "-g gene_name",
      software_version => {
        genome => "Ensembl GRCz11",
        gtf => "Ensembl v102",
      }
    }
  );
}

# sub ncbi_UMD311_genome {
#   return merge_hash_right_precedent(
#     global_definition(),
#     {
#       perform_gsea => 0,

#       #genome database
#       fasta_file => "/scratch/cqs/references/Bos_taurus/NCBI/UMD_3.1.1/Sequence/WholeGenomeFasta/genome.fa",

#       #star_index          => "/scratch/cqs/references/Bos_taurus/NCBI/UMD_3.1.1/Sequence/WholeGenomeFasta/STAR_index_2.5.3a_ncbi_UMD_3_1_1_sjdb99",
#       transcript_gtf      => "/scratch/cqs/references/Bos_taurus/NCBI/UMD_3.1.1/Sequence/WholeGenomeFasta/genes.gtf",
#       name_map_file       => "/scratch/cqs/references/Bos_taurus/NCBI/UMD_3.1.1/Sequence/WholeGenomeFasta/genes.map",
#       featureCount_option => "-g gene_name"
#     }
#   );
# }

# sub ensembl_CanFam3_1_genome {
#   return merge_hash_right_precedent(
#     global_definition(),
#     {
#       perform_gsea => 0,

#       #genome database
#       fasta_file => "/scratch/cqs/references/canis_familiaris/Canis_familiaris.CanFam3.1.dna.toplevel.fa",

#       #star_index          => "/scratch/cqs/references/canis_familiaris/STAR_index_2.5.3a_v3.1.96_sjdb100",
#       transcript_gtf => "/scratch/cqs/references/canis_familiaris/Canis_familiaris.CanFam3.1.96.gtf",
#       name_map_file  => "/scratch/cqs/references/canis_familiaris/Canis_familiaris.CanFam3.1.96.gtf.map",
#     }
#   );
# }

sub performRNASeq_gencode_hg19 {
  my ( $userdef, $perform ) = @_;
  my $def = merge_hash_left_precedent( $userdef, gencode_hg19_genome($userdef) );
  my $config = performRNASeq( $def, $perform );
  return $config;
}

# sub performRNASeq_gatk_b37 {
#   my ( $userdef, $perform ) = @_;
#   my $def = merge_hash_left_precedent( $userdef, gatk_b37_genome($userdef) );
#   my $config = performRNASeq( $def, $perform );
#   return $config;
# }

sub performRNASeq_gencode_hg38 {
  my ( $userdef, $perform ) = @_;
  my $def = merge_hash_left_precedent( $userdef, gencode_hg38_genome($userdef) );
  my $config = performRNASeq( $def, $perform );
  return $config;
}

sub performRNASeq_gencode_hg38_v37 {
  my ( $userdef, $perform ) = @_;
  my $def = merge_hash_left_precedent( $userdef, gencode_hg38_genome_v37($userdef) );
  my $config = performRNASeq( $def, $perform );
  return $config;
}

sub performRNASeq_gencode_hg38_v33 {
  my ( $userdef, $perform ) = @_;
  my $def = merge_hash_left_precedent( $userdef, gencode_hg38_genome_v33($userdef) );
  my $config = performRNASeq( $def, $perform );
  return $config;
}

# sub performRNASeq_yan_hg38 {
#   my ( $userdef, $perform ) = @_;
#   my $def = merge_hash_left_precedent( $userdef, yan_hg38_genome() );
#   my $config = performRNASeq( $def, $perform );
#   return $config;
# }

sub performRNASeq_gencode_mm10 {
  my ( $userdef, $perform ) = @_;
  my $def = merge_hash_left_precedent( $userdef, gencode_mm10_genome() );
  my $config = performRNASeq( $def, $perform );
  return $config;
}

# sub performRNASeq_yan_mm10 {
#   my ( $userdef, $perform ) = @_;
#   my $def = merge_hash_left_precedent( $userdef, yan_mm10_genome() );
#   my $config = performRNASeq( $def, $perform );
#   return $config;
# }

# sub performRNASeq_ensembl_Mmul1 {
#   my ( $userdef, $perform ) = @_;
#   my $def = merge_hash_left_precedent( $userdef, ensembl_Mmul1_genome() );
#   my $config = performRNASeq( $def, $perform );
#   return $config;
# }

sub performRNASeq_ensembl_Rnor_6 {
  my ( $userdef, $perform ) = @_;
  my $def = merge_hash_left_precedent( $userdef, ensembl_Rnor_6_genome() );
  my $config = performRNASeq( $def, $perform );
  return $config;
}

sub performRNASeq_ensembl_Mmul10 {
  my ( $userdef, $perform ) = @_;
  my $def = merge_hash_left_precedent( $userdef, ensembl_Mmul10_genome() );
  my $config = performRNASeq( $def, $perform );
  return $config;
}

sub performRNASeq_ensembl_GRCz11 {
  my ( $userdef, $perform ) = @_;
  my $def = merge_hash_left_precedent( $userdef, ensembl_GRCz11_genome() );
  my $config = performRNASeq( $def, $perform );
  return $config;
}

# sub performRNASeq_ncbi_UMD311 {
#   my ( $userdef, $perform ) = @_;
#   my $def = merge_hash_left_precedent( $userdef, ncbi_UMD311_genome() );
#   my $config = performRNASeq( $def, $perform );
#   return $config;
# }

# sub performRNASeq_ensembl_CanFam3_1 {
#   my ( $userdef, $perform ) = @_;
#   my $def = merge_hash_left_precedent( $userdef, ensembl_CanFam3_1_genome() );
#   my $config = performRNASeq( $def, $perform );
#   return $config;
# }

1;
