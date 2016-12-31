use strict;
use warnings;

open(my $in, "<", $ARGV[0]) or die $!;
open(my $out, ">", "out.txt") or die $!;

my $n = 0;
my %reads;

while (<$in>) {
    chomp;
    $n++;
    
    if ($n == 2) {
        $reads{$_} += 1;
    } elsif ($n == 4){
        $n = 0;
    }

}

foreach my $read (keys %reads){
    if ($reads{$read} > 1) {
        print $out $read . "\t" . $reads{$read} . "\n";
    }
}