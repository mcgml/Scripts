use strict;
use warnings;
use Statistics::Basic::Median;

my @files = <*.csv>;
my $n;
my %headerPos;
my %deadRuns;
my @q30;
my @pf;
use Statistics::Basic qw(:all);

open(my $out, ">", "SAV.txt") or die $!;

foreach my $file (@files){    

    $n = 0;
    undef (%headerPos);
    undef @pf;
    undef @q30;
    
    open(my $in, "<", $file) or die $!;    
    while (<$in>) {
        chomp;
        $n++;
        
        if ($n == 1){
            my @headers = split /,/, $_;
            
            for (my $j = 0; $j < $#headers; $j++){
                $headerPos{$headers[$j]} = $j;
            }
            
            if (!exists($headerPos{'Density PF (K/mm2)'}) || !exists($headerPos{'Density (K/mm2)'}) || !exists($headerPos{'% >= q30'}) || !exists($headerPos{'%PF'})) {
                print $file . "\n";
                last;
            }
            
        } else {
            my @fields = split /,/, $_;
            
            if (exists($headerPos{'% >= q30'})){
                if ($#fields >= $headerPos{'% >= q30'} && $fields[$headerPos{'% >= q30'}] ne "") {
                    push(@q30, $fields[$headerPos{'% >= q30'}]);
                } else {
                    print $file . "\n";
                    last;
                }
            } else {
                print $file . "\n";
                last;
            }
            
            if (exists ($headerPos{'%PF'})){
                if ($#fields >= $headerPos{'%PF'} && $fields[$headerPos{'%PF'}] ne "") {
                    push(@pf, $fields[$headerPos{'%PF'}]);
                } else {
                                    print $file . "\n";
                last;
                }
            } else {
                                print $file . "\n";
                last;
            }
            
            #print $out $file . "\t" . $fields[$headerPos{'Density PF (K/mm2)'}] . "\t" . $fields[$headerPos{'Density (K/mm2)'}] . "\t" . $fields[$headerPos{'% >= q30'}] . "\t" . $fields[$headerPos{'%PF'}] . "\n";
            
#            if ($fields[$headerPos{'% >= q30'}] eq 'NaN') {
#               $deadRuns{$file}++;
#            } elsif ($fields[$headerPos{'% >= q30'}] eq '') {
#                $deadRuns{$file}++;
            #} elsif ($fields[$headerPos{'% >= q30'}] < 70) {
            #    $deadRuns{$file}++;
            #}
            
            # if ($fields[$headerPos{'%PF'}] eq 'NaN') {
            #   $deadRuns{$file}++;
            #} elsif ($fields[$headerPos{'%PF'}] eq '') {
              #  $deadRuns{$file}++;
          #  } elsif ($fields[$headerPos{'%PF'}] < 70) {
          #      $deadRuns{$file}++;
          #  }
            
        }
    }
    
    print $out $file . "\t" . median(@q30) . "\t" . median(@pf) . "\n";
    
    close ($file);
}

#foreach my $f (keys %deadRuns){
#    print $out $f . "\t" . $deadRuns{$f} . "\n";
#}