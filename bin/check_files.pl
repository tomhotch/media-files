#!/drives/c/Strawberry/perl/bin/perl

###
# check_files.pl
# Purpose:
# Check the files recursively in a source and destination directory tree.
# Report differences to stdout:
# - Source files that don't exist in the dest tree
# - Dest files that don't exist in the source tree
# - Files that match in name but differ in size.
#
# Usage: check_files.pl -s <src_dir> -d <dest_dir>

use strict;
use warnings FATAL => 'all';
use English qw(-no_match_vars);

use Getopt::Long;
use Pod::Usage;

use lib 'lib';
use MediaFiles;

# Use the current directory as the default for src and dest dirs
my $help = 0;
my $src_dir = '.';
my $dest_dir = '.';
GetOptions ("help|?" => \$help,
			"src_dir=s" => \$src_dir,
            "dest_dir=s" => \$dest_dir)
	or pod2usage(-exitval => 2, -verbose => 1);

pod2usage( -exitval => 1, -verbose => 1) if $help;
# NEXT: Finish adding help/usage

my $differences =
              MediaFiles->new( src_dir => $src_dir, dest_dir => $dest_dir );
$differences->find_differences();

my $time = localtime;
print "Checking files: $time\n";
print "Source Dir: $src_dir\n";
print "Dest Dir: $dest_dir\n\n";

# NEXT STEPS
# Print number of files in src and dest directories
# - Should I have sub-hashes in the files hash to capture multiple properties?
#   e.g. Mod time, created time, date taken?
# - Create a CLI with options - what differences to print
# - Use Moo objects instead of hashes for file info
# - Optionally check MD5 sum, not just sizes?
# - Add tests for check_files.pl?

### TODO: Is there a way to get rid of this mostly repetitive code?
### TODO: Add options to print or not print the different cases.
# Are all the source dir files in the dest dir?
if ( $differences->num_src_files_not_in_dest == 0 ) {
	print "OK: All source dir files are in dest dir\n";
}
else {
	print "MISMATCH: " . $differences->num_src_files_not_in_dest . " files in source dir not found in dest dir:\n";
	foreach my $file ( @{$differences->src_files_not_in_dest} ) {
		print "$file\n";
	}
}

# Do all the file sizes match?
if ( $differences->num_file_sizes_dont_match == 0 ) {
	print "OK: All source dir files have the same size as dest dir files\n";
}
else {
	print "MISMATCH: " . $differences->num_file_sizes_dont_match . " files in source dir have different size than files in dest dir:\n";
	foreach my $file ( @{$differences->file_sizes_dont_match} ) {
		print "$file\n";
	}
}

# Are all the dest dir files in the src dir?
# if ( $differences->num_dest_files_not_in_src == 0 ) {
	# print "OK: All dest dir files are in src dir\n";
# }
# else {
	# print "MISMATCH: " . $differences->num_dest_files_not_in_src . " files in dest dir not found in src dir:\n";
	# foreach my $file ( @{$differences->dest_files_not_in_src} ) {
		# print "$file\n";
	# }
# }

__END__

=head1 NAME

check_files.pl - Check files in a source and destination directory

=head1 SYNOPSIS

check_files.pl [--src_dir <src_dir> --dest_dir <dest_dir>]

Recursive check of files in a source directory to files in a destination
directory.  Report the following differences: Files in the source directory tree that don't exist in the destination
directory tree.  Files in the destination directory tree that don't exist in the source
directory tree. Files that exist in both source and destination trees with differnt
file sizes.

=head1 OPTIONS

=over 4

=item B<--help>
Print help message and exit

=item B<--src_dir>
Source directory to check, default: cwd
 
=item B<--dest_dir>
Destination directory to check, default: cwd

=back


=cut