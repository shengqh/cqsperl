my $fasta_tmp = "/scratch/cqs_share/references/gencode/GRCh37.p13/Homo_sapiens_assembly19.fasta.tmp";
my $fasta = "/scratch/cqs_share/references/gencode/GRCh37.p13/Homo_sapiens_assembly19.fasta";

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
            if ($size == 1){
              $new_chr = "chr" . $chr;
            }elsif($size == 2){
              $new_chr = "chrM";
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
