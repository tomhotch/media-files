####
# MediaFiles::Utils.t
# 
# Test MediaFiles::Utils.pm

use strict;
use warnings FATAL => 'all';
use English qw(-no_match_vars);

use Test::More;
use YAML;

use lib 'lib';
use MediaFiles::Utils;

# Test gather_file_info
# Verify gather_file_info can read all files and sizes in a directory
# TODO: Verify sub-directories with duplicate file names

my $test_dir = 't\test_dir';
my $file_info_ref;
can_ok('Utils', qw(gather_file_info));
ok ( $file_info_ref = Utils->gather_file_info($test_dir),
    'Able to gather file info from test_dir' );

# Check against expected results
open my $expected_results_fh, '<', 't\test_dir\expected_results.yml';
my $expected_results = YAML::LoadFile($expected_results_fh);
close $expected_results_fh;
is_deeply( $expected_results, $file_info_ref, 'Got correct file info for t\test_dir');

# NEXT: Add other test cases for gather file info?  Any more needed?
# NEXT: Add compare routine to make sure two directories have the same files and sizes

# Used one time to create an initial YAML file with expected results
# print Dump( $file_info_ref ), "\n";

# Print contents of file_info for debugging
#foreach my $file (keys(%$file_info_ref)) {
#    my $size = %$file_info_ref{$file};
#    print "$file is size: $size\n";
#}

done_testing;