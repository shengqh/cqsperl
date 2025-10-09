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
    qw(
      add_human_gsea
      gencode_hg19_genome
      performRNASeq_gencode_hg19
      gencode_hg38_genome
      gencode_hg38_genome_v47_LncBookv2_1
      gencode_hg38_genome_v37
      performRNASeq_gencode_hg38
      performRNASeq_gencode_hg38_v48
      performRNASeq_gencode_hg38_v47
      performRNASeq_gencode_hg38_v47_LncBookv2_1
      performRNASeq_gencode_hg38_v37
      performRNASeq_gencode_hg38_v33
      add_mouse_gsea
      gencode_mm10_genome
      gencode_mm10_genome_vM24
      gencode_mm10_genome_vM25
      performRNASeq_gencode_mm10
      ensembl_Mmul10_genome
      performRNASeq_ensembl_Mmul10
      ensembl_GRCz11_genome
      performRNASeq_ensembl_GRCz11
      ensembl_Rnor_6_genome
      performRNASeq_ensembl_Rnor_6
      ncbi_Sscrofa11_genome
      performRNASeq_ncbi_Sscrofa11
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

our $VERSION = '0.02';
our $gsea_ver = "4.3.2";
#our $gsea_db_ver = "v2022.1.Hs";
our $gsea_db_ver = "v2025.1.Hs";

sub add_human_gsea {
  my ($def, $host) = @_;
  $def->{use_mouse_gsea_db} = 0;

  if (!defined $host) {
    die "host not defined, can be Human,Mouse,Rat and so on. Looking for HOST_Gene_Symbol_Remapping_Human_Orthologs_MSigDB.$gsea_db_ver.chip."
  }
  
  $host = ucfirst($host);
  if($host eq "Human"){
    $def->{gsea_chip} = undef;
  }else{
    $def->{gsea_chip} = "/data/cqs/references/gsea/msigdb_${gsea_db_ver}_chip_files_to_download_locally/${host}_Gene_Symbol_Remapping_Human_Orthologs_MSigDB.$gsea_db_ver.chip",
  }

  return merge_hash_left_precedent($def, {
    perform_gsea => 1,
    gsea_jar => "gsea-cli.sh",
    gsea_db => "/data/cqs/references/gsea/msigdb_${gsea_db_ver}_GMTs",
    gsea_categories => "'h.all.$gsea_db_ver.symbols.gmt', 'c2.all.$gsea_db_ver.symbols.gmt', 'c5.all.$gsea_db_ver.symbols.gmt', 'c6.all.$gsea_db_ver.symbols.gmt', 'c7.all.$gsea_db_ver.symbols.gmt'",
    gsea_makeReport => 0,
    software_version => {
      "GSEA" => ["v${gsea_ver}"],
      "GSEA_DB" => ["${gsea_db_ver}"],
    }
  });
}

sub global_definition {
  my $result = merge_hash_right_precedent(global_options(), {
    #constraint                => "haswell",
    perform_star_featurecount => 1,
    perform_qc3bam            => 0,
    qc3_perl                  => "/data/cqs/softwares/QC3/qc3.pl",
    docker_command            => singularity_prefix() . " /data/cqs/softwares/singularity/cqs-rnaseq.simg ",
    gatk_jar                  => "/opt/gatk3.jar",
    picard_jar                => "/opt/picard.jar",
  });

  return($result);
}

sub no_docker {
  return { gsea_jar => "gsea-cli.sh" };
}

sub common_human_genome {
  my ($userdef) = @_;

  my $result = merge_hash_right_precedent(
    global_definition(),
    {
      annovar_param       => "-protocol refGene,avsnp151,cosmic70 -operation g,f,f --remove",
      annovar_db          => "/data/cqs/references/annovar/humandb/",
      perform_webgestalt  => 1,
      webgestalt_organism => "hsapiens",
      perform_gsea        => 1,
    }
  );

  if ( ( defined $userdef ) and $userdef->{ignore_docker} ) {
    $result = merge_hash_right_precedent( $result, no_docker() );
  }

  $result = add_human_gsea($result, "Human");

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
      # fasta_file     => "/data/cqs/references/gencode/GRCh37.p13/GRCh37.primary_assembly.genome.fa",
      # star_index     => "/data/cqs/references/gencode/GRCh37.p13/STAR_index_2.7.8a_v19_sjdb100",
      # transcript_gtf => "/data/cqs/references/gencode/GRCh37.p13/gencode.v19.annotation.gtf",
      # name_map_file  => "/data/cqs/references/gencode/GRCh37.p13/gencode.v19.annotation.gtf.map",
      # dexseq_gff     => "/data/cqs/references/gencode/GRCh37.p13/gencode.v19.annotation.dexseq.gff",
      fasta_file     => "/data/cqs/references/gencode/GRCh37.p13.reorder/GRCh37.primary_assembly.genome.reorder.fa",
      star_index     => "/data/cqs/references/gencode/GRCh37.p13.reorder/STAR_index_2.7.8a_v19_sjdb100",
      transcript_gtf => "/data/cqs/references/gencode/GRCh37.p13.reorder/gencode.v19.annotation.gtf",
      name_map_file  => "/data/cqs/references/gencode/GRCh37.p13.reorder/gencode.v19.annotation.gtf.map",
      dexseq_gff     => "/data/cqs/references/gencode/GRCh37.p13.reorder/gencode.v19.annotation.dexseq.gff",
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
      biomart_host      => "www.ensembl.org",
      biomart_dataset   => "hsapiens_gene_ensembl",
      biomart_symbolKey => "hgnc_symbol",
      annotation_genes_shift => 1000, #including possible TF range
      annotation_genes_add_chr => 1, #add chr to chromosome
    }
  );
}

