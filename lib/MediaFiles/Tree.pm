###
# Tree.pm
#   Library of directory tree functions
#
# Usage   : TBD
# Purpose : TBD

package Tree;

use strict;
use warnings FATAL => 'all';
use English qw(-no_match_vars);
use Carp qw(croak);

our ($VERSION) = 0.0.0;

use Path::Class;
use Const::Fast;

use Moo;

has root_dir => ( is => 'rw' );

### gather_tree_info
# Get information about all files recursively in a directory.

sub gather_tree_info {
    my ( $self, $tree_info_ref ) = @_;
    my $dir = dir( $self->root_dir );
    %$tree_info_ref = ();
    $dir->recurse(
        callback => sub {
            my ($path) = @_;
            if ( not $path->is_dir ) {

              # Strip off the root directory from the file path - this allows
              # files with the same name and sub-dir path from two different
              # root directories to match.  Retain any child directories to
              # disambiguate two files with same basename in different sub-dirs.
                my $size = $path->stat->size;
                my $index = ( index $path, $dir ) + length($dir) + 1;
                $path = substr $path, $index;
                $tree_info_ref->{$path} = $size;
            }
        }
    );
    return 1;
}

1;
