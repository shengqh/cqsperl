#!/usr/bin/perl
use strict;
use warnings;

use CQS::ClassFactory;
use CQS::FileUtils;
use Data::Dumper;
use Pipeline::SmallRNAUtils;
use CQS::PerformRNAseq;

my $def = {
  task_name => "tcga_brca",

  email      => "quanhu.sheng.1\@vumc.org",
  target_dir => create_directory_or_die("/scratch/cqs/shengq2/jennifer/20190510_johanna_tcga_brca_deseq2"),

  perform_preprocessing => 0,
  perform_mapping => 0,
  perform_counting => 0,
  perform_count_table => 0,
  perform_correlation => 0,
  perform_proteincoding_gene => 0,
  perform_webgestalt => 1,
  perform_gsea => 1,
  perform_report => 0,
  outputPdf => 1,
  outputPng => 0,
  outputTIFF => 0,

  count_file => "/scratch/cqs/shengq2/guoyan/eqtl/prepareRnaseq/result/BRCA/BRCA.rnaseq2.count.tsv",
  deseq2_groups => {
    PTEN_Status_Deficient => [qw(TCGA-D8-A1XK-01
TCGA-S3-AA15-01
TCGA-E2-A1LK-01
TCGA-EW-A1OW-01
TCGA-E2-A1LG-01
TCGA-C8-A27B-01
TCGA-LL-A8F5-01
TCGA-E2-A1LS-01
TCGA-E9-A22G-01
TCGA-EW-A1P8-01
TCGA-AO-A124-01
TCGA-OL-A66I-01
TCGA-A7-A13D-01
TCGA-AN-A0AL-01
TCGA-E2-A1B6-01
TCGA-A7-A6VV-01
TCGA-D8-A27F-01
)],
    PTEN_Status_Proficient => [qw(TCGA-E2-A1AZ-01
TCGA-AR-A1AJ-01
TCGA-AR-A251-01
TCGA-D8-A143-01
TCGA-BH-A18G-01
TCGA-A2-A0EQ-01
TCGA-A7-A0DA-01
TCGA-A2-A04U-01
TCGA-BH-A0B9-01
TCGA-AN-A0FJ-01
TCGA-EW-A1P4-01
TCGA-E9-A243-01
TCGA-A2-A3XU-01
TCGA-EW-A1PB-01
TCGA-A7-A26G-01
TCGA-AQ-A54N-01
)],
    PTEN_Status_NoBRCAmuts_Deficient => [qw(TCGA-D8-A1XK-01
TCGA-S3-AA15-01
TCGA-E2-A1LK-01
TCGA-EW-A1OW-01
TCGA-E2-A1LG-01
TCGA-C8-A27B-01
TCGA-LL-A8F5-01
TCGA-E2-A1LS-01
TCGA-E9-A22G-01
TCGA-EW-A1P8-01
TCGA-OL-A66I-01
TCGA-A7-A13D-01
TCGA-AN-A0AL-01
TCGA-E2-A1B6-01
TCGA-A7-A6VV-01
TCGA-D8-A27F-01
)],
    PTEN_Status_NoBRCAmuts_Proficient => [qw(TCGA-E2-A1AZ-01
TCGA-AR-A251-01
TCGA-D8-A143-01
TCGA-BH-A18G-01
TCGA-A2-A0EQ-01
TCGA-A7-A0DA-01
TCGA-A2-A04U-01
TCGA-BH-A0B9-01
TCGA-AN-A0FJ-01
TCGA-EW-A1P4-01
TCGA-E9-A243-01
TCGA-A2-A3XU-01
TCGA-EW-A1PB-01
TCGA-AQ-A54N-01
)],
  },
  pairs => {
    PTEN_Status => ["PTEN_Status_Deficient", "PTEN_Status_Proficient"],
    PTEN_Status_NoBRCAmuts => ["PTEN_Status_NoBRCAmuts_Deficient", "PTEN_Status_NoBRCAmuts_Proficient"],
  },
};

my $config = performRNASeq_gatk_b37( $def, 1 );

1;
