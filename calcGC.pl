use strict;
use warnings;

open(my $in, "<", $ARGV[0]) or die $!;
open(my $out, ">", "out.txt") or die $!;

my $A;
my $G;
my $C;
my $T;
my $GC;

while (<$in>) {
    chomp;
    
    (my $name, my $seq, my $str) = split("\t", $_);
    
    $A = 0;
    $C = 0;
    $T = 0;
    $G = 0;
    
    foreach my $char (split //, $seq){
        
        if ($char eq 'A') {
            $A++;
        } elsif ($char eq 'T'){
            $T++;
        } elsif ($char eq 'C'){
            $C++;
        } elsif ($char eq 'G'){
            $G++;
        }
        
    }
    
    $GC = sprintf("%.0f", (($C + $G) / length($seq)) * 100);
    
    print $out $name . "\t" . $seq . "\t" . $GC. "\n";
    
}

