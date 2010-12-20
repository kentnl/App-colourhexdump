use strict;
use warnings;

package App::colourhexdump::DefaultColourProfile;

# ABSTRACT: The default colour profile

use Moose;
use namespace::autoclean;

=head1 SYNOPSIS

This is the default colour profile.

    \r           => black on red               '_'
    \n           => bold bright blue           '_'
    " "          => blue                       '_'
    \t           => bold bright blue on yellow '_'
    alphanumeric => white                      $char
    nonprintable => red                        '.'
    everything else => yellow                  $char

Invocation:

    my $cp = App::colourhexdump::DefaultColourProfile->new();
    my $colouredChar =
        $cp->get_string_pre( $char ) .
        $cp->get_dispaly_symbol_for( $char ) .
        $cp->get_string_post( $char );

=cut

with 'App::colourhexdump::ColourProfile';

use Term::ANSIColor 3.00 qw(:constants);

=method get_colour_for

See L<App::colourhexdump::ColourProfile/get_colour_for>

=cut

## no critic ( Subroutines::RequireArgUnpacking )
sub get_colour_for {
  my ( $self, $char ) = ( $_[0], $_[1] );

  return BLACK . ON_RED                 if $char =~ /\r/;
  return BOLD . BRIGHT_BLUE             if $char =~ /\n/;
  return BLUE                           if $char =~ / /;
  return BOLD . BRIGHT_BLUE . ON_YELLOW if $char =~ /\t/;
  return RED                            if $char =~ qr{[^[:print:]]};
  return                                if $char =~ qr{[a-zA-Z0-9]};
  return YELLOW;
}

=method get_display_symbol_for

See L<App::colourhexdump::ColourProfile/get_display_symbol_for>

=cut

## no critic ( Subroutines::RequireArgUnpacking )

sub get_display_symbol_for {
  my ( $self, $char ) = ( $_[0], $_[1] );
  return q{_} if $char =~ qr{[\n\r\t ]};
  return q{.} if $char =~ qr{[^[:print:]]};
  return $char;
}

__PACKAGE__->meta->make_immutable;
no Moose;
1;

