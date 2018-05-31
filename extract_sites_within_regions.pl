#!/usr/bin/perl -w
use strict;
use Data::Dumper;
die "perl $0 <region file> <depth file> <out file>\n" unless (@ARGV == 3);

my $region = $ARGV[0];
my $depthfile = $ARGV[1];
my $outfile = $ARGV[2];

open (IN1, $region);
open (IN2, $depthfile);
open (OUT1, ">", $outfile);

#########################
my %region;

while (<IN1>){
    chomp;
    my ($Chr, $start, $end) = split;
    push @{$region{$Chr}}, [$start,$end];
}
close IN1;


my $flag = 0;
my $prechr;
while (<IN2>){
    chomp;
    my ($chr, $pos, @depth) = split;
    if (!defined($region{$chr})){next;}
    if ($prechr && $chr ne $prechr){$flag = 0;}
    $prechr = $chr;
    for (my $i = $flag; $i < @{$region{$chr}}; $i++)
    {   
        if ($pos <= ${${$region{$chr}}[$i]}[1] && $pos >= ${${$region{$chr}}[$i]}[0])
        {
            print OUT1 "$_\n";
            last;
        }
        elsif ($pos < ${${$region{$chr}}[$i]}[0]){last;}
        elsif ($pos > ${${$region{$chr}}[$i]}[1]){ $flag++;}
    }
}

close IN2;
close OUT1;
