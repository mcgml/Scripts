use strict;
use warnings;

#Name: Amplicon_QC.pl
#Author: Matthew Lyon, WRGL/UoS
#Contact: mlyon@live.co.uk
#Date: 16/10/2013
#Version: RC
#Description: Wrapper for samtools QC functions

if ($#ARGV != 0) {
    print 'Usage: <SampleSheetUsed.csv>' . "\n";
    exit;
}

my @SampleIDs;
my $SampleID;
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
my $str2;
my $failed;
my $n = 0;
my $j = 0;
my %MF_files;
my $MFID;
my $MF_filename;
my $ampID;
my $chr;
my $start;
my $end;
my %regions;
my $frequency;
my $stat;

open(my $SS_in, "<", $ARGV[0]) or die $!;
open(my $QC_out, ">", "QC.txt") or die $!;

print $QC_out "Alignment\tQCPassedReads\tSingleMappedReads\tPairedMappedReads\tProperPairs\tDifferentChrPairs";

while (<$SS_in>) {
    chomp;
    
    #skip empty lines
    if ($_ eq "") {
        $n = 0;
        next;
    }
    
    #skip comma only lines
    foreach $str (split //, $_){
        if ($str ne ',') {
            goto trueline;
        }
    }
    $n = 0;
    next;
    
    trueline:
    #on manifest block
    if (substr($_, 0, 11) eq '[Manifests]') {
        $n = 1;
        $j = 1; # manifest is provided
        next;
    }
    
    #on data block
    if (substr($_, 0, 6) eq '[Data]') { 
        $n = 2;
        next;
    }
    
    if ($n == 1) { #now on [manifest]
        ($MFID, $MF_filename, $str) = split(',', $_);
        $MF_files{$MFID} = $MF_filename;
        next;
    } elsif ($n == 2) { #now on [data] records headers
        $n = 3;
        next;
    } elsif ($n == 3) { #now on sample records
        ($SampleID, $str) = split(',', $_);
        push (@SampleIDs, $SampleID);
    }
    
}

if ($j == 1) { #manifest was specified
    
    foreach $str (keys %MF_files){
        $n = 0;
        
        open(my $MF_in, "<", $MF_files{$str}) or die $!;        
        
        while (<$MF_in>) {
            chomp;
            
            if ($_ eq "") {
                next;
            }
            
            if (length($_) > 8) {
                if (substr($_, 0, 9) eq '[Regions]') {
                    $n = 1;
                    next;
                }
            }
            
            if ($n == 1) {
                $n = 2;
                next;
            }
            
            if ($n == 2) {
                ($ampID, $chr, $start, $end, $str2) = split("\t", $_);
                $regions{$ampID} = ' ' . $chr . ':' . $start . '-' . $end;
            }
            
        }
        
        close($MF_in);
    }
    
    #apply amplicon headers
    foreach $ampID (keys %regions){
        print $QC_out "\t" . $ampID;
    }
}

$n = 0;
foreach $SampleID (@SampleIDs){
    $n++;
    
    #concatinate bam filename
    $SampleID = $SampleID . '_S' . $n . '.bam';
    
    #collect samtools output
    $stat = `"C:\\Illumina\\MiSeq Reporter\\Workflows\\PcrAmpliconWorker\\samtools.exe" flagstat $SampleID`;
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
    
    #print flagstat result
    print $QC_out "\n" . $SampleID . "\t" . $QC . "\t" . ($mapped / $QC) * 100 . '%' . "\t" . ($bothmapped / $QC) * 100 . '%' . "\t" . ($ppairs / $QC) * 100 . '%' . "\t" . ($matchr / $QC) * 100 . '%';
    
    if ($j == 1) {
        #print amplicon frequencies
        foreach $str (keys %regions){
            $frequency = `"C:\\Illumina\\MiSeq Reporter\\Workflows\\PcrAmpliconWorker\\samtools.exe" view -c $SampleID $regions{$str}`; 
            chomp $frequency;
            print $QC_out "\t" . $frequency;
        }
    }
}