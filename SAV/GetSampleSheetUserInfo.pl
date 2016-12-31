use strict;
use warnings;

my @folders = <*>;
my @fields;
my @fileLine;

open(my $out, ">", "RunLog.txt") or die $!;

foreach my $folder (@folders){
    
    if (-e $folder . '/SampleSheet.csv'){
        open(my $in, "<", $folder . "\\SampleSheet.csv") or print "could not find run $folder";
        @fileLine = <$in>;
        close ($in);
    } elsif(-e $folder . '/SampleSheetUsed.csv') {
        open(my $in, "<", $folder . "\\SampleSheetUsed.csv") or print "could not find run $folder";
        @fileLine = <$in>;
        close ($in);
    } else {
        print "No samplesheet for $folder\n";
        next;
    }  
    
    print $out $folder . "\t";
    
    for (@fileLine) {
        chomp;
        
        if ($_ eq '' || $_ =~ /^[Data]/) {
            last;
        }
        
        if ($_ =~ /^Investigator/){
            @fields = split /,/, $_;
            
            if ($#fields > 0) {
                print $out $fields[1];
            }
            
        }
    }
    
    print $out "\t";

    for (@fileLine) {
        chomp;
        
        if ($_ eq '' || $_ =~ /^[Data]/) {
            last;
        }
        
        if ($_ =~ /^Experiment/) {
            @fields = split /,/, $_;
            
            if ($#fields > 0) {
                print $out $fields[1];
            }
        }
    }
    
    print $out "\n";
}

close($out);