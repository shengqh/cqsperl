#!/usr/bin/env perl
use strict;
use warnings;
use File::Basename;
use File::Spec;
use Getopt::Long;
use CQS::FileUtils;
use CQS::ClassFactory;

my $target_dir = create_directory_or_die("/data/cqs/references/low_coverage_wgs/hg38/1000g_snp");
my $config = {
  "general" => {
    email => 'quanhu.sheng.1@vumc.org',
    task_name => "bcftools",
    glimpse_docker_command => "singularity exec -c -e /data/cqs/softwares/singularity/glimpse.sif ",
  },
  files => {
    'chr1' => [ '/data/cqs/references/low_coverage_wgs/hg38/1000g/CCDG_14151_B01_GRM_WGS_2020-08-05_chr1.filtered.shapeit2-duohmm-phased.vcf.gz' ],
    'chr10' => [ '/data/cqs/references/low_coverage_wgs/hg38/1000g/CCDG_14151_B01_GRM_WGS_2020-08-05_chr10.filtered.shapeit2-duohmm-phased.vcf.gz' ],
    'chr11' => [ '/data/cqs/references/low_coverage_wgs/hg38/1000g/CCDG_14151_B01_GRM_WGS_2020-08-05_chr11.filtered.shapeit2-duohmm-phased.vcf.gz' ],
    'chr12' => [ '/data/cqs/references/low_coverage_wgs/hg38/1000g/CCDG_14151_B01_GRM_WGS_2020-08-05_chr12.filtered.shapeit2-duohmm-phased.vcf.gz' ],
    'chr13' => [ '/data/cqs/references/low_coverage_wgs/hg38/1000g/CCDG_14151_B01_GRM_WGS_2020-08-05_chr13.filtered.shapeit2-duohmm-phased.vcf.gz' ],
    'chr14' => [ '/data/cqs/references/low_coverage_wgs/hg38/1000g/CCDG_14151_B01_GRM_WGS_2020-08-05_chr14.filtered.shapeit2-duohmm-phased.vcf.gz' ],
    'chr15' => [ '/data/cqs/references/low_coverage_wgs/hg38/1000g/CCDG_14151_B01_GRM_WGS_2020-08-05_chr15.filtered.shapeit2-duohmm-phased.vcf.gz' ],
    'chr16' => [ '/data/cqs/references/low_coverage_wgs/hg38/1000g/CCDG_14151_B01_GRM_WGS_2020-08-05_chr16.filtered.shapeit2-duohmm-phased.vcf.gz' ],
    'chr17' => [ '/data/cqs/references/low_coverage_wgs/hg38/1000g/CCDG_14151_B01_GRM_WGS_2020-08-05_chr17.filtered.shapeit2-duohmm-phased.vcf.gz' ],
    'chr18' => [ '/data/cqs/references/low_coverage_wgs/hg38/1000g/CCDG_14151_B01_GRM_WGS_2020-08-05_chr18.filtered.shapeit2-duohmm-phased.vcf.gz' ],
    'chr19' => [ '/data/cqs/references/low_coverage_wgs/hg38/1000g/CCDG_14151_B01_GRM_WGS_2020-08-05_chr19.filtered.shapeit2-duohmm-phased.vcf.gz' ],
    'chr2' => [ '/data/cqs/references/low_coverage_wgs/hg38/1000g/CCDG_14151_B01_GRM_WGS_2020-08-05_chr2.filtered.shapeit2-duohmm-phased.vcf.gz' ],
    'chr20' => [ '/data/cqs/references/low_coverage_wgs/hg38/1000g/CCDG_14151_B01_GRM_WGS_2020-08-05_chr20.filtered.shapeit2-duohmm-phased.vcf.gz' ],
    'chr21' => [ '/data/cqs/references/low_coverage_wgs/hg38/1000g/CCDG_14151_B01_GRM_WGS_2020-08-05_chr21.filtered.shapeit2-duohmm-phased.vcf.gz' ],
    'chr22' => [ '/data/cqs/references/low_coverage_wgs/hg38/1000g/CCDG_14151_B01_GRM_WGS_2020-08-05_chr22.filtered.shapeit2-duohmm-phased.vcf.gz' ],
    'chr3' => [ '/data/cqs/references/low_coverage_wgs/hg38/1000g/CCDG_14151_B01_GRM_WGS_2020-08-05_chr3.filtered.shapeit2-duohmm-phased.vcf.gz' ],
    'chr4' => [ '/data/cqs/references/low_coverage_wgs/hg38/1000g/CCDG_14151_B01_GRM_WGS_2020-08-05_chr4.filtered.shapeit2-duohmm-phased.vcf.gz' ],
    'chr5' => [ '/data/cqs/references/low_coverage_wgs/hg38/1000g/CCDG_14151_B01_GRM_WGS_2020-08-05_chr5.filtered.shapeit2-duohmm-phased.vcf.gz' ],
    'chr6' => [ '/data/cqs/references/low_coverage_wgs/hg38/1000g/CCDG_14151_B01_GRM_WGS_2020-08-05_chr6.filtered.shapeit2-duohmm-phased.vcf.gz' ],
    'chr7' => [ '/data/cqs/references/low_coverage_wgs/hg38/1000g/CCDG_14151_B01_GRM_WGS_2020-08-05_chr7.filtered.shapeit2-duohmm-phased.vcf.gz' ],
    'chr8' => [ '/data/cqs/references/low_coverage_wgs/hg38/1000g/CCDG_14151_B01_GRM_WGS_2020-08-05_chr8.filtered.shapeit2-duohmm-phased.vcf.gz' ],
    'chr9' => [ '/data/cqs/references/low_coverage_wgs/hg38/1000g/CCDG_14151_B01_GRM_WGS_2020-08-05_chr9.filtered.shapeit2-duohmm-phased.vcf.gz' ],
    'chrX' => [ '/data/cqs/references/low_coverage_wgs/hg38/1000g/CCDG_14151_B01_GRM_WGS_2020-08-05_chrX.filtered.eagle2-phased.v2.vcf.gz' ],
  },
  extraction => {
    class                 => "CQS::ProgramWrapperOneToOne",
    perform      => 1,
    target_dir   => $target_dir,
    option       => "
echo bcftools view -G -m 2 -M 2 -v snps __FILE__ -Oz -o 1000GP.__NAME__.sites.vcf.gz
bcftools view -G -m 2 -M 2 -v snps __FILE__ -Oz -o 1000GP.__NAME__.sites.vcf.gz

echo bcftools index -f 1000GP.__NAME__.sites.vcf.gz
bcftools index -f 1000GP.__NAME__.sites.vcf.gz

echo bcftools query -f'\%CHROM\\t\%POS\\t\%REF,\%ALT\\n' 1000GP.__NAME__.sites.vcf.gz | bgzip -c > 1000GP.__NAME__.sites.tsv.gz
bcftools query -f'\%CHROM\\t\%POS\\t\%REF,\%ALT\\n' 1000GP.__NAME__.sites.vcf.gz | bgzip -c > 1000GP.__NAME__.sites.tsv.gz

echo tabix -s1 -b2 -e2 1000GP.__NAME__.sites.tsv.gz
tabix -s1 -b2 -e2 1000GP.__NAME__.sites.tsv.gz

echo GLIMPSE_chunk --input 1000GP.__NAME__.sites.vcf.gz --region __NAME__ --window-size 2000000 --buffer-size 200000 --output 1000GP.__NAME__.chunks.txt
GLIMPSE_chunk --input 1000GP.__NAME__.sites.vcf.gz --region __NAME__ --window-size 2000000 --buffer-size 200000 --output 1000GP.__NAME__.chunks.txt

#__OUTPUT__
",
    source_ref   => "files",
    source_arg            => "",
    interpretor           => "",
    check_program         => 0,
    program               => "",
    output_to_same_folder => 1,
    output_arg            => "",
    output_to_folder      => 0,
    output_file_prefix    => "",
    output_file_ext       => "1000GP.__NAME__.chunks.txt",
    other_localization_ext_array => [".tbi"],
    use_tmp_folder => 0,
    docker_prefix  => "glimpse_",
    sh_direct    => 1,
    pbs          => {
      "nodes"     => "1:ppn=1",
      "walltime"  => "10",
      "mem"       => "10gb"
    },
  },
};

performTask($config, "extraction");

1;
