#!/usr/bin/perl
package CQS::PerformNextflowMethylation;

use strict;
use warnings;
use CQS::Global;
use CQS::ConfigUtils;
use Pipeline::NextflowMethylation;

require Exporter;
our @ISA = qw(Exporter);

our %EXPORT_TAGS = (
  'all' => [
    qw(
        performNextflowMethylation_ucsc_hg38_twist_v4_1_0
        performNextflowMethylation_ucsc_mm10_twist_v4_1_0
    )
  ]
);

our @EXPORT = ( @{ $EXPORT_TAGS{'all'} } );

our $VERSION = '0.01';


sub get_NextflowMethylation {
  my ( $userdef, $methylseq_ver ) = @_;

  # Nextflow run mode configuration:
  #
  # local mode: Analysis runs sequentially on a single machine without using SLURM.
  #             Can be submitted to SLURM as a single job that runs all tasks on one node.
  #
  # slurm mode: Nextflow submits each task as separate SLURM jobs for parallel execution.
  #             The main script must be run directly on the gateway node (cqs4, e.g., nohup bash script.pbs | tee log.txt).
  #             Do NOT submit the main script to SLURM, as cluster nodes cannot submit sub-jobs to SLURM.
  my $nextflow_run_mode = getValue( $userdef, "nextflow_run_mode", "slurm" );

  my $res = merge_hash_left_precedent(
    $userdef,
    { software_version => { methylseq => $methylseq_ver, },

      nextflow_run_mode => $nextflow_run_mode,
      nextflow_config   => "/nobackup/h_cqs/shengq2/program/cqsperl/config/nextflow/${nextflow_run_mode}.config",
      nextflow_main_nf  => "/data/cqs/softwares/nextflow/methylseq-${methylseq_ver}/main.nf",

      # If local, sh_direct should be 0, then the pbs can be submitted to slurm directly.
      # If slurm, sh_direct should be "nohup", then we can run the .sh file with nohup to run all pbs files and then nextflow will submit each step to slurm.
      sh_direct => $nextflow_run_mode eq "local" ? 0 : "nohup",

      probe_locus_file => "/data/cqs/references/methylation/illumina/20240618_illumina_cg_id/illumina.hg38.cg_id.unique.one_based.csv",

      igenomes_base => "/data/cqs/references/igenomes"
    }
  );
  return $res;
} ## end sub get_NextflowMethylation


sub performNextflowMethylation_ucsc_hg38_twist_v4_1_0 {
  my ( $userdef, $perform ) = @_;

  my $def = merge_hash_left_precedent(
    get_NextflowMethylation( $userdef, "4.1.0" ),
    { software_version => { genome => "hg38", },
      genome           => "hg38",
      convered_bed     => "/data/cqs/references/methylation/twist/covered_targets_Twist_Methylome_hg38_annotated_collapsed.bed",
    }
  );

  my $config = performNextflowMethylation( $def, $perform );
  return $config;
} ## end sub performNextflowMethylation_ucsc_hg38_twist_v4_1_0


sub performNextflowMethylation_ucsc_mm10_twist_v4_1_0 {
  my ( $userdef, $perform ) = @_;

  my $def = merge_hash_left_precedent(
    get_NextflowMethylation( $userdef, "4.1.0" ),
    { software_version => { genome => "mm10", },
      genome           => "mm10",
      convered_bed     => "/data/cqs/references/ucsc/mm10/Target_bases_covered_by_probes_Methyl_Twist_Mouse_CpG_Islands_MTE-92874077_mm10_230825155415.bed",
    }
  );

  my $config = performNextflowMethylation( $def, $perform );
  return $config;
} ## end sub performNextflowMethylation_ucsc_mm10_twist_v4_1_0

1;
