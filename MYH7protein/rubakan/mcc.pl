#!/usr/bin/perl -s

my $mcc = (($::tp * $::tn) - ($::fp * $::fn)) / 
    sqrt(($::tp+$::fp)*($::tp+$::fn)*($::tn+$::fp)*($::tn+$::fn));

print "MCC: $mcc\n";
