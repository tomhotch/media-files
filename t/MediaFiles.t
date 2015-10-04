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

is( $differences->num_src_files_not_in_dest,
    1, 'One source file should be missing in dest tree' );
is( $differences->num_dest_files_not_in_src,
    1, 'One dest file should be missing from source tree' );
	
# NEXT: Add a mismatch file size check.
# Add missing files from sub-dirs?
	
done_testing();

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
