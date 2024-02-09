#!/usr/bin/perl
use strict;
use warnings;

use CQS::Global;
use CQS::FileUtils;
use CQS::SystemUtils;
use CQS::ConfigUtils;
use CQS::ClassFactory;
use Pipeline::PeakPipelineUtils;

my $target_dir = create_directory_or_die("/nobackup/h_cqs/shengq2/temp/20240208_bamplot");
my $task_name = "bamplot";

my $config = {
  general => { 
    task_name => $task_name,
    email => 'quanhu.sheng.1@vumc.org',
    docker_command => global_options()->{"bamplot_docker_command"},
  },
  #file_def.py -i /nobackup/brown_lab/projects/20240122_RB10758_ATAC_encode_hg38/encode_atacseq_local_croo/result/ -f "*.no_chrM_MT.bam" -n "VSMC_(.+)_clip" -r
  files => {
    'HGPS_1' => [ '/nobackup/brown_lab/projects/20240122_RB10758_ATAC_encode_hg38/encode_atacseq_local_croo/result/HGPS/align/rep1/VSMC_HGPS_1_clipped.1.srt.nodup.no_chrM_MT.bam' ],
    'HGPS_2' => [ '/nobackup/brown_lab/projects/20240122_RB10758_ATAC_encode_hg38/encode_atacseq_local_croo/result/HGPS/align/rep2/VSMC_HGPS_2_clipped.1.srt.nodup.no_chrM_MT.bam' ],
    'HGPS_3' => [ '/nobackup/brown_lab/projects/20240122_RB10758_ATAC_encode_hg38/encode_atacseq_local_croo/result/HGPS/align/rep3/VSMC_HGPS_3_clipped.1.srt.nodup.no_chrM_MT.bam' ],
    'WT_1' => [ '/nobackup/brown_lab/projects/20240122_RB10758_ATAC_encode_hg38/encode_atacseq_local_croo/result/WT/align/rep1/VSMC_WT_1_clipped.1.srt.nodup.no_chrM_MT.bam' ],
    'WT_2' => [ '/nobackup/brown_lab/projects/20240122_RB10758_ATAC_encode_hg38/encode_atacseq_local_croo/result/WT/align/rep2/VSMC_WT_2_clipped.1.srt.nodup.no_chrM_MT.bam' ],
    'WT_3' => [ '/nobackup/brown_lab/projects/20240122_RB10758_ATAC_encode_hg38/encode_atacseq_local_croo/result/WT/align/rep3/VSMC_WT_3_clipped.1.srt.nodup.no_chrM_MT.bam' ],
  },
};

my $def = {
  task_name => $task_name,
  
  # you can use your own gff file which can contains specific region names, such as gene names
  bamplot_gff => "/nobackup/h_cqs/softwares/cqsperl/data/bamplot.gff",
  # or you can use annotation_locus directly without bamplot_gff
  #annotation_locus  => ["chr1:156,099,034-156,139,293" ],

  bamplot_option  => "-g HG38 -y uniform -r --save-temp",
  bamplot_draw_by_r => 1,
  bamplot_draw_by_r_width => 10,
  bamplot_draw_by_r_height => 8,
};

my $summary = [];
add_bamplot_by_gff($config, $def, $summary, $target_dir, $task_name, "files");

performTask($config, "bamplot");

1;
