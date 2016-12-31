use strict;
use warnings;

#script to reverse complement FASTQ, and reverse Qual field.

if ($#ARGV != 0) {
    print 'Usage: <FASTQ>' . "\n";
    exit;
}

open(my $in , "<", $ARGV[0]) or die $!;
open(my $out, ">", "rev" . $ARGV[0]) or die "Could not write revcomp file: $!";

binmode($out);

my $n = 0;
my $temp;

while (<$in>) {
    chomp;
    $n++;
    
    if ($n ==1) {
        print $out $_ . "\012";
    } elsif ($n ==2){
        $temp = reverse($_);
        $temp =~ tr/ACGTacgt/TGCAtgca/;
        
        print $out $temp . "\012+\012";
    } elsif ($n==4){
        $n =0;
        print $out reverse($_) . "\012";
    }
    
    
}