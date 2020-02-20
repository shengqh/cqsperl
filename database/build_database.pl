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
      chrs => [qw(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 X Y MT)],
      chr_url => "ftp://ftp.ensembl.org/pub/release-VERSION/fasta/rattus_norvegicus/dna/Rattus_norvegicus.Rnor_6.0.dna.chromosome.CHROMOSOME.fa.gz",
      fasta => "Rattus_norvegicus.Rnor_6.0.dna.primary_assembly.fa.gz",
      gtf_url => "ftp://ftp.ensembl.org/pub/release-VERSION/gtf/rattus_norvegicus/Rattus_norvegicus.Rnor_6.0.VERSION.chr.gtf.gz",
    },
    "Mmul_10" => {
      ver => "99",
      chrs => [qw(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 X Y)],
      chr_url => "ftp://ftp.ensembl.org/pub/release-VERSION/fasta/macaca_mulatta/dna/Macaca_mulatta.Mmul_10.dna.primary_assembly.CHROMOSOME.fa.gz",
      fasta => "Macaca_mulatta.Mmul_10.dna.primary_assembly.fa",
      gtf_url => "ftp://ftp.ensembl.org/pub/release-VERSION/gtf/macaca_mulatta/Macaca_mulatta.Mmul_10.VERSION.chr.gtf.gz",
    },
  },
  "gencode" => {
    "GRCm38.p6" => {
      ver=>"M24",
      fasta_url => "ftp://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_mouse/release_VERSION/GRCm38.primary_assembly.genome.fa.gz",
      gtf_url => "ftp://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_mouse/release_VERSION/gencode.vVERSION.annotation.gtf.gz",
    },
    # "GRCm38.p6.all" => {
    #   ver=>"M24",
    #   fasta_url => "ftp://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_mouse/release_VERSION/GRCm38.p6.genome.fa.gz",
    #   gtf_url => "ftp://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_mouse/release_VERSION/gencode.vVERSION.chr_patch_hapl_scaff.annotation.gtf.gz",
    # },
    "GRCh37.p13" => {
      ver=>"19",
      fasta_url => "s3://broad-references/hg19/v0/Homo_sapiens_assembly19.fasta",
      gtf_url => "ftp://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_VERSION/gencode.vVERSION.annotation.gtf.gz",
    },
    # "GRCh37.p13.all" => {
    #   ver=>"19",
    #   fasta_url => "ftp://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_VERSION/GRCh37.p13.genome.fa.gz",
    #   gtf_url => "ftp://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_VERSION/gencode.vVERSION.chr_patch_hapl_scaff.annotation.gtf.gz",
    # },
    "GRCh38.p13" => {
      ver=>"33",
      fasta_url => "ftp://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_VERSION/GRCh38.primary_assembly.genome.fa.gz",
      gtf_url => "ftp://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_VERSION/gencode.vVERSION.annotation.gtf.gz",
    },
    # "GRCh38.p13.all" => {
    #   ver=>"33",
    #   fasta_url => "ftp://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_VERSION/GRCh38.p13.genome.fa.gz",
    #   gtf_url => "ftp://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_VERSION/gencode.vVERSION.chr_patch_hapl_scaff.annotation.gtf.gz",
    # },
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

    my $fasta_url = $speciesMap->{$species}{fasta_url};
    my $ver = $speciesMap->{$species}{ver};
    my $gtf_url = $speciesMap->{$species}{gtf_url};

    print("$species, ver=" . $ver . "\n");

    my $chrs  = $speciesMap->{$species}{chrs};

    my $fasta;
    if(defined $chrs){
      $fasta = $speciesMap->{$species}{fasta};
      $fasta =~ s/VERSION/$ver/g;

      if (! -e $fasta) {
        my $chr_url = $speciesMap->{$species}{chr_url};
        $chr_url =~ s/VERSION/$ver/g;
        for my $chr (@$chrs){
          my $cur_chr_url = $chr_url;
          $cur_chr_url =~ s/CHROMOSOME/$chr/g;
          my $chr_gz = basename($cur_chr_url);
          if (!-e $chr_gz){
            run_command("wget $cur_chr_url");
          }
          run_command("gunzip -c $chr_gz >> $fasta");
        }
      }
    }else{
      $fasta_url =~ s/VERSION/$ver/g;
      my $fasta_gz = basename($fasta_url);

      if ($fasta_gz =~ /gz/){
        $fasta = substr($fasta_gz, 0, -3);
      }else{
        $fasta = $fasta_gz;
      }

      if (! -e $fasta){
        if ($fasta_url =~ /^s3/){
          run_command("aws2 s3 cp $fasta_url .");
          my $fasta_tmp = $fasta . ".tmp";
          rename($fasta, $fasta_tmp);

          open(my $in_fh, '<', $fasta_tmp) or die " can't open input file '$fasta_tmp' !\n";
          open(my $out_fh, '>', $fasta) or die " can't open output file '$fasta' !\n";
          # convert the chromosome definition lines
          while (my $line = $in_fh->getline) {
            if ($line =~ /\A>(\w+)( .+)?([\n\r]+)\z/) { # include line ending
              my $chr = $1;
              my $def = $2;
              my $end = $3;
              my $size = length($chr);
              my $new_chr;
              if ($chr  eq "MT"){
                $new_chr = "chrM";
              }elsif($size <= 2){
                $new_chr = "chr" . $chr;
              }else{
                $new_chr = $chr;
              }
              $out_fh->print('>' . $new_chr . $def . $end);
            }
            else {
              $out_fh->print($line);
            }
          }
          # finished
          $in_fh->close;
          $out_fh->close;

          unlink($fasta_tmp);
        }else{
          run_command("wget $fasta_url");
          run_command("gunzip $fasta_gz");
        }
      }
    }

    $gtf_url =~ s/VERSION/$ver/g;
    my $gtf_gz = basename($gtf_url);
    my $gtf = substr($gtf_gz, 0, -3);
    my $gtfMap = $gtf . ".map";

    print("gtf_url=" . $gtf_url . "\n");
    print("gtf=" . $gtf . "\n");
    print("gtfMap=" . $gtfMap . "\n");

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
