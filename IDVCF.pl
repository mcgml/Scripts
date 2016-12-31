use strict;
use warnings;

if ($#ARGV != 0) {
    print "Usage: VCF file";
    exit;  
}

my @fileName = split("\\.", $ARGV[0]);

open(my $vcfIn, "<", $ARGV[0]) or die $!;
open(my $vcfOut, ">", $fileName[0] . "_ID.vcf") or die $!;

while (<$vcfIn>) {
    chomp;
    
    if (substr($_, 0 ,1) eq '#') {
        print $vcfOut $_ . "\012";
        next;
    }   
    
    my @fields = split("\t", $_);
    
    print $vcfOut $fields[0] . "\t" . $fields[1] . "\t" . $fields[0] . ":" . $fields[1] . $fields[3] . ">" . $fields[4];
    
    for (my $n = 3; $n < $#fields + 1; $n++){
        print $vcfOut "\t" . $fields[$n];
    }
    
    print $vcfOut "\012";
}

close($vcfIn);
close($vcfOut);

