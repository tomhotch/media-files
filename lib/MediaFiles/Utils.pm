####
# MediaFiles::Utils.pm
# 
# Utilities for managing media files
# For copying, verifying, and renaming files from cameras to library folders
# on hard drives.
#

package Utils;

use strict;
use warnings FATAL => 'all';
use English qw(-no_match_vars);

use File::Find;
use Cwd qw(abs_path);

my %_file_info = ();
sub gather_file_info {
    my ($self, $dir) = @_;
    find(\&_get_file_info, $dir);
    return \%_file_info;
}

sub _get_file_info {
  #my $file = $File::Find::name;
  # TODO: How come $File::Find::name is not a full path?
  my $file = abs_path($_);
  if (-f $file) {
    $_file_info{$file} = -s $file;
  }
}

1;