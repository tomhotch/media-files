###
# MediaFiles.pm
#   Library of functions for checking for media files in directories.
#   Useful for verifying that all media files from a camera have
#   been successfully copied to a hard drive.  Handles comparing
#   and renaming for cases when a camera re-uses numbers in file
#   names.  Most cameras don't ever re-use a number, but I have
#   a Flip that has this unfortunate behavoir.
#
# Usage   : TBD
# Purpose : TBD

package MediaFiles;

use strict;
use warnings FATAL => 'all';
use English qw(-no_match_vars);
use Carp qw(croak);

our ($VERSION) = 0.0.0;

use Path::Class;
use Const::Fast;

use Moo;

use lib 'lib';
use MediaFiles::Tree;

has src_dir => ( is => 'rw' );
has dest_dir => ( is => 'rw' );
has src_files_not_in_dest => (is => 'ro', default => sub {[]} );
has file_sizes_dont_match => (is => 'ro', default => sub {[]} );
has dest_files_not_in_src => (is => 'ro', default => sub {[]} );

my %_src_tree_info = ();
my %_dest_tree_info = ();

sub find_differences {
    my ( $self ) = @_;
	@{$self->src_files_not_in_dest} = ();
    @{$self->file_sizes_dont_match} = ();
	@{$self->dest_files_not_in_src} = ();
	
	# Gather directory tree information for source and dest dirs
	my $src_dir_tree = Tree->new( root_dir => $self->src_dir);
	my $dest_dir_tree = Tree->new( root_dir => $self->dest_dir);
	$src_dir_tree->gather_tree_info(\%_src_tree_info);
	$dest_dir_tree->gather_tree_info(\%_dest_tree_info);
	
	# Find and record differences between the src and dest dir trees
	foreach my $src_file ( keys %_src_tree_info ) {
		if (exists $_dest_tree_info{$src_file}) {
		    if ($_src_tree_info{$src_file} == $_dest_tree_info{$src_file}) {
			    # File name and size match - no difference.
			}
			else {
			    push @{$self->file_sizes_dont_match}, $src_file;
			}
			delete $_dest_tree_info{$src_file};
		}
		else {
		    push @{$self->src_files_not_in_dest}, $src_file;
		}
	}
	foreach my $dest_file ( keys %_dest_tree_info) {
	    push @{$self->dest_files_not_in_src}, $dest_file;
	}
	
	return 1;
}

sub num_src_files_not_in_dest {
    my ( $self ) = @_;
    return scalar (@{$self->src_files_not_in_dest});
}

sub num_dest_files_not_in_src {
    my ( $self ) = @_;
    return scalar (@{$self->dest_files_not_in_src});
}

sub num_file_sizes_dont_match {
    my ( $self ) = @_;
    return scalar (@{$self->file_sizes_dont_match});
}

1;