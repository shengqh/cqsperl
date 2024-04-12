#!/usr/bin/perl
use strict;
use warnings;

use CQS::Global;
use CQS::ClassFactory;
use CQS::FileUtils;
use Data::Dumper;
use Pipeline::Qiime2;
use File::Basename;
use Spreadsheet::XLSX;

my $def = {
  task_name => "20240327_qiime2",

  email      => "quanhu.sheng.1\@vumc.org",
  target_dir => create_directory_or_die("/nobackup/h_cqs/shengq2/temp/20240327_qiime2"),

  qiime2_docker_command => singularity_prefix() . " /data/cqs/softwares/singularity/qiime2.simg",

  perform_qc_check_fastq_duplicate => 0,
  perform_preprocessing      => 1,
  #perform_cutadapt_test      => 1,

  perform_cutadapt           => 0,
  cutadapt_option            => "-q 20 -a AGATCGGAAGAG -A AGATCGGAAGAG",
  min_read_length            => 30,
  is_pairend                 => 1,

  perform_mapping            => 0,
  perform_counting           => 0,
  perform_count_table        => 0,
  perform_correlation        => 0,
  perform_proteincoding_gene => 0,
  perform_webgestalt         => 0,
  perform_gsea               => 0,
  perform_report             => 0,
  outputPdf                  => 1,
  outputPng                  => 1,
  outputTIFF                 => 0,

  files => {
    #file_def.py -i /data/jbrown_lab/2021/20210630_Flynn_M02127_Run498 -r -f "*.gz" -d 1 -n "(.+?)_L001"
    'VUMCRF001' => [ '/data/jbrown_lab/2021/20210630_Flynn_M02127_Run498/VUMCRF001_L001-ds.3fe940152b9546c988d059862b4d4be7/VUMCRF001_S1_L001_R1_001.fastq.gz', '/data/jbrown_lab/2021/20210630_Flynn_M02127_Run498/VUMCRF001_L001-ds.3fe940152b9546c988d059862b4d4be7/VUMCRF001_S1_L001_R2_001.fastq.gz' ],
    'VUMCRF002' => [ '/data/jbrown_lab/2021/20210630_Flynn_M02127_Run498/VUMCRF002_L001-ds.0b3b426ca0f142438766927852833b64/VUMCRF002_S2_L001_R1_001.fastq.gz', '/data/jbrown_lab/2021/20210630_Flynn_M02127_Run498/VUMCRF002_L001-ds.0b3b426ca0f142438766927852833b64/VUMCRF002_S2_L001_R2_001.fastq.gz' ],
    'VUMCRF003' => [ '/data/jbrown_lab/2021/20210630_Flynn_M02127_Run498/VUMCRF003_L001-ds.292a0e0258b449889d3367744413179d/VUMCRF003_S3_L001_R1_001.fastq.gz', '/data/jbrown_lab/2021/20210630_Flynn_M02127_Run498/VUMCRF003_L001-ds.292a0e0258b449889d3367744413179d/VUMCRF003_S3_L001_R2_001.fastq.gz' ],
  },

  #classifier_file => "/data/cqs/references/qiime2/silva-138-99-nb-classifier.qza",
  classifier_file => "/data/cqs/references/qiime2/gg-13-8-99-nb-classifier.qza",

  groups_pattern => "(VUM|WaterNeg|Blank|DNA_ExtCtrl|MockZymoPos)",
  show_label_PCA => 0,
  use_tmp_folder => 0,
  max_thread => 24,

  perform_preprocessing => 0,
  
  perform_qiime2_cutadapt => 1,
  #https://amb-express.springeropen.com/articles/10.1186/s13568-018-0713-1/tables/1
  # qiime2_cutadapt_front_f => "GTACTCCTACGGGAGGCAGCA",
  # qiime2_cutadapt_front_r => "GTGGACTACHVGGGTWTCTAAT",
  qiime2_cutadapt_front_f => "GTGCCAGCMGCCGCGGTAA",
  qiime2_cutadapt_front_r => "GGACTACHVGGGTWTCTAAT",
  # qiime2_cutadapt_front_f => "GTGARTCATCGAATCTTTG",
  # qiime2_cutadapt_front_r => "TCCTCCGCTTATTGATATGC",

  #determine following dada2 options based on the quality score distribution from .trimmed.qzv
  "p-trim-left-f" => 13,
  "p-trim-left-r" => 13,
  "p-trunc-len-f" => 230,
  "p-trunc-len-r" => 160,

  sh_direct => 1,
  add_folder_index => 1,
};

my $vum_map = {};
my $files = $def->{files};
for my $fname (sort keys %$files){
  if ($fname !~ /VUM/){
    next
  }

  my $index = $fname;
  $index =~ s/^.+?F//g;
  $index = int($index);
  $vum_map->{$index} = $fname;
}

my $comparison_file = dirname(__FILE__) . '/Microbiome_comparisons.xlsx';
my $workbook = Spreadsheet::XLSX->new($comparison_file);
my $sheet = $workbook->worksheet('Sheet1');

sub get_samples{
  my ($sample, $vum_map) = @_;
  my @samples = split(',\s*', $sample);
  my $sample_index = [];
  for my $samp (@samples){
    if (length($samp) <= 4) {
      push(@$sample_index, int($samp));
    }elsif(length($samp) == 6){
      my $s1 = substr($samp, 0, 3);
      my $s2 = substr($samp, 3, 3);
      push(@$sample_index, int($s1));
      push(@$sample_index, int($s2));
    }elsif($samp =~ /\-/){
      my @fromto = split('\-', $samp);
      my $from = int($fromto[0]);
      my $to = int($fromto[1]);
      for my $s1 ($from .. $to){
        push(@$sample_index, $s1);
      }
    }else{
      die $samp;
    }
  }

  my $result = [];
  for my $index (@$sample_index){
    if(not defined $vum_map->{$index}){
      warn("$index not in sample list");
    }else{
      push(@$result, $vum_map->{$index});
    }
  }
  return($result);
}

my $pairs = {};
for my $row (1 .. $sheet->{MaxRow}){
  my $v1 = $sheet->{Cells}[$row][0]->{Val};
  my $case = $sheet->{Cells}[$row][6]->{Val};
  my $cases = get_samples($case,$vum_map);
  my $control = $sheet->{Cells}[$row][7]->{Val};
  my $controls = get_samples($control,$vum_map);

  $v1 =~ s/\s+/_/g;

  $pairs->{$v1} = {
    cases => $cases,
    controls => $controls
  };
}

$def->{pairs} = $pairs;

my $config = performQiime2( $def, 1 );
#performTask($config, "qiime2_composition");

# $def->{target_dir} = "/workspace/shengq2/20210707_qiime2";
# $def->{perform_qiime2_cutadapt} = 1;
# my $config = performQiime2( $def, 0 );
# #print(Dumper($config->{groups}));
# performConfig($config);

# $def->{target_dir} = "/workspace/shengq2/20210707_qiime2.v2";
# $def->{perform_qiime2_cutadapt} = 0;
# $config = performQiime2( $def, 0 );
# performConfig($config);

1;