sub get_gencode_hg38_genome {
  my ($userdef, $gtfVersion, $genome_ver, $star_ver) = @_;
  if(!defined $genome_ver){
    $genome_ver = "GRCh38.p13";
  }

  if(!defined $star_ver){
    $star_ver="2.7.8a";
  }
  return merge_hash_right_precedent(
    common_hg38_genome($userdef),
    {
      #genome database
      star_index     => "/data/cqs/references/gencode/$genome_ver/STAR_index_${star_ver}_${gtfVersion}_sjdb100",
      transcript_gtf => "/data/cqs/references/gencode/$genome_ver/gencode.${gtfVersion}.annotation.gtf",
      name_map_file  => "/data/cqs/references/gencode/$genome_ver/gencode.${gtfVersion}.annotation.gtf.map",
      gene_bed       => "/data/cqs/references/gencode/$genome_ver/gencode.${gtfVersion}.annotation.gtf.map.bed",
      dexseq_gff     => "/data/cqs/references/gencode/$genome_ver/gencode.${gtfVersion}.annotation.dexseq.gff",
      fasta_file => "/data/cqs/references/gencode/$genome_ver/GRCh38.primary_assembly.genome.fa",
      software_version => {
        genome => "Gencode $genome_ver",
        gtf => "Gencode ${gtfVersion}",
      }
    }
  );
}

sub gencode_hg38_genome {
  my ($userdef) = @_;
  return(get_gencode_hg38_genome($userdef, "v38"));
}

sub gencode_hg38_genome_v47 {
  my ($userdef) = @_;
  return(get_gencode_hg38_genome($userdef, "v47", "GRCh38.p14", "2.7.11b"));
}

sub gencode_hg38_genome_v48 {
  my ($userdef) = @_;
  return(get_gencode_hg38_genome($userdef, "v48", "GRCh38.p14", "2.7.11b"));
}

