use strict;
use warnings;

open(my $in, "<", "E2245.fastq") or die $!;
open(my $out, ">", "E2245.fasta") or die $!;
my $n = 0;

while (<$in>) {
    
    $n++;
    
    if ($n == 1) {
        print $out '>' . $_;
    } elsif ($n == 2){
        print $out $_;
    } elsif ($n == 4){
    $n = 0;
    }

    
    
}

