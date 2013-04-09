use strict;
use warnings;

package App::colourhexdump::DefaultColourProfile;
BEGIN {
  $App::colourhexdump::DefaultColourProfile::AUTHORITY = 'cpan:KENTNL';
}
{
  $App::colourhexdump::DefaultColourProfile::VERSION = '0.01011317';
}

# ABSTRACT: The default colour profile

use Moose;
use namespace::autoclean;


with 'App::colourhexdump::ColourProfile';

use Term::ANSIColor 3.00 qw(:constants);


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

__END__

=pod

=head1 NAME

App::colourhexdump::DefaultColourProfile - The default colour profile

=head1 VERSION

version 0.01011317

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

=head1 METHODS

=head2 get_colour_for

See L<App::colourhexdump::ColourProfile/get_colour_for>

=head2 get_display_symbol_for

See L<App::colourhexdump::ColourProfile/get_display_symbol_for>

=head1 AUTHOR

Kent Fredric <kentnl@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Kent Fredric <kentnl@cpan.org>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
