use strict;
use warnings;

open(my $in, "<", $ARGV[0]) or die $!;

my $n = 0;
my %reads;

while (<$in>) {
    chomp;
    
    $n++;
    
    if ($n == 2) {
        $reads{$_}++;
    } elsif ($n == 4){
        $n = 0;
    }
    
}

foreach my $read (keys %reads){
    print $read .  "\t" . $reads{$read} . "\n";
}

