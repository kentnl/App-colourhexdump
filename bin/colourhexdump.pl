#!/usr/bin/perl

use strict;
use warnings;

my $filename = $ARGV[0];

my $contents;

open my $fh, '<', $filename or die "Cant open $filename, $!";

my $row_length   = 32; # bytes per output line
my $chunk_length = 4; # bytes per display word.
my $endianness   = 1; # ordering of the bytes, 1 = character order , 0 = reverse character order.

use Term::ANSIColor qw(:constants);
use List::MoreUtils qw( natatime );

#my $print_length = $rowlength * 2 +
my $blength = 0;
my $yellow = YELLOW;
my $blue = BLUE;
my $red = RED;
my $green = GREEN;
my $reset = RESET;

sub encode_byte {
  my $char = shift;
  my $sym = unpack 'H*', $char;
  if ( $char =~ /[\r]/ ) {
    return [ $sym, BLACK . ON_RED, '_', $reset ];
  }
  if ( $char =~ /[\n]/ ) {
    return [ $sym, BOLD. BRIGHT_BLUE, '_', $reset ];
  }
  elsif ( $char =~ / / ) {
    return [ $sym, $blue, '_', $reset ];
  }
  elsif ( $char =~ /\t/ ) {
    return [ $sym, BOLD . BRIGHT_BLUE . ON_YELLOW , '_', $reset ];
  }
  elsif ( $char =~ /[^[:print:]]/ ) {
    return [ $sym, $red, '.', $reset ];
  }
  elsif ( $char =~ /[a-zA-Z0-9]/ ) {
    return [ $sym, '', $char, '' ];
  }
  return [ $sym, $yellow , $char, $reset ];
}

sub tokenize_line {
  map { encode_byte($_) } split //, shift @_;
}

sub build_chunk {
    my $chunk;
    my $strchunk;
    my $length;
    my $hidden = 0;

	  if( $endianness == 1 ) {
	    for (@_) {
  	    $chunk    .= $_->[1] . $_->[0] . $_->[3];
	   }
   } else {
      for (reverse @_) {
  	    $chunk    .= $_->[1] . $_->[0] . $_->[3];
	   }

   }
   for ( @_ ){
      $strchunk .= $_->[1] . $_->[2] . $_->[3];
      $length += 2;
      $hidden += length ( $_->[1] . $_->[3] )
    }
    return ( $chunk, $strchunk , $length, $hidden );
}

my $offset = 0;

while ( read $fh, my $buffer, $row_length ) {

  my @data = tokenize_line($buffer);

  my $it = natatime $chunk_length, @data;

  my @chunks;
  my @strchunks;
  my $length = 0;
  my $hidden = 0;

  while ( my @vals = $it->() ) {
    my ( $chunk, $strchunk, $l, $h ) = build_chunk( @vals );
    push @chunks,    $chunk;
    push @strchunks, $strchunk;
    $length += $l + 1;
    $hidden += $h;
  }
  my $offsethex = join q{}, unpack "H*", pack "N*", $offset;

  $blength = $length if $length > $blength;
  $length = $blength + $hidden;
  printf "%10s: %-${length}s  %s\n", $offsethex,  ( join q{ }, @chunks ),  ( join q{}, @strchunks );
  $offset += $row_length ;

}

