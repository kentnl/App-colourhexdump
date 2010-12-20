: use strict;
use warnings;

package App::colourhexdump;

# ABSTRACT: HexDump, but with character-class highlighting.

use Moose;
with qw( MooseX::Getopt::GLD MooseX::Getopt::Dashes );

use Getopt::Long::Descriptive;
use Term::ANSIColor qw( colorstrip );
use App::colourhexdump::Formatter;
use namespace::autoclean;

=head1 SYNOPSIS

=cut

has colour_profile => (
  metaclass     => 'Getopt',
  isa           => "Str",
  is            => 'rw',
  default       => 'DefaultColourProfile',
  cmd_aliases   => [qw/ C color-profile /],
  documentation => 'Backend to use for colour highlighting (DefaultColourProfile)',
);

has row_length => (
  metaclass     => 'Getopt',
  isa           => 'Int',
  is            => 'ro',
  default       => 32,
  cmd_aliases   => [qw/ r row /],
  documentation => 'Number of bytes per display row (32).',

);

has chunk_length => (
  metaclass     => 'Getopt',
  isa           => 'Int',
  is            => 'rw',
  default       => 4,
  cmd_aliases   => [qw/ x chunk /],
  documentation => 'Number of bytes per display hex display group (4).'
);

has _files => (
  metaclass     => 'Getopt',
  isa           => 'ArrayRef[Str]',
  is            => 'rw',
  default       => sub { [] },
  cmd_flag      => 'file',
  cmd_aliases   => [qw/ f /],
  documentation => 'Add a file to the list of files to process. \'-\' for STDIN.'

);

has 'show_file_prefix' => (
  metaclass     => 'Getopt',
  isa           => 'Bool',
  is            => 'rw',
  default       => 0,
  documentation => 'Enable printing the filename on the start of every line ( off ).',

);
has 'show_file_heading' => (
  metaclass     => 'Getopt',
  isa           => 'Bool',
  is            => 'rw',
  default       => 0,
  documentation => 'Enable printing the filename before the hexdump output. ( off ).'
);
has 'colour' => (
  metaclass     => 'Getopt',
  isa           => 'Bool',
  is            => 'rw',
  default       => 1,
  cmd_aliases   => [qw/ c color /],
  documentation => 'Enable coloured output ( on ). --no-colour to disable.'

);

sub BUILD {
  my $self = shift;
  push @{ $self->_files() }, @{ $self->extra_argv };
  return $self;

}

sub get_filehandle {
  my ( $self, $filename ) = @_;
  if ( $filename eq q[-] ) {
    return \*STDIN;
  }
  require Carp;
  open my $fh, '<', $filename or Carp::confess("Cant open $_ , $!");
  return $fh;
}

sub run {
  my $self = shift;
  if ( not @{ $self->_files } ) {
    push @{ $self->_files }, q[-];
  }
  local $ENV{ANSI_COLORS_DISABLED} = $ENV{ANSI_COLORS_DISABLED};
  if ( not $self->colour ) {
    $ENV{ANSI_COLORS_DISABLED} = 1;
  }
  for ( @{ $self->_files } ) {
    my $prefix = '';
    if ( $self->show_file_prefix ) {
      $prefix = $_;
    }
    if ( length($prefix) ) {
      $prefix .= ':';
    }
    if ( $self->show_file_heading ) {
      print "-- Contents of $_ --\n";
    }
    my $formatter = App::colourhexdump::Formatter->new(
      colour_profile => $self->colour_profile,
      row_length     => $self->row_length,
      chunk_length   => $self->chunk_length,
    );

    $formatter->format_foreach_in_fh(
      $self->get_filehandle($_),
      sub {
        print $prefix . shift;
      }
    );
  }
}

__PACKAGE__->meta->make_immutable;
no Moose;
1;
