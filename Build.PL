
use strict;
use warnings;

use Module::Build 0.3601;


my %module_build_args = (
  'build_requires' => {
    'English' => '0',
    'File::Find' => '0',
    'File::Temp' => '0',
    'Module::Build' => '0.3601',
    'Test::More' => '0.88'
  },
  'configure_requires' => {
    'Module::Build' => '0.3601'
  },
  'dist_abstract' => 'HexDump, but with character-class highlighting.',
  'dist_author' => [
    'Kent Fredric <kentnl@cpan.org>'
  ],
  'dist_name' => 'App-colourhexdump',
  'dist_version' => '0.01000103',
  'license' => 'perl',
  'module_name' => 'App::colourhexdump',
  'recommends' => {},
  'recursive_test_files' => 1,
  'requires' => {
    'Carp' => '0',
    'Class::Load' => '0.06',
    'Getopt::Long::Descriptive' => '0',
    'List::MoreUtils' => '0',
    'Moose' => '0',
    'Moose::Role' => '0',
    'MooseX::Getopt::Dashes' => '0',
    'MooseX::Getopt::GLD' => '0',
    'String::RewritePrefix' => '0',
    'Term::ANSIColor' => '3.00',
    'namespace::autoclean' => '0'
  },
  'script_files' => [
    'bin/colorhexdump',
    'bin/colourhexdump'
  ]
);


my $build = Module::Build->new(%module_build_args);

$build->create_build_script;
