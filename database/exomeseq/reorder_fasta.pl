use strict;
use Bio::Index::Fasta;


# file names
#
my $In_Fasta_File_Name = "/data/cqs/references/ucsc/mm10_unsorted/mm10.fa";
my $List_File_Name = '/data/cqs/softwares/cqsperl/database/exomeseq/mm10.genome';
my $Out_File_Name     = "/data/cqs/references/ucsc/mm10/mm10.fa";

#
# make index
#
my $Index_File_Name = "/data/cqs/references/ucsc/mm10_unsorted/mm10.fa.idx";
my $idx;
if (! -e "$Index_File_Name"){
  $idx             = Bio::Index::Fasta->new(
    '-filename'   => $Index_File_Name,
    '-write_flag' => 1
  );
  $idx->make_index($In_Fasta_File_Name);
}else{
  $idx = Bio::Index::Fasta->new(-filename => $Index_File_Name);
}

# open the list
#
open( my $list, $List_File_Name ) or die "Could not open $List_File_Name !";

#
# write to stdout using list and index
#
my $out = Bio::SeqIO->new( '-format' => 'Fasta', '-file' => ">$Out_File_Name" );
while ( my $id = <$list> ) {
 chomp $id;
 my @parts = split ' ', $id;
 print($parts[0] . "\n");
 my $seq = $idx->fetch($parts[0]); 
 $out->write_seq($seq);
}

close($list);
