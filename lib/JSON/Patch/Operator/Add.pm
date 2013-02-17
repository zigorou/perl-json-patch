package JSON::Patch::Operator::Add;

use strict;
use warnings;
use parent qw(JSON::Patch::Operator);

use JSON::Pointer;

sub name { 'add' }
sub patch {
    my ($class, $ctx, $args) = @_;

    my $patched_document = JSON::Pointer->add($ctx->{document}, $args->{path}, $args->{value});
    $ctx->{document} = $patched_document;

    return 1;
}

1;
