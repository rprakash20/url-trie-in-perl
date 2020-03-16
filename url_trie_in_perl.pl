#!/usr/bin/perl -w

=pod
trie implementation to get optimized URL set from a large list of URLs 

https://en.wikipedia.org/wiki/Trie
=cut

use strict;
use Data::Dumper;

use constant {
    MAX_DEPTH_FOR_OPTIMIZATION => 3,
};

# File contains URLs
#my $filename = "/home/rprakash/urls.txt";
my $filename = "/home/rprakash/urls_1.txt";
my $parent_url_trie = {};
my @optimized_urls = ();

sub traverse_url_trie {
    my ($node, $parent_url, $recursion) = @_;
    $parent_url ||= "";
    $recursion ||= 0;

    my $tmp_url = ($parent_url ne "") ? $parent_url. "/". $node->{word} : "/". $node->{word};

    #print STDERR "\t PARENT URL => $parent_url URL => $tmp_url\n" if ($node->{end_of_url});

    if (scalar @{$node->{children}} > 0) {
        foreach (@{$node->{children}}) {
            traverse_url_trie($_, $tmp_url);
        }
    }
    return;
}

sub get_optimized_urls_from_trie {
    my ($node, $parent_url, $depth) = @_;
    $parent_url ||= "";
    $depth ||= 1;

    my $tmp_url = ($parent_url ne "") ? $parent_url. "/". $node->{word} : "/". $node->{word};

    #print STDERR "\tPARENT URL => $parent_url URL => $tmp_url depth => $depth\n";

    if (scalar @{$node->{children}} > 0) {
        $depth++;
        if ($depth <= MAX_DEPTH_FOR_OPTIMIZATION) {
            my @children = @{$node->{children}};
            if (scalar @children >=2 || $depth == MAX_DEPTH_FOR_OPTIMIZATION) {
                #print "\t Depth => $depth and children => ". scalar @children."\n";
                push @optimized_urls, "$tmp_url/";
            }
            else {
                foreach (@children) {
                    get_optimized_urls_from_trie($_, $tmp_url, $depth);
                }
            }
        }
    }
    return;
}

sub new_node {
    my ($word) = @_;
    my $node = {};
    $node->{word} = $word;
    $node->{children} = [];
    $node->{counter} = 1;
    $node->{end_of_url} = 0;
    return $node;
}

sub push_url_in_trie {
    my ($full_url, $root) = @_;

    # Strip first slash
    $full_url = substr($full_url, 1);

    my $node = $root;

    # TODO when you want something like "/bot/"
    #my @url_parts = split '/', $full_url;
    my @url_parts = split '/', $full_url, -1;

    #print Dumper(\@url_parts);

    foreach my $part (@url_parts) {
        my $found_in_child = 0;
        foreach my $child (@{$node->{children}}) {
            if ($child->{word} eq $part) {
                $child->{counter} += 1;
                $node = $child;
                $found_in_child = 1;
                last;
            }
        }

        if (!$found_in_child) {
            my $new_node = new_node($part);
            push @{$node->{children}}, $new_node;
            $node = $new_node;
        }
    }

    $node->{end_of_url} = 1;
}

open (my $fh, "<", $filename) or die "Unable to open file $filename: $!\n";

# add the root node
my $root_node = new_node('*');

while(<$fh>) {
    #print "$_";
    my $line = $_;
    chomp $line; 
    push_url_in_trie($line, $root_node); 
}

#print STDERR Dumper($root_node);

# Uncomment to traverse the trie to get all the URLs back again

#foreach my $child (@{$root_node->{children}}) {
#    traverse_url_trie($child);
#}

foreach my $child (@{$root_node->{children}}) {
    get_optimized_urls_from_trie($child);
}

print "Optimized URLs: ". Dumper(\@optimized_urls). "\n";
