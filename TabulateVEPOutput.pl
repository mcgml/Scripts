use strict;
use warnings;

open(my $key, "<", "C:\\Illumina\\MiSeq Reporter\\Genomes\\Homo_sapiens\\UCSC\\hg19\\Sequence\\WholeGenomeFASTA\\Annotation\\RefGene.txt") or die $!;
open(my $in, "<", $ARGV[0]) or die $!;
open(my $out, ">", "AllVariants.annotation") or die $!;

my $str;
my $p;
my $c;
my $e;
my %genes;
my $lookup;

#create gene lookup
while (<$key>) {
    chomp;
    
    if ($_ eq '') {
        next;
    }
    
    ($str, my $transcript, $str, $str, $str, $str, $str, $str, $str, $str, $str, $str, my $gene, $str) = split("\t", $_);    
    $genes{$transcript} = $gene;
}

print $out "#Identifier\tGene\tTranscript\tConsequence\tExon\tHGVSc\tHGVSp\tSIFT\tPolyPhen_HumVar\n";

while (<$in>) {
    chomp;
    
    if ($_ eq '' or substr($_, 0, 1) eq '#') {
        next;
    }   
    
    (my $Uploaded_variation, my $Gene, my $Feature, my $Consequence, my $HGVSc, my $HGVSp, my $CANONICAL, my $EXON, my $SIFT, my $PolyPhen)
    = split("\t", $_);
    
    if (substr($Feature, 0, 3) eq 'NM_' && $HGVSc ne '-' && $CANONICAL eq 'YES'){
        #this annotation is good
        
        ($str, $c, $str) = split(':', $HGVSc);
        
        if ($EXON ne '-') {
            ($e, $str) = split('/', $EXON);
        } else {
            $e = '-';
        }
        
        if ($HGVSp ne '-') {
            ($str, $p, $str) = split(':', $HGVSp);
        } else {
            $p = '-';
        }
        
        ($lookup, $str) = split(/\./, $Feature);
        
        print $out $Uploaded_variation . "\t" . $genes{$lookup} . "\t" . $Feature . "\t" . $Consequence . "\t" . $e . "\t" . $c . "\t" . $p . "\t" . $SIFT . "\t" . $PolyPhen . "\n";
        
    }
    
}
