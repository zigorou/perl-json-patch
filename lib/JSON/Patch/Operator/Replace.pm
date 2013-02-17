package JSON::Patch::Operator::Replace;

use strict;
use warnings;
use parent qw(JSON::Patch::Operator);

use JSON::Pointer;

sub name { 'replace' }
sub patch {
    my ($class, $ctx, $args) = @_;

    my $patched_document = JSON::Pointer->replace($ctx->{document}, $args->{path}, $args->{value});
    $ctx->{document} = $patched_document;

    return 1;
}

1;
