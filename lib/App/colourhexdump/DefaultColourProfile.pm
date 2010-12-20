use strict;
use warnings;

package App::colourhexdump::DefaultColourProfile;

use Moose;
use namespace::autoclean;

with 'App::colourhexdump::ColourProfile';

use Term::ANSIColor qw(:constants);

sub get_colour_for {
  my ( $self, $char ) = ( $_[0], $_[1] );

  return BLACK . ON_RED                 if $char =~ /\r/;
  return BOLD . BRIGHT_BLUE             if $char =~ /\n/;
  return BLUE                           if $char =~ / /;
  return BOLD . BRIGHT_BLUE . ON_YELLOW if $char =~ /\t/;
  return RED                            if $char =~ /[^[:print:]]/;
  return                                if $char =~ /[a-zA-Z0-9]/;
  return YELLOW;
}

sub get_display_symbol_for {
  my ( $self, $char ) = ( $_[0], $_[1] );
  return '_' if $char =~ /[\n\r\t ]/;
  return '.' if $char =~ /[^[:print:]]/;
  return $char;
}

__PACKAGE__->meta->make_immutable;
no Moose;
1;

