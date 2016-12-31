use strict;
use warnings;


open(my $in, "<", $ARGV[0]) or die $!;
open(my $out, ">", "output.txt") or die $!;

my $str;
my $name;
my $seq;
my $n = 0;
my %seqs;

while (<$in>) {
    chomp;
    
    if (substr($_, 0, 1) eq '>') {
        $n++;
        
        if ($n != 1) {
            $seqs{$name} = $seq;
        }
        
        $seq = '';
        
        ($name, $str) = split(' ', $_);
        next;
        
    } else {
        $seq = $seq . $_;
    }
    
}

$seqs{$name} = $seq;

foreach $str (keys %seqs){
    print $out $str . "\t" . $seqs{$str} . "\n";
}



