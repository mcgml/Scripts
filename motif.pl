use strict;
use warnings;

open(my $in, $ARGV[0], "<") or die $!;

my $n = 0;
my %tenbp;
my $a  =0;
my $t = 0;
my $g = 0;
my $c = 0;

while (<$in>) {
    chomp;
    
    $n++;
    
    if ($n == 2) {
        $tenbp{substr($_, 0, 10)}++; #ten bp
        
        for (my $j = 0; $j < 10; $j++){
            
            if ($_[$j] == 'A') {
                $a++;
            } elsif ($_[$j] == 'C'){
                $c++;
            } elsif ($_[$j] == 'G'){
                $g++;
            } elsif ($_[$j] == 'T'){
                $t++;
            }
            
        }
        
    } elsif ($n == 4){
        $n = 0;
    }
    
}

print $a . "\t" . $t . "\t" . $c . "\t" . $g . "\n";

foreach my $x (keys %tenbp){
    print $tenbp{$x} . "\t" . $x . "\n";
}

