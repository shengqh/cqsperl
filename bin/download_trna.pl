#!/usr/local/bin/perl

use strict;

use LWP::Simple;
use LWP::UserAgent;
use POSIX qw(strftime);
use Bio::SeqIO;

my $datestring = strftime "%Y%m%d", localtime;
my $trnafa = "GtRNAdb2." . $datestring . ".fa";

if ( !-e $trnafa ) {
  my $ua = new LWP::UserAgent;
  $ua->agent( "AgentName/0.1 " . $ua->agent );

  # Create a request
  my $url = 'http://gtrnadb.ucsc.edu/GtRNAdb2/genomes/';
  my $req = new HTTP::Request GET => $url;

  # Pass request to the user agent and get a response back
  my $res = $ua->request($req);

  print $trnafa;

  if ( -e $trnafa ) {
    unlink($trnafa);
  }

  if ( $res->is_success ) {
    my $rescontent = $res->content;

    while ( $rescontent =~ m/folder.gif" alt="\[DIR\]"> <a href="(.*?)"/g ) {
      my $category = $1;

      #print $category, "\n";

      my $categoryurl     = $url . $category;
      my $categoryreq     = new HTTP::Request GET => $categoryurl;
      my $categoryres     = $ua->request($categoryreq);
      my $categorycontent = $categoryres->content;

      while ( $categorycontent =~ m/folder.gif" alt="\[DIR\]"> <a href="(.*?)"/g ) {
        my $species = $1;

        #print $category, " : ", $species, "\n";
        my $speciesurl     = $categoryurl . $species;
        my $speciesreq     = new HTTP::Request GET => $speciesurl;
        my $speciesres     = $ua->request($speciesreq);
        my $speciescontent = $speciesres->content;

        #print $speciescontent, "\n";

        if ( $speciescontent =~ /href="(.*?\.fa)">FASTA Seqs/ ) {
          my $file  = $1;
          my $faurl = $speciesurl . $1;
          print $faurl, "\n";
          `wget $faurl; cat $file >> $trnafa; rm $file`;
        }
      }
    }
  }
}

my $trnaRmdupFasta = "GtRNAdb2." . $datestring . ".rmdup.fa";

my $seqio = Bio::SeqIO->new( -file => $trnafa, -format => 'fasta' );

my $seqnames      = {};
my $totalcount    = 0;
my $uniqueidcount = 0;

while ( my $seq = $seqio->next_seq ) {
  $totalcount++;
  if ( !exists $seqnames->{ $seq->id } ) {
    $seqnames->{ $seq->id } = $seq->seq;
    $uniqueidcount++;
  }
}

my $sequences      = {};
my $uniqueseqcount = 0;
for my $id ( keys %{$seqnames} ) {
  my $seq = $seqnames->{$id};
  if ( !exists $sequences->{$seq} ) {
    $sequences->{$seq} = $id;
    $uniqueseqcount++;
  }
  else {
    $sequences->{$seq} = $sequences->{$seq} . ";" . $id;
  }
}

open( my $info, ">${trnaRmdupFasta}.info" ) or die "Cannot create ${trnaRmdupFasta}.info";
print $info "Total entries\t$totalcount
Unique id\t$uniqueidcount
Unique sequence\t$uniqueseqcount";
close($info);

open( my $fasta, ">$trnaRmdupFasta" ) or die "Cannot create $trnaRmdupFasta";
for my $seq ( keys %{$sequences} ) {
  my $id = $sequences->{$seq};
  print $fasta ">$id
$seq
";
}
close($fasta);
1;