sub gencode_hg38_genome_v47_LncBookv2_1 {
  my ($userdef) = @_;
  return(get_gencode_hg38_genome($userdef, "v47.LncBookv2_1", "GRCh38.p14", "2.7.11b"));
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

sub add_mouse_gsea {
  my $def = shift;
  $def->{gsea_chip} = undef;
  $def->{use_mouse_gsea_db} = 1;

  #my $mouse_gsea_db_ver = "v2022.1.Mm";
  my $mouse_gsea_db_ver = "v2025.1.Mm";

  return merge_hash_right_precedent($def, {
    perform_gsea => 1,
    gsea_jar => "gsea-cli.sh",
    gsea_db => "/data/cqs/references/gsea/msigdb_${mouse_gsea_db_ver}_GMTs",
    gsea_categories => "'mh.all.$mouse_gsea_db_ver.symbols.gmt', 'm2.all.$mouse_gsea_db_ver.symbols.gmt', 'm5.all.$mouse_gsea_db_ver.symbols.gmt'",
    software_version => {
      "GSEA_DB" => ["${mouse_gsea_db_ver}"],
    }
  });
}

sub common_mm10_genome {
  my $result = merge_hash_right_precedent(mm10_options(), {
    webgestalt_organism => "mmusculus",
    perform_webgestalt  => 1,
    dbsnp               => "/data/cqs/references/dbsnp/mouse_10090_b150_GRCm38.p4.vcf.gz",
    annovar_buildver    => "mm10",
    annovar_param       => "-protocol refGene -operation g --remove",
    annovar_db          => "/data/cqs/references/annovar/mousedb/",
  });

  $result = add_human_gsea($result, "Mouse");

  return($result);
}

sub get_gencode_mm10_genome {
  my $gtfVersion = shift;
  return merge_hash_right_precedent(
    merge_hash_right_precedent( global_definition(), common_mm10_genome() ),
    {
      #genome database
      fasta_file     => "/data/cqs/references/gencode/GRCm38.p6/GRCm38.primary_assembly.genome.fa",
      star_index     => "/data/cqs/references/gencode/GRCm38.p6/STAR_index_2.7.8a_${gtfVersion}_sjdb100",
      transcript_gtf => "/data/cqs/references/gencode/GRCm38.p6/gencode.${gtfVersion}.annotation.gtf",
      name_map_file  => "/data/cqs/references/gencode/GRCm38.p6/gencode.${gtfVersion}.annotation.gtf.map",
      utr3_bed => "/data/cqs/references/gencode/GRCm38.p6/gencode.${gtfVersion}.annotation_3utr.bed",      
      dexseq_gff     => "/data/cqs/references/gencode/GRCm38.p6/gencode.${gtfVersion}.annotation.dexseq.gff",
      annotation_genes_add_chr => 1,
      software_version => {
        genome => "Gencode GRCm38.p6",
        gtf => "Gencode ${gtfVersion}",
      }
    }
  );
}

sub gencode_mm10_genome_vM25 {
  return(get_gencode_mm10_genome("vM25"));
}

sub gencode_mm10_genome_vM24 {
  return(get_gencode_mm10_genome("vM24"));
}

sub gencode_mm10_genome {
  return(get_gencode_mm10_genome("vM25"));
}

sub ensembl_Rnor_6_genome {
  my $result = merge_hash_right_precedent(
    global_definition(), 
    {
      perform_webgestalt  => 0,

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

  $result = add_human_gsea($result, "Rat");

  return($result);
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
      docker_command            => "singularity exec -e /data/cqs/softwares/singularity/cqs-rnaseq.simg ",
      fasta_file => "/data/cqs/references/ensembl/Mmul_10/Macaca_mulatta.Mmul_10.dna.primary_assembly.fa",
      star_index     => "/data/cqs/references/ensembl/Mmul_10/STAR_index_2.7.1a_v99_sjdb100",
      transcript_gtf => "/data/cqs/references/ensembl/Mmul_10/Macaca_mulatta.Mmul_10.99.chr.gtf",
      name_map_file  => "/data/cqs/references/ensembl/Mmul_10/Macaca_mulatta.Mmul_10.99.chr.gtf.map",
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
      docker_command            => "singularity exec -e /data/cqs/softwares/singularity/cqs-rnaseq.simg ",

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

sub performRNASeq_gencode_hg38_v47 {
  my ( $userdef, $perform ) = @_;
  my $def = merge_hash_left_precedent( $userdef, gencode_hg38_genome_v47($userdef) );
  my $config = performRNASeq( $def, $perform );
  return $config;
}

sub performRNASeq_gencode_hg38_v48 {
  my ( $userdef, $perform ) = @_;
  my $def = merge_hash_left_precedent( $userdef, gencode_hg38_genome_v48($userdef) );
  my $config = performRNASeq( $def, $perform );
  return $config;
}

sub performRNASeq_gencode_hg38_v47_LncBookv2_1 {
  my ( $userdef, $perform ) = @_;
  my $def = merge_hash_left_precedent( $userdef, gencode_hg38_genome_v47_LncBookv2_1($userdef) );
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

  if(getValue($def, "perform_gsea")){
    if(getValue($def, "use_mouse_gsea_db", 0)){
      $def = add_mouse_gsea($def);
    }
  }
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

sub ncbi_Sscrofa11_genome {
  my $result = merge_hash_right_precedent(
    global_definition(),
    {
      #genome database
      fasta_file => "/data/cqs/references/swine_pig/ncbi/GCF_000003025.6/GCF_000003025.6_Sscrofa11.1_genomic.fna",

      star_index          => "/data/cqs/references/swine_pig/ncbi/GCF_000003025.6/STAR_index_2.7.11b_v106_sjdb100",
      transcript_gtf      => "/data/cqs/references/swine_pig/ncbi/GCF_000003025.6/genomic.v106.gtf",
      name_map_file       => "/data/cqs/references/swine_pig/ncbi/GCF_000003025.6/genomic.v106.gtf.map",
      featureCount_option => "-g gene",
      software_version => {
        genome => "NCBI Sscrofa11.1",
        gtf => "Refseq v106",
      },
    
      # Asuming pig gene symbol is human gene symbol now
      annovar_param       => "-protocol refGene,avsnp151,cosmic70 -operation g,f,f --remove",
      annovar_db          => "/data/cqs/references/annovar/humandb/",

      perform_webgestalt  => 1,
      webgestalt_organism => "hsapiens",
    }
  );
  # There is no pig to human conversion chip file, we will assume it as human gene symbol already.
  $result = add_human_gsea($result, "Human");
  return($result);
}

sub performRNASeq_ncbi_Sscrofa11 {
  my ( $userdef, $perform ) = @_;
  my $def = merge_hash_left_precedent( $userdef, ncbi_Sscrofa11_genome() );
  my $config = performRNASeq( $def, $perform );
  return $config;
}

1;

