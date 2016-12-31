use strict;
use warnings;

if ($#ARGV != 0) {
    print 'Usage: <txt list>' . "\n";
    exit;
}
open(my $in, "<", $ARGV[0]) or die $!;
open(my $out, ">", "revcomp.txt") or die "Could not write revcomp file: $!";

while (<$in>) {
    chomp;
    
    my $rev = reverse($_);
    $rev =~ tr/ACGTacgt/TGCAtgca/;

    print $out $rev . "\n";
}