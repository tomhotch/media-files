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

### gather_file_info
# Gather information about all files in a directory tree
# For now, it's just the name and the size - will add other info such as
# created or modified time later.
# Use a full path name to handle duplicate names in different directories.
#
# Returns a hash with the full path file name as the key, and the size of
# the file as the value.

# TODO: Is there a way to avoid _file_info having global scope in the package?
#       I couldn't figure out how to pass a paramater into a sub used by
#       File::Find.
my %_file_info = ();
sub gather_file_info {
    my ($self, $dir) = @_;
	#print "DEBUG: self, dir: $self, $dir\n";
	_gather_file_info($dir);
	return \%_file_info;
}
sub _gather_file_info {
    my ($dir) = @_;
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

### find_differences
# Gather file info from two directory trees.
#
# Return an array of strings listing the differences
# Return an empty array if the list of files and sizes are the same in
# both directory trees.

sub find_differences {
    my ($self, $source_dir, $dest_dir) = @_;
	my $source_file_info = _gather_file_info($source_dir);
	my $dest_file_info = _gather_file_info($dest_dir);
	# NEXT: Compare source and dest info and return differences.
	# return ('EXPECT TO FAIL');
}

1;