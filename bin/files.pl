# Script to experiment with Perl file operations.
# I am working on making a set of utilities for managing media-files from cameras.

use File::Find;

my $source_dir = 'T:\My_Videos\from-flip-camera';

my $time = localtime;
print "$time\n";

# Gather data about all the files in the source directory.
# Use the full filename path as the hash key to avoid problems
# caused by multiple files with same name in different sub-directories.

my %source_files = ();
find(\&gather_file_stats, $source_dir);

sub gather_file_stats {
  my $file = $_;
  if (-f $file) {
    $source_files{$File::Find::name} = -s $file;
  }
}

# Print the file names and sizes from the source dir.
foreach my $file (keys(%source_files)) {
  print "$file is size: $source_files{$file}\n";
}

# NEXT STEPS
# - Print number of files found in source and dest directories
# - Should I have sub-hashes in the files hash to capture multiple properties?
#   e.g. Mod time, created time, date taken?
# - Add a dest directory
# - Compare the source to the dest directory
#   Everything in source should be in dest
#   Everything in dest should be in source
# - Start using Test::More .t files to test things