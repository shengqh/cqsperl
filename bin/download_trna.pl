#!/usr/local/bin/perl

use strict;

use LWP::Simple;
use LWP::UserAgent;
use POSIX qw(strftime);
use Bio::SeqIO;

my $ua = new LWP::UserAgent;
$ua->agent( "AgentName/0.1 " . $ua->agent );

# Create a request
my $url = 'http://gtrnadb.ucsc.edu/GtRNAdb2/genomes/';
my $req = new HTTP::Request GET => $url;

# Pass request to the user agent and get a response back
my $res = $ua->request($req);

my $datestring = strftime "%Y%m%d", localtime;
my $trnafa = "GtRNAdb2." . $datestring . ".fa";

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
        `wget $faurl`;

        my $seqio     = Bio::SeqIO->new( -file => $file,       '-format' => 'Fasta' );
        my $seqio_obj = Bio::SeqIO->new( -file => ">>$trnafa", -format   => 'fasta' );

        my $seqnames = {};
        while ( my $seq = $seqio->next_seq ) {
          my $nameseq = $seq->accession_number . ":" . $seq->seq;
          if ( !exists $seqnames->{ $nameseq } ) {
            $seqio_obj->write_seq($seq);
            $seqnames->{ $nameseq } = "";
          }
          else {
            die "duplicated ", $seq->accession_number, "\n";
          }
        }
        
        unlink($file);
      }

      #exit;
    }

    #exit;
  }
}

1;
