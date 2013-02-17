package JSON::Patch::Operator::Copy;

use strict;
use warnings;
use parent qw(JSON::Patch::Operator);

use JSON::Pointer;

sub name { 'copy' }

sub validate {
    my ($class, $operation, $pos) = @_;
}

sub apply {
    my ($class, $ctx, $operation) = @_;

    my $patched_document = JSON::Pointer->copy($ctx->{document}, $operation->{from}, $operation->{path});
    $ctx->{document} = $patched_document;

    return 1;
}

1;
