#
#===============================================================================
#

use strict;
use warnings;

package App::colourhexdump::ColourProfile;

use Moose::Role;
use namespace::autoclean;

requires 'get_colour_for';
requires 'get_display_symbol_for';

use Term::ANSIColor qw(:constants);

sub get_string_pre {
    my ( $self, $char )  = ( $_[0], $_[1] );
    my $colourcode = $self->get_colour_for($char);
    if ( defined $colourcode ){
        return $colourcode;
    }
    return '';
}

sub get_string_post {
    my ( $self, $char )  = ( $_[0], $_[1] );
    my $colourcode = $self->get_colour_for($char);
    if ( defined $colourcode ){
        return RESET;
    }
    return '';
}
sub get_encode_pair {
  my ( $self, $char ) = ( $_[0], $_[1] );
  my $sym        = unpack 'H*', $char;
  my $colourcode = $self->get_colour_for($char);
  my $dsymbol    = $self->get_display_symbol_for($char);
  return [ $sym, ( defined $colourcode ? $colourcode : q{} ), $dsymbol, ( defined $colourcode ? RESET : q{} ) ];

}

no Moose::Role;

1;

