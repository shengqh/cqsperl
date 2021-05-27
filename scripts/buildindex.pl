#!/usr/bin/env perl
use strict;
use warnings;
use File::Basename;
use File::Spec;
use Getopt::Long;
use Cwd 'abs_path';

sub run_command {
  my $command = shift;
  print "$command \n";
  `$command `;
}

my $usage = "

Synopsis:

buildindex -f fastaFile [Options]

Options:

  -f|--file {fastaFile}        Fasta format sequence file
  -b|--bowtie                  Build bowtie index
  -w|--bwa                     Build bwa index
  -s|--star                    Build STAR index
  --hisat2                     Build hisat2 index
  --sjdbGTFfile                Option sjdbGTFfile for STAR index
  --sjdbGTFfileVersion         Option sjdbGTFfile version for STAR index
  --sjdbOverhang               Option sjdbOverhang for STAR index
  --thread                     Option thread for STAR index
  -B|--bowtie2                 Build bowtie2 index
  -g|--gsnap                   Build gsnap index
  -o|--option                  Additional option
  -h|--help                    This page.
";

Getopt::Long::Configure('bundling');

my $fastaFile;
my $dogsnap;
my $dobowtie;
my $dobowtie2;
my $dobwa;
my $dohisat2;
my $hisat2GTFfile;
my $hisat2SNPfile;
my $dostar;
my $sjdbGTFfile;
my $sjdbOverhang;
my $thread;
my $help;
my $sjdbGTFfileVersion;
my $option;

GetOptions(
  'h|help'               => \$help,
  'f|file=s'             => \$fastaFile,
  'g|gsnap'              => \$dogsnap,
  'b|bowtie'             => \$dobowtie,
  'B|bowtie2'            => \$dobowtie2,
  'w|bwa'                => \$dobwa,
  'hisat2'               => \$dohisat2,
  'hisat2GTFfile=s'      => \$hisat2GTFfile,
  'hisat2SNPfile=s'      => \$hisat2SNPfile,
  's|star'               => \$dostar,
  'sjdbGTFfile=s'        => \$sjdbGTFfile,
  'sjdbGTFfileVersion=s' => \$sjdbGTFfileVersion,
  'sjdbOverhang=i'       => \$sjdbOverhang,
  'thread=i'             => \$thread,
  'o|option=s'           => \$option,
);

my $pass = 1;

if ( defined $help ) {
  print $usage;
  exit(1);
}

if ( !defined $option ) {
  $option = "";
}

if ( !defined($fastaFile) ) {
  print STDERR "file is required for build index." . "\n";
  $pass = 0;
}
elsif ( !-e $fastaFile ) {
  print STDERR "fasta file is not exist " . $fastaFile . "\n";
  $pass = 0;
}

if ( defined $dohisat2 ) {
  if ( defined $hisat2GTFfile ) {
    if ( !-e $hisat2GTFfile ) {
      print STDERR "hisat2GTFfile is not exist " . $hisat2GTFfile . "\n";
      $pass = 0;
    }else{
      $hisat2GTFfile = File::Spec->rel2abs($hisat2GTFfile);
      print STDOUT "hisat2GTFfile=". $hisat2GTFfile . "\n";
    }
  }else{
    print STDERR "hisat2GTFfile is required for hisat2 index." . "\n";
    $pass = 0;
  }

  if ( defined $hisat2SNPfile ) {
    if ( !-e $hisat2SNPfile ) {
      print STDERR "hisat2SNPfile is not exist " . $hisat2SNPfile . "\n";
      $pass = 0;
    }else{
      $hisat2SNPfile = File::Spec->rel2abs($hisat2SNPfile);
      print STDOUT "hisat2SNPfile=". $hisat2SNPfile . "\n";
    }
  }else{
    print STDERR "hisat2SNPfile is required for hisat2 index." . "\n";
    $pass = 0;
  }

  if ( !defined $thread ) {
    $thread = 8;
  }
}

