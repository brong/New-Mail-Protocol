#!/usr/bin/perl -w

use strict;
use warnings;

use JSON::XS;
use File::Slurp::Unicode;

my $datafile = shift || "data.json";

my $data = {};
if (-f $datafile) {
  $data = decode_json(read_file($datafile));
}

print "||||||'''RFC List'''||\n";
print "||RFC||Problem Solved||Plan for new Protocol||\n";

foreach my $num (sort { $a <=> $b } keys %$data) {
    print "||[[http://tools.ietf.org/html/rfc$num|RFC $num]] $data->{$num}||-||\n";
}

print "\n";
print "(auto-generated from the list stored at [[http://github.com/brong/New-Mail-Protocol/|Github]])\n";

