package JSON::Patch::Operator::Move;

use strict;
use warnings;
use parent qw(JSON::Patch::Operator);

use JSON::Pointer;

sub name { 'move' }
sub patch {
    my ($class, $ctx, $args) = @_;

    my $patched_document = JSON::Pointer->move($ctx->{document}, $args->{from}, $args->{path});
    $ctx->{document} = $patched_document;

    return 1;
}

1;
