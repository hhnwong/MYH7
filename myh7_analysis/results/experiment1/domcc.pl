#!/usr/bin/perl
use strict;

my $inStrat = 0;
my $inData = 0;
my $line   = 0;
my @data = ();
my $nFields = 0;
my $nMCC = 0;

while(<>)
{
    chomp;
    if(/Stratified/)
    {
        $inStrat = 1;
    }
    elsif($inStrat && /Confusion Matrix/)
    {
        $inData = 1;
    }
    elsif($inData)
    {
        s/^\s+//;
        if(length)
        {
            if(/\<\-/)
            {
                s/\<.*//;
                my @fieldNames = split;
                $nFields = int(@fieldNames);
            }
            else
            {
                s/\s\|.*//;
                my @fields = split;
                for(my $i=0; $i<int(@fields); $i++)
                {
                    $data[$line][$i] = $fields[$i];
                }
                $line++;
            }
        }    
        else
        {
            if($nFields)
            {
                last;
            }
        }
    }
}

# Analyze the data
my ($tp, $tn, $fp, $fn, $meanMCC);
$meanMCC = 0;
for(my $type=0; $type<$nFields; $type++)
{
    $tp = $data[$type][$type];
    $fn = 0;
    for(my $i=0; $i<$nFields; $i++)
    {
        if($i != $type)
        {
            $fn += $data[$type][$i];
        }
    }
    $fp = 0;
    for(my $i=0; $i<$nFields; $i++)
    {
        if($i != $type)
        {
            $fp += $data[$i][$type];
        }
    }
    $tn = 0;
    for(my $i=0; $i<$nFields; $i++)
    {
        if($i != $type)
        {
            for(my $j=0; $j<$nFields; $j++)
            {
                if($j != $type)
                {
                    $tn += $data[$i][$j];
                }
            }
        }
    }

    print "\n\nType $type\n";
    printf "%3d %3d\n",   $tp, $fn;
    printf "%3d %3d\n", $fp, $tn;
    my $result = `~/scripts/mcc.pl -tp=$tp -fp=$fp -tn=$tn -fn=$fn 2>/dev/null`;
    if($result =~ /MCC/)
    {
        $result =~ s/MCC:\s+//;
        printf "MCC=%.3f\n", $result;
        $meanMCC += $result;
        $nMCC++;
    }
    else
    {
        printf "Class not predicted so unable to calculate MCC\n";
    }
}

printf "\nMean MCC=%.3f\n", ($meanMCC/$nMCC) if($nMCC);

#for(my $i=0; $i<$nFields; $i++)
#{
#    for(my $j=0; $j<$nFields; $j++)
#    {
#        printf "%3d ", $data[$i][$j];
#    }   
#    print "\n";
#}
