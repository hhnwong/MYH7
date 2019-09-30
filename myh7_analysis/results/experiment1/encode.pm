package encode;
use strict;

# Read a basic CSV file
sub ReadCSV
{
    my($fp) = @_;
    my @data = ();
    while(my $line = <$fp>)
    {
        chomp $line;
        my @fields = split(/\s*\,\s*/, $line);
        push @data, \@fields;
    }
    return(@data);
}

# Read sequence data from a FASTA file
sub ReadSequence
{
    my($filename) = @_;
    my $sequence = '';
    if(open(my $file, '<', $filename))
    {
        my @lines  = <$file>;
        foreach my $line (@lines)
        {
            chomp $line;
            if(! ($line =~ /^\>/))
            {
                $sequence .= $line;
            }
        }
        close $file;
    }
    return $sequence;
}

# Find the sequence around a specified position
sub FindWindow
{
    my($sequence, $resnum, $width) = @_;
    $resnum--;
    return(substr($sequence, $resnum-$width, 1+2*$width));
}

sub GetBLOSUMEncoding
{
    my($res, $hScores) = @_;
    my @data = ();
    foreach my $key (@::aas)
    {
        push @data, $$hScores{$res}{$key};
    }
    return(@data);
}

# Process all the mutations
sub PrintBLOSUMTitle
{
    foreach my $type ("Nat", "Mut")
    {
        foreach my $aa (@::aas)
        {
            print "$type$aa,";
        }
    }
    print "phenotype\n";
}

# Read a scoring matrix
sub ReadScoreMatrix
{
    my($filename) = @_;
    my @columnLabels = ();
    my %data;

    if(open(my $csvfile, '<', $filename))
    {
        while(my $line = <$csvfile>)
        {
            chomp;
            $line =~ s/\#.*//;
            if(length($line))
            {
                if($line =~ /^\s/)
                {
                    $line =~ s/^\s+//;
                    @columnLabels = split(/\s+/, $line);
                }
                else
                {
                    my @fields = split(/\s+/, $line);
                    my $rowLabel = shift(@fields);
                    my $columnNumber=0;
                    foreach my $field (@fields)
                    {
                        $data{$rowLabel}{$columnLabels[$columnNumber++]} = $field;
                    }
                }
            }
        }
        close($csvfile);
    }
    return(%data);
}

sub PrintSimpleTitle
{
    my($type) = @_;
    print "${type}Size,${type}Hyd,${type}Charge,${type}Arom,${type}S,${type}Conf";
}

sub GetSimpleEncoding
{
    my($aa) = @_;
    my %encoding = ();

#                     Size,Hydrophobicity, Charge, Arom, S, Conf
    $encoding{'A'} = [1,   0.250,          0,      0,    0, 0];
    $encoding{'C'} = [2,   0.040,          0,      0,    1, 0];
    $encoding{'D'} = [4,  -0.720,         -1,      0,    0, 0];
    $encoding{'E'} = [5,  -0.620,         -1,      0,    0, 0];
    $encoding{'F'} = [7,   0.610,          0,      1,    0, 0];
    $encoding{'G'} = [0,   0.160,          0,      0,    0, 1];
    $encoding{'H'} = [6,  -0.400,          0.5,    1,    0, 0];
    $encoding{'I'} = [4,   0.730,          0,      0,    0, 0];
    $encoding{'K'} = [5,  -1.100,          1,      0,    0, 0];
    $encoding{'L'} = [4,   0.530,          0,      0,    0, 0];
    $encoding{'M'} = [4,   0.260,          0,      0,    1, 0];
    $encoding{'N'} = [4,  -0.640,          0,      0,    0, 0];
    $encoding{'P'} = [3,  -0.070,          0,      0,    0, 1];
    $encoding{'Q'} = [5,  -0.690,          0,      0,    0, 0];
    $encoding{'R'} = [7,  -1.800,          1,      0,    0, 0];
    $encoding{'S'} = [2,  -0.260,          0,      0,    0, 0];
    $encoding{'T'} = [3,  -0.180,          0,      0,    0, 0];
    $encoding{'V'} = [3,   0.540,          0,      0,    0, 0];
    $encoding{'W'} = [10,  0.370,          0,      1,    0, 0];
    $encoding{'Y'} = [8,   0.020,          0,      1,    0, 0];

    return(@{$encoding{$aa}});
}


1;
