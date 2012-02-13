#!/usr/bin/perl

use strict;
use warnings;

use Mojo::UserAgent;
use JSON::XS;
use File::Slurp::Unicode;

my $datafile = shift || "data.json";

my $data = {};
if (-f $datafile) {
  $data = decode_json(read_file($datafile));
}

my $ua = Mojo::UserAgent->new;

while (<>) {
    next if m/^\s*#/;
    next unless m/(\d+)/;
    my $num = $1;

    next if $data->{$num};

    my $url = "http://tools.ietf.org/html/rfc$num";
    my @meta = $ua->get($url)->res->dom->html->head->meta->each();
    foreach my $item (@meta) {
        next unless $item->{name};
        next unless $item->{name} eq 'DC.Title';
        $data->{$num} = $item->{content};
    }
}

write_file($datafile, encode_json($data));
