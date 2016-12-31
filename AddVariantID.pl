use strict;
use warnings;

#Title: AddVariantID.pl
#Description: Adds unique ID to ID field for looking up in annotation outputs
#Author: Matthew Lyon (matt.lyon@wales.nhs.uk)
#Status: Release

if ($#ARGV != 0) {
    print "Usage: <VCF>";
    exit;  
}

my @fileName = split("\\.", $ARGV[0]);

open(my $vcfIn, "<", $ARGV[0]) or die $!;
open(my $vcfOut, ">", $fileName[0] . "_ID.vcf") or die $!;

while (<$vcfIn>) {
    chomp;
    
    #skip headers
    if (substr($_, 0 ,1) eq '#') {
        print $vcfOut $_ . "\012";
        next;
    }   
    
    #split fields
    my @fields = split("\t", $_);
    
    #print chrom
    print $vcfOut $fields[0];
    
    #print pos
    print $vcfOut "\t" . $fields[1];
    
    #print ID
    if ($fields[2] eq "\.") {
        print $vcfOut "\t" . $fields[0] . ":" . $fields[1] . $fields[3] . ">" . $fields[4]; #var concat
    } else {
        print $vcfOut "\t" . $fields[0] . ":" . $fields[1] . $fields[3] . ">" . $fields[4] . ';' . $fields[2]; #variant concat;dbsnp
    }
    
    #print remaining fields
    for (my $n = 3; $n < $#fields + 1; $n++){
        print $vcfOut "\t" . $fields[$n];
    }
    
    print $vcfOut "\012";
}

close($vcfIn);
close($vcfOut);

