use strict;
use warnings;

#wrapper for samtools to count reads belonging to specified amplicons

if ($#ARGV != 1) {
    print 'Usage: <IndexedBam> <Regions>' . "\n";
	print 'Regions = [amplicon	chr:start-end]';
    exit;
}

(my $sampleID, ) = split('_', $ARGV[0]);

open(my $regions_in, "<", $ARGV[1]) or die "Could not open regions file: $!"; #amplicon chr:start-end
open(my $on_target_reads, ">", $sampleID . "_ontargetreads.txt") or die "Could not open regions file: $!"; #amplicon chr:start-end

my $amplicon;
my $region;
my %counts;
my $temp;
my $total_on_target = 0;

while (<$regions_in>) { #iterate over regions file
    chomp;
    
    ($amplicon, $region) = split("\t", $_); #split fields out of regions file
    $temp = `samtools view -c $ARGV[0] $region`;
    chomp $temp;
    
    $counts{$amplicon} += $temp; #sum all reads within window-- amplicon names should be unique unless this is desired
    $total_on_target += $temp; #running total of on target reads
}

foreach $amplicon (keys %counts){
    print $on_target_reads $amplicon . "\t" . $counts{$amplicon} . "\n";
}
$temp = `samtools view -c $ARGV[0]`;
chomp $temp;
print $on_target_reads "Unassigned\t" . ($temp - $total_on_target) . "\n";
