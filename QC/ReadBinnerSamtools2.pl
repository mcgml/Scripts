use strict;
use warnings;

#wrapper for samtools to count reads belonging to specific amplicons for bams in current dir

if ($#ARGV != 0) {
    print 'Usage: <Regions>' . "\n";
    print '<Regions> amplicon\tchr:start-end' . "\n";
    print 'Script will analyse bams in cwd' . "\n";
    exit;
}

open(my $regions_in, "<", $ARGV[0]) or die "Could not open regions file: $!"; #amplicon\tchr:start-end
open(my $out, ">", "Amplicon_Frequencies.txt") or die "Could not open regions file: $!"; #amplicon\tchr:start-end

my $sampleID;
my $amplicon;
my $region;
my $frequency;
my $bam;
my $str;

my @bams = glob("*.bam");
my @regions = <$regions_in>;

chomp @regions;

#print headers
print $out "SampleID\tQC-PassedReads";
foreach $str (@regions){
    ($amplicon, $region) = split("\t", $str); #split fields out of regions file
    print $out "\t" . $amplicon;
}

#iterate over bams in cwd, invoke samtools and record frequencies
foreach $bam (@bams){
    ($sampleID, $str) = split('_', $bam);    
    print $out "\n$sampleID";
    
    #total number of reads in bam
    $frequency = `"C:\\Illumina\\MiSeq Reporter\\Workflows\\PcrAmpliconWorker\\samtools.exe" view -c $bam`;
    chomp $frequency;
    print $out "\t" . $frequency;
    
    #reads by amplcion
    foreach $str (@regions){
	($amplicon, $region) = split("\t", $str); #split fields out of regions file

        $frequency = `"C:\\Illumina\\MiSeq Reporter\\Workflows\\PcrAmpliconWorker\\samtools.exe" view -c $bam $region`;
        chomp $frequency;
        
	#record output
        print $out "\t" . $frequency;
    }
    
}