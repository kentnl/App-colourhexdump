use strict;
use warnings;

package App::colourhexdump::ColourProfile;
BEGIN {
  $App::colourhexdump::ColourProfile::VERSION = '0.01000020';
}

# ABSTRACT: A Role for Colour Profiles

use Moose::Role;
use namespace::autoclean;



requires 'get_colour_for';


requires 'get_display_symbol_for';

use Term::ANSIColor qw(:constants);


## no critic ( RequireArgUnpacking )

sub get_string_pre {
  my ( $self, $char ) = ( $_[0], $_[1] );
  my $colourcode = $self->get_colour_for($char);
  if ( defined $colourcode ) {
    return $colourcode;
  }
  return q{};
}


## no critic ( RequireArgUnpacking )

sub get_string_post {
  my ( $self, $char ) = ( $_[0], $_[1] );
  my $colourcode = $self->get_colour_for($char);
  if ( defined $colourcode ) {
    return RESET;
  }
  return q{};
}

no Moose::Role;

1;


__END__
=pod

=head1 NAME

App::colourhexdump::ColourProfile - A Role for Colour Profiles

=head1 VERSION

version 0.01000020

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

=head1 REQUIRED

=head2 get_colour_for

    my $colour = $object->get_colour_for( "\n" );

Return any string of data that should be prepended every time a given character is seen.

Generally, you only want to print ANSI Escape codes.

Don't worry about resetting things, we put a ^[[0m in for you.

Return C<undef> if you do not wish to apply colouring.

=head2 get_display_symbol_for

    my $symbol = $object->get_display_symbol_for( "\n" );

Returns a user viewable alternative to the matched string.

=head1 PROVIDED

=head2 get_string_pre

Wraps L<get_colour_for> and returns either a string sequence or ''.

=head2 get_string_post

Wraps L<get_colour_for> and returns either an ANSI Reset Code, or '', depending
on what was returned.

=head1 AUTHOR

Kent Fredric <kentnl@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by Kent Fredric <kentnl@cpan.org>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

