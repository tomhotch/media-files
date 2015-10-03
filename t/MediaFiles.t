###
# MediaFiles.t
#   Test MediaFiles.pm library

use strict;
use warnings FATAL => 'all';
use English qw(-no_match_vars);

use Test::More;
use Test::Exception;
use Const::Fast;
use YAML;

use lib 'lib';
use MediaFiles;

our ($VERSION) = 0.0.0;

###
# Test find_differences - matching case
# Verify no differences are found when directories match
#
my $src_dir  = './t/test_dir';
my $dest_dir = './t/test_dir';

my $differences = create_and_check_differences_object( $src_dir, $dest_dir);

ok( $differences->find_differences(),
    'Can call find_differences for matching directories' );
is( $differences->num_src_files_not_in_dest,
    0, 'All src tree files should be in dest tree' );
is( $differences->num_dest_files_not_in_src,
    0, 'All dest tree files should be in src tree' );

###
# Test find_differences - empty dir vs. a dir with files
# Empty src dir, files in dest dir and vice versa
#

const my $NUM_TEST_DIR_FILES => 5;

$src_dir  = './t/test_dir';
$dest_dir = './t/empty_dir';

$differences = create_and_check_differences_object( $src_dir, $dest_dir);

ok( $differences->find_differences(),
    'Can call find_differences for matching directories' );
is( $differences->num_src_files_not_in_dest,
    $NUM_TEST_DIR_FILES, 'All src tree files are not in dest tree' );
is( $differences->num_dest_files_not_in_src,
    0, 'All dest tree files should be in src tree' );

$src_dir  = './t/empty_dir';
$dest_dir = './t/test_dir';

$differences = create_and_check_differences_object( $src_dir, $dest_dir);

ok( $differences->find_differences(),
    'Can call find_differences for matching directories' );
is( $differences->num_src_files_not_in_dest,
    0, 'All src tree files should be in dest tree' );
is( $differences->num_dest_files_not_in_src,
    $NUM_TEST_DIR_FILES, 'All dest tree files are not in src tree' );
	
###
# Test find_differences - Mismatches
# Src file missing in dest dir
# Dest file missing in src dir
# File size mismatch
#

$src_dir  = './t/test_dir';
$dest_dir = './t/differences_dir';

$differences = create_and_check_differences_object( $src_dir, $dest_dir);

ok( $differences->find_differences(),
    'Can call find_differences for matching directories' );

# NEXT Create and test for differences in differences_dir.
# The number of differences below will not be zero.
# Add num_file_size_mismatch check

is( $differences->num_src_files_not_in_dest,
    0, 'All src tree files should be in dest tree' );
is( $differences->num_dest_files_not_in_src,
    0, 'All dest tree files are not in src tree' );

sub create_and_check_differences_object {
    my ($src_dir, $dest_dir) = @_;
	ok(
      (
          my $differences =
            MediaFiles->new( src_dir => $src_dir, dest_dir => $dest_dir )
      ),
      'Can create a MediaFiles object'
    );
    is( $differences->src_dir(), $src_dir, 'Can set MediaFiles src_dir attribute' );
    is( $differences->dest_dir(),
        $dest_dir, 'Can set MediaFiles src_dir attribute' );
	return $differences;
}

# my %src_tree_info = ();
# ok( $src_dir_tree->gather_tree_info(\%src_tree_info), 'Can gather dir tree info for src_dir' );
# open my $expected_results_fh, '<', "$SRC_DIR/gather_test_dir_results.yml";
# my $expected_results_ref = YAML::LoadFile($expected_results_fh);
# close $expected_results_fh;
# is_deeply( \%src_tree_info, $expected_results_ref, 'Got correct file info for t\test_dir');

done_testing();
