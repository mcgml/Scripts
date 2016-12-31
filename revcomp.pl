use strict;
use warnings;

if ($#ARGV != 0) {
    print 'Usage: <DNA Sequence>' . "\n";
    exit;
}

open(my $out, ">", "revcomp.txt") or die "Could not write revcomp file: $!";

my $rev = reverse($ARGV[0]);
$rev =~ tr/ACGTacgt/TGCAtgca/;

print $rev;