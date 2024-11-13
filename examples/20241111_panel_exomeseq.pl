#!/usr/bin/perl
use strict;
use warnings;

use CQS::ClassFactory;
use CQS::FileUtils;
use CQS::SystemUtils;
use CQS::ConfigUtils;
use Data::Dumper;
use Scalar::Util qw(looks_like_number);

#BiocManager::install('vplagnol/ExomeDepth')
#BiocManager::install('reshape')

my $def = { 
  task_name => "panel_test",
  email     => "quanhu.sheng.1\@vumc.org",
  target_snp_bed => "/nobackup/h_cqs/yangj22/DavidHaas/P8986_DH_20241101/VUMC_Vantage_PGx_TE-96296782_hg38/Probes_merged_ok_VUMC_Vantage_PGx_TE-96296782_hg38_230919161009_forbamcounts.bed",
  #decon_path => "/nobackup/h_cqs/yangj22/DavidHaas/P11320_MP_20240531/DECoN/Linux",
  decon_path => "/nobackup/h_cqs/shengq2/temp/panel_exomeseq/DECoN/Linux",
  bam_folder => "/nobackup/h_cqs/yangj22/DavidHaas/P11320_MP_20240531/bwa_g4_refine/result",
};

my $config = {
  general => {
    email => $def->{email},
    task_name => $def->{task_name},
  },
#   "T01_rs_to_bed" => {
#     class                => "CQS::ProgramWrapperOneToOne",
#     perform              => 1,
#     target_dir           => "/nobackup/h_cqs/shengq2/temp/panel_exomeseq/T01_rs_to_bed",
#     program              => "",
#     check_program        => 0,
#     option               => "
# echo __FILE__ > __NAME__.txt

# bigBedNamedItems -nameFile http://hgdownload.soe.ucsc.edu/gbdb/hg38/snp/dbSnp155.bb __NAME__.txt __NAME__.tmp.bed

# grep -v '_alt' __NAME__.tmp.bed > __NAME__.bed

# rm -f __NAME__.txt __NAME__.tmp.bed
# ",
#     parameterSampleFile1 => {
#       $def->{task_name} => "rs11591147 rs13078881 rs3093662 rs4343 rs1803274"
#     },
#     output_file_ext     => ".bed",
#     sh_direct            => 0,
#     no_output           => 1,
#     pbs                  => {
#       "nodes"    => "1:ppn=1",
#       "walltime" => "1",
#       "mem"      => "20gb"
#     },
#   },
  "T02_DECoN_counts" => {
    class                => "CQS::ProgramWrapperOneToOne",
    perform              => 1,
    target_dir           => "/nobackup/h_cqs/shengq2/temp/panel_exomeseq/T02_DECoN_counts",
    program              => "",
    check_program        => 0,
    option               => "
ls __FILE__ > __NAME__.bams

Rscript __parameterFile1__/ReadInBams.R \\
  --bams __NAME__.bams \\
  --bed __parameterFile2__ \\
  --out __NAME__

rm -f __NAME__.bams  
",
    parameterSampleFile1 => {
      'P11320_MP_001' => [ '/nobackup/h_cqs/yangj22/DavidHaas/P11320_MP_20240531/bwa_g4_refine/result/P11320_MP_001.rmdup.recal.bam' ],
      'P11320_MP_002' => [ '/nobackup/h_cqs/yangj22/DavidHaas/P11320_MP_20240531/bwa_g4_refine/result/P11320_MP_002.rmdup.recal.bam' ],
    },
    parameterFile1 => $def->{decon_path},
    parameterFile2 => $def->{target_snp_bed},
    output_file_ext     => ".RData",
    sh_direct            => 0,
    no_output           => 1,
    pbs                  => {
      "nodes"    => "1:ppn=1",
      "walltime" => "1",
      "mem"      => "20gb"
    },
  },
  "T03_DECoN_makeCNVcalls" => {
    class                => "CQS::ProgramWrapper",
    perform              => 1,
    target_dir           => "/nobackup/h_cqs/shengq2/temp/panel_exomeseq/T03_DECoN_makeCNVcalls",
    program              => "",
    check_program        => 0,
    option               => "
Rscript /home/shengq2/program/ngsperl/lib/Panel/CombineDECoN.R \\
  --rdatas __FILE__ \\
  --out __NAME__

Rscript __parameterFile2__/makeCNVcalls.R \\
--RData __NAME__.RData \\
--transProb 0.01 \\
--plot None \\
--out __NAME__.final 
",
    parameterSampleFile1_ref => "T02_DECoN_counts",
    parameterFile1 => $def->{decon_path},
    output_file_ext => ".final_all.txt",
    sh_direct => 0,
    no_output => 1,
    no_prefix => 1,
    pbs => {
      "nodes"    => "1:ppn=1",
      "walltime" => "1",
      "mem"      => "20gb"
    },
  }
  # "R02_summary" => {
  #   class                => "CQS::UniqueR",
  #   perform              => 1,
  #   target_dir           => "/nobackup/h_cqs/jennifer_pietenpol_projects/20241011_PheWAS_of_immune_checkpoint_genes/R02_summary",
  #   option               => "",
  #   rtemplate => "/home/shengq2/program/collaborations/brian_lehmann/20241011_PheWAS_of_immune_checkpoint_genes/summary.r",
  #   parameterFile1 => $phecode_map_file,
  #   parameterSampleFile1_ref => "R01_linear_association_analysis",
  #   output_file_ext     => ".linear_association.csv",
  #   sh_direct            => 0,
  #   no_output           => 1,
  #   pbs                  => {
  #     "nodes"    => "1:ppn=1",
  #     "walltime" => "1",
  #     "mem"      => "5gb"
  #   },
  # },
};

performConfig($config);
#performTask($config, "R02_summary");

1;
