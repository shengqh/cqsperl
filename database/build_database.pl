#!/usr/bin/env perl
use strict;
use warnings;
use File::Basename;
use File::Spec;
use Getopt::Long;

sub run_command {
  my $command = shift;
  print "$command \n";
  `$command `;
}

my $databases = {
  "ensembl" => {
    "Rnor_6.0" => {
      ver=>"99",
      fasta_url => "ftp://ftp.ensembl.org/pub/release-VERSION/fasta/rattus_norvegicus/dna/Rattus_norvegicus.Rnor_6.0.dna.toplevel.fa.gz",
      gtf_url => "ftp://ftp.ensembl.org/pub/release-VERSION/gtf/rattus_norvegicus/Rattus_norvegicus.Rnor_6.0.VERSION.gtf.gz",
    },
    "Mmul_10" => {
      ver=>"99",
      fasta_url => "ftp://ftp.ensembl.org/pub/release-VERSION/fasta/macaca_mulatta/dna/Macaca_mulatta.Mmul_10.dna.toplevel.fa.gz",
      gtf_url => "ftp://ftp.ensembl.org/pub/release-VERSION/gtf/macaca_mulatta/Macaca_mulatta.Mmul_10.VERSION.gtf.gz",
    },
  },
  "gencode" => {
    "GRCm38.p6" => {
      ver=>"M24",
      fasta_url => "ftp://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_mouse/release_VERSION/GRCm38.primary_assembly.genome.fa.gz",
      gtf_url => "ftp://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_mouse/release_VERSION/gencode.vVERSION.annotation.gtf.gz",
    },
    "GRCh37.p13" => {
      ver=>"19",
      fasta_url => "ftp://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_VERSION/GRCh37.p13.genome.fa.gz",
      gtf_url => "ftp://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_VERSION/gencode.vVERSION.chr_patch_hapl_scaff.annotation.gtf.gz",
    },
    "GRCh38.p13" => {
      ver=>"33",
      fasta_url => "ftp://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_VERSION/GRCh38.primary_assembly.genome.fa.gz",
      gtf_url => "ftp://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_VERSION/gencode.vVERSION.annotation.gtf.gz",
    },
  },
  "gatk" => {
    "b37" => {
      bucket => "gs://gatk-legacy-bundles/b37/",
      files => qw(1000G_omni2.5.b37.vcf 1000G_phase3_v4_20130502.sites.vcf.gz 1000G_phase3_v4_20130502.sites.vcf.gz.tbi 
    }

  },
};

for my $database (sort keys %$databases){
  my $db_dir = "/scratch/cqs_share/references/$database";
  if ( !-e $db_dir){
    mkdir($db_dir);
  }

  my $speciesMap = $databases->{$database};
  for my $species (sort keys %$speciesMap){
    my $species_dir = $db_dir . "/" . $species;
    if ( !-e $species_dir){
      mkdir($species_dir);
    }
    chdir($species_dir);

    my $ver = $speciesMap->{$species}{ver};
    my $fasta_url = $speciesMap->{$species}{fasta_url};
    my $gtf_url = $speciesMap->{$species}{gtf_url};

    $fasta_url =~ s/VERSION/$ver/g;
    $gtf_url =~ s/VERSION/$ver/g;

    my $fasta_gz = basename($fasta_url);
    my $gtf_gz = basename($gtf_url);

    my $fasta = substr($fasta_gz, 0, -3);
    my $gtf = substr($gtf_gz, 0, -3);
    my $gtfMap = $gtf . ".map";

    print("ver=" . $ver . "\n");
    print("fasta_url=" . $fasta_url . "\n");
    print("gtf_url=" . $gtf_url . "\n");
    print("fasta=" . $fasta . "\n");
    print("gtf=" . $gtf . "\n");
    print("gtfMap=" . $gtfMap . "\n");

    if (! -e $fasta){
      run_command("wget $fasta_url");
      run_command("gunzip $fasta_gz");
    }

    if (! -e $gtf){
      run_command("wget $gtf_url");
      run_command("gunzip $gtf_gz");
    }

    if (! -e $gtfMap){
      run_command("singularity exec -e /scratch/cqs_share/softwares/singularity/cqs-smallRNA.simg cqstools gtf_buildmap -i $gtf -o $gtfMap");
    }

    run_command("buildindex.pl -f $fasta -b -w -B -s --sjdbGTFfile $gtf --sjdbGTFfileVersion v${ver} --thread 24");
  }
}

1;
