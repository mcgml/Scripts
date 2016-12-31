use strict;
use warnings;

my @fastqs = glob("W:\\MiSeq\\Illumina\\MiSeqOutput\\140929_M00321_0123_000000000-ABBEF\\Data\\Intensities\\BaseCalls\\*.fastq.gz");

foreach my $file (@fastqs){
    system("md5deep64 -b " . $file . '> W:\MiSeq\Illumina\MiSeqOutput\140929_M00321_0123_000000000-ABBEF\Data\Intensities\BaseCalls\ABBEF.md5');
}