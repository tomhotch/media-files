###
# Tree.t
#   Test Tree.pm library

use strict;
use warnings FATAL => 'all';
use English qw(-no_match_vars);

use Test::More;
use Test::Exception;
use Const::Fast;
use YAML;

use lib 'lib';
use MediaFiles::Tree;

our ($VERSION) = 0.0.0;

###
# Source Directory Test
# Make sure we can correctly gather data from a source directory that
# has files in it.
const my $SRC_DIR => './t/test_dir';

ok( ( my $src_dir_tree = Tree->new( root_dir => $SRC_DIR) ), 'Can create a Tree object for src_dir' );
is( $src_dir_tree->root_dir(), $SRC_DIR, 'Can set Tree root_dir attribute for src_dir' );

my %src_tree_info = ();
ok( $src_dir_tree->gather_tree_info(\%src_tree_info), 'Can gather dir tree info for src_dir' );
open my $expected_results_fh, '<', "$SRC_DIR/gather_test_dir_results.yml";
my $expected_results_ref = YAML::LoadFile($expected_results_fh);
close $expected_results_fh;
is_deeply( \%src_tree_info, $expected_results_ref, 'Got correct file info for t\test_dir');

###
# Empty Directory Test
const my $EMPTY_DIR => './t/empty_dir';

ok( ( my $empty_dir_tree = Tree->new( root_dir => $EMPTY_DIR) ), 'Can create a Tree object for empty dir' );
is( $empty_dir_tree->root_dir(), $EMPTY_DIR, 'Can set Tree root_dir attribute for empty dir' );

my %empty_tree_info = ();
ok( $empty_dir_tree->gather_tree_info(\%empty_tree_info), 'Can gather dir tree info for empty_dir' );
is (%empty_tree_info, 0, 'There should be no files in an empty dir');

is_deeply( \%src_tree_info, $expected_results_ref, 'Still have correct data for t\test_dir');

###
# Non-existent directory

const my $NON_EXIST_DIR => './t/non_exist_dir';

ok( ( my $non_exist_dir_tree = Tree->new( root_dir => $NON_EXIST_DIR) ), 'Can create a Tree object for non-existent dir' );
is( $non_exist_dir_tree->root_dir(), $NON_EXIST_DIR, 'Can set Tree root_dir attribute for non-existent dir' );
throws_ok { $non_exist_dir_tree->gather_tree_info() } qr/non_exist_dir/, 'Non-existent directory throws an exception';

# NEXT: Should gather_tree_info return something meaningful?

done_testing();