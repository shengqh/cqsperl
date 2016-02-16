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

my $seqio     = Bio::SeqIO->new( -file => $trnafa,             -format => 'fasta' );
my $seqio_obj = Bio::SeqIO->new( -file => ">>$trnaRmdupFasta", -format => 'fasta' );

my $seqnames    = {};
my $totalcount  = 0;
my $uniquecount = 0;
while ( my $seq = $seqio->next_seq ) {
  $totalcount++;
  if ( !exists $seqnames->{ $seq->seq } ) {
    $seqnames->{ $seq->seq } = $seq->id;
    $uniquecount++;
  }
  else {
    $seqnames->{ $seq->seq } = $seqnames->{ $seq->seq } . ";" . $seq->id;
  }
}

print "Total entries = ", $totalcount, " while unique sequences = ", $uniquecount, "\n";

1;
