use strict;
use warnings;

open(my $LA, "<", "W9990004-002_S1.genome.vcf") or die $!;
open(my $OR, "<", "test.vcf") or die $!;
open(my $out, ">", "out.txt") or die $!;

my @LAtxt = <$LA>;
my @ORtxt = <$OR>;

if ($#ORtxt != $#LAtxt) {
    print 'x' and die;
}


for (my $n = 0; $n < $#ORtxt; $n++ ){
    
    if ($ORtxt[$n] ne $LAtxt[$n]) {
        print $out $ORtxt[$n] . "\n";
        print $out $LAtxt[$n] . "\n";
    }
    
}