if ( defined $dostar ) {
  if ( defined $sjdbGTFfile ) {
    if ( !-e $sjdbGTFfile ) {
      print STDERR "sjdbGTFfile is not exist " . $sjdbGTFfile . "\n";
      $pass = 0;
    }else{
      $sjdbGTFfile = File::Spec->rel2abs($sjdbGTFfile);
      print STDOUT "sjdbGTFfile=". $sjdbGTFfile . "\n";
    }

    if ( !defined $sjdbGTFfileVersion ) {
      print STDERR "sjdbGTFfileVersion is required for STAR index." . "\n";
      $pass = 0;
    }

    if ( !defined $sjdbOverhang ) {
      $sjdbOverhang = 100;
    }
  }
  if ( !defined $thread ) {
    $thread = 8;
  }
}

if ( !$pass ) {
  print $usage;
  exit(1);
}

my $basename = basename($fastaFile);
( my $base = $basename ) =~ s/\.[^.]+$//;

# index fasta file
if ( !-e "${basename}.fai" ) {
  run_command("samtools faidx $fastaFile ");
}

if ( !-e "${base}.dict" ) {
  run_command("java -jar /data/cqs/softwares/picard.jar CreateSequenceDictionary R=$fastaFile O=${base}.dict");
}

if ( !-e "${base}.len" ) {
  run_command("perl /home/shengq2/local/bin/get_fasta_lengths.pl $fastaFile");
  run_command("mv res_${basename} ${base}.len ");
}

my $absolute_dir = File::Spec->rel2abs(".");

if ( defined $dobowtie ) {

  # bowtie
  my $bowtie = `bowtie --version | grep bowtie | grep version | cut -d " " -f 3`;
  chomp($bowtie);
  if ( !-e "bowtie_index_${bowtie}" ) {
    mkdir("bowtie_index_${bowtie}");
  }
  chdir("bowtie_index_${bowtie}");
  if ( !-e $basename ) {
    run_command("ln -s ../$fastaFile $basename ");
    run_command("ln -s ../${base}.dict ${base}.dict ");
    run_command("ln -s ../${basename}.fai ${basename}.fai ");
    run_command("ln -s ../${base}.len ${base}.len ");
  }

  if ( !-e "${base}.1.ebwt" ) {
    my $size = -s $basename;
    if ( $size >= 4000000000 ) {
      print "Database size = $size, build large-index \n";
      run_command("bowtie-build --large-index $basename $base ");
    }
    else {
      run_command("bowtie-build $basename $base ");
    }
  }
  chdir($absolute_dir);
}

if ( defined $dobwa ) {

  `bwa 2> 1`;
  my $bwa = `grep Version 1 | cut -d " " -f 2 | cut -d "-" -f 1`;
  chomp($bwa);
  `rm 1`;
  if ( !-e "bwa_index_${bwa}" ) {
    mkdir("bwa_index_${bwa}");
    chdir("bwa_index_${bwa}");
    if ( !-e $basename ) {
      run_command("ln -s ../$fastaFile $basename ");
      run_command("ln -s ../${base}.dict ${base}.dict ");
      run_command("ln -s ../${basename}.fai ${basename}.fai ");
      run_command("ln -s ../${base}.len ${base}.len ");
    }
    my $afile = dirname(abs_path($fastaFile)) . "/bwa_index_${bwa}/$basename";
    print "bwa index $option $afile \n";
    run_command("bwa index $option $afile");

    chdir($absolute_dir);
  }
}

