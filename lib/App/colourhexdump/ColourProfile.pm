use 5.006;    # our
use strict;
use warnings;

package App::colourhexdump::ColourProfile;

our $VERSION = '1.000003';

# ABSTRACT: A Role for Colour Profiles

# AUTHORITY

use Moose::Role qw( requires );
use namespace::autoclean;

=requires C<get_colour_for>

    my $colour = $object->get_colour_for( "\n" );

Return any string of data that should be prepended every time a given character is seen.

Generally, you only want to print ANSI Escape codes.

Don't worry about resetting things, we put a C<^[[0m> in for you.

Return C<undef> if you do not wish to apply colouring.

=cut

requires 'get_colour_for';

=requires C<get_display_symbol_for>

    my $symbol = $object->get_display_symbol_for( "\n" );

Returns a user viewable alternative to the matched string.

=cut

requires 'get_display_symbol_for';

no Moose::Role;

use Term::ANSIColor 3.00 qw( RESET );

=method C<get_string_pre>

Wraps L</get_colour_for> and returns either a string sequence or ''.

=cut

## no critic ( RequireArgUnpacking )

sub get_string_pre {
  my ( $self, $char ) = ( $_[0], $_[1] );
  my $colourcode = $self->get_colour_for($char);
  if ( defined $colourcode ) {
    return $colourcode;
  }
  return q{};
}

=method C<get_string_post>

Wraps L</get_colour_for> and returns either an ANSI Reset Code, or '', depending
on what was returned.

=cut

## no critic ( RequireArgUnpacking )

sub get_string_post {
  my ( $self, $char ) = ( $_[0], $_[1] );
  my $colourcode = $self->get_colour_for($char);
  if ( defined $colourcode ) {
    return RESET;
  }
  return q{};
}

1;

=head1 SYNOPSIS

    package App::colourhexdump::ColourProfileName

    use Moose;
    with qw( App::colourhexdump::ColourProfile );

    sub get_colour_for {
        my ( $self, $char ) = @_ ;
        ...
        return "\e[31m" if /badthings/;
        return undef;    # don't colour
    }
    sub get_display_symbol_for {
        my ($self, $char) = @_ ;
        ...
        return '.' if $char =~ /badthings/
        return $char;        # printable
    }


=cut
