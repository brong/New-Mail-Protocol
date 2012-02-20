#!/usr/bin/perl -w

my $wikifile = shift || "wikidata.txt";

my $wikidata = {};
if (-f $wikifile) {
    $wikidata = read_wiki($wikifile);
}

foreach my $key (sort {$a <=> $b } keys %$wikidata) {
    print "$key\n";
}

exit 0;

sub read_wiki {
    my $file = shift;
    my %data;
    if (open(FH, "<$file")) {
        while (<FH>) {
            my @bits = split /[|]{2}/, $_;
            my $id = $bits[1];
            next unless $id =~ m/RFC (\d+)/;
            $data{$1} = {
                desc => $bits[2],
                res  => $bits[3],
            };
        };
        close(FH);
    }
    return \%data;
}
