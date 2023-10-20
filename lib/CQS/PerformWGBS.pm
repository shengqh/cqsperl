#!/usr/bin/perl
package CQS::PerformWGBS;

use strict;
use warnings;
use Pipeline::WGBS;
use CQS::Global;
use CQS::ConfigUtils;

require Exporter;
our @ISA = qw(Exporter);

our %EXPORT_TAGS = (
  'all' => [
    qw(
      performWGBS_gencode_hg38
      )
  ]
);

our @EXPORT = ( @{ $EXPORT_TAGS{'all'} } );

our $VERSION = '0.01';

sub global_definition {
  my $result = merge_hash_right_precedent(global_options(), {
    dnmtools_docker_command => singularity_prefix() . " /data/cqs/softwares/singularity/cqs-dnmtools.sif ",
  });

  return($result);
}

sub gencode_hg38_genome {
  return merge_hash_right_precedent(global_definition(), {
    abismal_index       => "/data/cqs/references/gencode/GRCh38.p13/abismal_index/GRCh38_chrm.abismalidx",
    chr_dir             => "/data/cqs/references/gencode/GRCh38.p13/abismal_index/GRCh38_chrm.fa",
    chr_size_file       => "/data/cqs/references/gencode/GRCh38.p13/abismal_index/GRCh38_chrm.sizes",
    annovar_buildver    => "hg38",
    annovar_db          => "/data/cqs/references/annovar/humandb",
    annovar_param       => "--otherinfo -protocol refGene,avsnp150,cosmic70, -operation g,f,f --remove",
    annovar_docker_command => singularity_prefix() . " /data/cqs/softwares/singularity/cqs-exomeseq.simg ",
    HOMER_perlFile      => "/data/cqs/softwares/homer/bin/findMotifsGenome.pl",
    addqual_perlFile    => "/data/cqs/softwares/ngsperl/lib/Methylation/add_qual.pl",
    picard              => "/data/cqs/softwares/picard.jar",
    interval_list       => "/nobackup/brown_lab/projects/20231006_10473_DNAMethyl_hg38/covered_targets_Twist_Methylome_hg38_annotated_collapsed.intervals",
    is_paired_end       => 1,
    webgestalt_organism => "hsapiens",
    wgbs_r_docker_command => singularity_prefix() . " /data/cqs/softwares/singularity/wgbs_r.1.1.sif ",
  });
}

sub performWGBS_gencode_hg38 {
  my ( $userdef, $perform ) = @_;
  my $def = merge_hash_left_precedent( $userdef, gencode_hg38_genome() );
  my $config = performWGBS( $def, $perform );
  return $config;
}


1;