if ( defined $dostar ) {

  # STAR
  my $star = `STAR --version | cut -d "_" -f 2`;
  chomp($star);
  my $star_dir;

  if ( defined $sjdbGTFfile ) {
    $star_dir = "STAR_index_${star}_${sjdbGTFfileVersion}_sjdb${sjdbOverhang}";
  }
  else {
    $star_dir = "STAR_index_${star}";
  }

  if ( !-e $star_dir ) {
    mkdir($star_dir);
    chdir($star_dir);
    if ( !-e $basename ) {
      run_command("ln -s ../$fastaFile $basename ");
      run_command("ln -s ../${base}.dict ${base}.dict ");
      run_command("ln -s ../${basename}.fai ${basename}.fai ");
      run_command("ln -s ../${base}.len ${base}.len ");
    }
    if ( defined $sjdbGTFfile ) {
      run_command("STAR $option --limitGenomeGenerateRAM 306609344554 --runThreadN $thread --runMode genomeGenerate --genomeDir . --genomeFastaFiles $basename --sjdbGTFfile $sjdbGTFfile --sjdbOverhang $sjdbOverhang");
    }
    else {
      run_command("STAR $option --limitGenomeGenerateRAM 306609344554 --runThreadN $thread --runMode genomeGenerate --genomeDir . --genomeFastaFiles $basename");
    }
    chdir($absolute_dir);
  }
}

if ( defined $dobowtie2 ) {

  # bowtie2
  my $bowtie2 = `bowtie2 --version | grep bowtie2 | grep version | cut -d " " -f 3`;
  chomp($bowtie2);
  if ( !-e "bowtie2_index_${bowtie2}" ) {
    mkdir("bowtie2_index_${bowtie2}");
    chdir("bowtie2_index_${bowtie2}");
    if ( !-e $basename ) {
      run_command("ln -s ../$fastaFile $basename ");
      run_command("ln -s ../${base}.dict ${base}.dict ");
      run_command("ln -s ../${basename}.fai ${basename}.fai ");
      run_command("ln -s ../${base}.len ${base}.len ");
    }
    run_command("bowtie2-build $option $basename $base ");
    chdir("..");
  }
}

if ( defined $dogsnap ) {

  # gsnap
  `gsnap 2> 1`;
  my $gsnap = `grep version 1 | cut -d " " -f 3`;
  chomp($gsnap);
  `rm 1`;
  if ( !-e "gsnap_index_k14_${gsnap}" ) {
    mkdir("gsnap_index_k14_${gsnap}");
  }
  chdir("gsnap_index_k14_${gsnap}");
  if ( !-e $basename ) {
    run_command("ln -s ../$fastaFile $basename ");
    run_command("ln -s ../${base}.dict ${base}.dict ");
    run_command("ln -s ../${basename}.fai ${basename}.fai ");
    run_command("ln -s ../${base}.len ${base}.len ");
  }

  #min_read_length = kmers + interval - 1
  #in order to control the min_read_length = 16, we have to smaller the kmers from 15 to 14 when keep the "sampling interval for genome" equals 3
  run_command("gmap_build -D . -d $base -k 14 -j 14 -s none $basename");
  run_command("atoiindex -F . -d $base -k 14");
  chdir($absolute_dir);
}

if ( defined $dohisat2 ) {

  my $hisat2 = `hisat2 --version | grep hisat2 | grep version | cut -d ' ' -f 3`;
  chomp($hisat2);
  my $hisat2_index = "hisat2_${hisat2}";
  if ( !-e $hisat2_index ) {
    mkdir($hisat2_index);
  }
  chdir($hisat2_index);
  if ( !-e $basename ) {
    run_command("ln -s ../$fastaFile $basename ");
    run_command("ln -s ../${base}.dict ${base}.dict ");
    run_command("ln -s ../${basename}.fai ${basename}.fai ");
    run_command("ln -s ../${base}.len ${base}.len ");
  }

  run_command("hisat2_extract_snps_haplotypes_VCF.py $basename $hisat2SNPfile $base");
  run_command("hisat2_extract_splice_sites.py $hisat2GTFfile > ${base}.ss");
  run_command("hisat2_extract_exons.py $hisat2GTFfile > ${base}.exon");
  chdir($absolute_dir);
}

1;
