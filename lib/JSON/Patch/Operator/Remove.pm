package JSON::Patch::Operator::Remove;

use strict;
use warnings;
use parent qw(JSON::Patch::Operator);

use JSON::Pointer;

sub name { 'remove' }
sub patch {
    my ($class, $ctx, $args) = @_;

    my $patched_document = JSON::Pointer->remove($ctx->{document}, $args->{path});
    $ctx->{document} = $patched_document;

    return 1;
}

1;
