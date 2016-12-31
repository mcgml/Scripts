use strict;
use warnings;
use File::Basename;

my @folders = <F:\\test\\1?????_*>;

foreach my $folder (@folders){
    print ($folder . "\n");
    system("\"C:\\Illumina\\Illumina Sequencing Analysis Viewer\\Sequencing Analysis Viewer.exe\" " . $folder . " C:\\Users\\msl\\Desktop\\SAV\\" . fileparse($folder) . '.csv -t');
}