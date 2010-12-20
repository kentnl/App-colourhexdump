#!/usr/bin/perl

use strict;
use warnings;

my $filename = $ARGV[0];

open my $fh, '<', $filename or die "Cant open $filename, $!";

use App::colourhexdump;

my $app = App::colourhexdump->new(
    row_length => 16,
    chunk_length =>16,
);

$app->format_foreach_in_fh( $fh, sub {
        print shift;
});

