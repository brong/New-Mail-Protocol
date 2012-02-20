#!/usr/bin/perl -w

use strict;
use warnings;

use JSON::XS;
use File::Slurp::Unicode;

my $datafile = shift || "data.json";
my $wikifile = shift || "wikidata.txt";

my $data = {};
if (-f $datafile) {
  $data = decode_json(read_file($datafile));
}

my $wikidata = {};
if (-f $wikifile) {
    $wikidata = read_wiki($wikifile);
}

print <<EOF;
= RFC List =

Every RFC is the work of someone who felt enough pain from the
lack of something that they would make the effort to write the
document.  These problems need to be solved somehow - maybe
inherently in a different protocol, maybe explicitly.

||||||'''RFC List'''||
||RFC||Problem Solved||Plan for new Protocol||
EOF

foreach my $num (sort { $a <=> $b } keys %$data) {
    my $url = "http://tools.ietf.org/html/rfc$num";
    my $title = $data->{$num};
    my $desc = $wikidata->{$num}{desc} || '';
    my $res = $wikidata->{$num}{res} || '';
    print "||[[$url|RFC $num]] $title||$desc||$res||\n";
}

print "\n";
print "(auto-generated from the list stored at " .
      "[[http://github.com/brong/New-Mail-Protocol/|Github]])\n";

exit 0;

sub read_wiki {
    my $file = shift;
    my %data;
    if (open(FH, "<$file")) {
        while (<FH>) {
            my @bits = split /[|]{2}/, $_;
            my $id = $bits[1];
            next unless $id =~ m/RFC (\d+)\]/;
            $data{$1} = {
                desc => $bits[2],
                res  => $bits[3],
            };
        };
        close(FH);
    }
    return \%data;
}
