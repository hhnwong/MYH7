#!/usr/bin/perl 
use strict;
use lib '..';
use encode;

@::aas = qw/A C D E F G H I K L M N P Q R S T V W Y/;

my $seqFile = shift(@ARGV);
my $mutFile = shift(@ARGV);
my $matFile = shift(@ARGV);

my $sequence  = encode::ReadSequence($seqFile);
my @mutations = ReadMutations($mutFile);
my %scores    = encode::ReadScoreMatrix($matFile);


ProcessData($sequence, \@mutations, 0, \%scores);






# Read the mutation data from the CSV file - keep only columns of interest
sub ReadMutations
{
    my($filename) = @_;
    my @outdata = ();
    if(open(my $file, '<', $filename))
    {
        my @data = encode::ReadCSV($file);
        for(my $i=0; $i<scalar(@data); $i++)
        {
            if($i)
            {
                $outdata[$i-1][0] = $data[$i][0];
                $outdata[$i-1][1] = $data[$i][1];
                $outdata[$i-1][2] = $data[$i][2];
                $outdata[$i-1][3] = $data[$i][17];
            }
        }
        close $file;
    }

    return @outdata;
}

# Print a data point
sub PrintData
{
    my($sequence, $width, $aRow, $hScores) = @_;
    my $window = encode::FindWindow($sequence, $$aRow[0], $width);
    my @encodingNative = encode::GetBLOSUMEncoding($$aRow[1], $hScores);
    my @encodingMutant = encode::GetBLOSUMEncoding($$aRow[2], $hScores);
#    print $window.",".$$aRow[2].",".$$aRow[3]."\n";
    print join(',',@encodingNative) . "," . join(',',@encodingMutant) . "," . $$aRow[3] . "\n";
}

sub ProcessData
{
    my($sequence, $aMutations, $width, $hScores) = @_;
    encode::PrintBLOSUMTitle();

    foreach my $aRow (@$aMutations)
    {
        if(($$aRow[3] eq 'HCM') || 
           ($$aRow[3] eq 'DCM'))
        {
            PrintData($sequence, $width, $aRow, $hScores);
        }
    }
}

