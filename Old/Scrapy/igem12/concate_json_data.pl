#! /usr/bin/perl -w
# concate_json_dat (for iGEM data) 
# 03/25/2013
# Konrad Herbst
# k.herbst@stud.uni-heidelberg.de


use strict; use warnings;

use JSON::XS;
use Data::Dumper;

my $aFile = "abstracts.json";
my $rFile = "results.json";
my $tFile = "tracks.json";

open(FH1, $aFile) or die "Could not open $aFile: $!\n";
open(OUT, ">test.json") or die "Could not open test.json: $!\n";
#open(FH2, $aFile) or die "Could not open $aFile: $!\n";
#open(FH3, $aFile) or die "Could not open $aFile: $!\n";
#$perl_scalar = decode_json $json_text
#$json_text = encode_json $perl_scalar

my $json = "";
while(<FH1>) {
  $json .= $_;
}
my $abstract = decode_json($json);
print $abstract->[1]{name}[0];
my $i = 0;
my %test;
while($abstract->[$i]) {
#  print $abstract->[$i]{name}[0];
  $test{$abstract->[$i]{name}[0]}=$i;
  $i++;
}
my $json_text = encode_json %test;

print length @$abstract;
