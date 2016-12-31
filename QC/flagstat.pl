use strict;
use warnings;

my @bams = glob("*.bam");
my $QC;
my $duplicates;
my $mapped;
my $pairs;
my $read1;
my $read2;
my $ppairs;
my $bothmapped;
my $singletons;
my $matchr;
my $matchrQlt5;
my $str;
my $failed;

chomp @bams;

open(my $out, ">", "Flagstat_table.txt") or die $!;

print $out "SampleID\tQC-Passed reads\tDuplicates\tMapped\tPaired in Sequencing\tRead1\tRead2\tProper Pairs\tBoth Mapped\tSingletons\tPair Mapped Different Chr\tPair Mapped Different Chr <Q5\n";

foreach my $bam (@bams){
    my $stat = `samtools flagstat $bam`;
    chomp $stat;
    
    #extract stats
    ($QC, $duplicates, $mapped, $pairs, $read1, $read2, $ppairs, $bothmapped, $singletons ,$matchr, $matchrQlt5) = split("\n", $stat);
    ($QC, $str, $failed, $str) = split(' ', $QC);
    ($duplicates, $str) = split(' ', $duplicates);
    ($mapped, $str) = split(' ', $mapped);
    ($pairs, $str) = split(' ', $pairs);
    ($read1, $str) = split(' ', $read1);
    ($read2, $str) = split(' ', $read2);
    ($ppairs, $str) = split(' ', $ppairs);
    ($bothmapped, $str) = split(' ', $bothmapped);
    ($singletons, $str) = split(' ', $singletons);
    ($matchr, $str) = split(' ', $matchr);
    ($matchrQlt5, $str) = split(' ', $matchrQlt5);
    
    #print result
    print $out $bam . "\t" . $QC . "\t" . $duplicates . "\t" . ($mapped / $QC) * 100 . '%' . "\t" . $pairs . "\t" . $read1 . "\t" . $read2 . "\t" . $ppairs . "\t" . $bothmapped . "\t" . $singletons . "\t" . $matchr . "\t" . $matchrQlt5 . "\n";
    print "Reads Failed QC for $bam = $failed\n";
}