package JSON::Patch::Operator::Move;

use strict;
use warnings;
use parent qw(JSON::Patch::Operator);

use JSON::Patch::Exception qw(:codes);
use JSON::Pointer;

sub name { 'move' }

sub validate {
    my ($class, $operation, $pos) = @_;

    unless (exists $operation->{from}) {
        JSON::Patch::Exception->throw(
            code => ERROR_INVALID_OPERATION_FIELD,
            message => "from field is required",
            path => "/$pos"
        );
    }

    unless (exists $operation->{path}) {
        JSON::Patch::Exception->throw(
            code => ERROR_INVALID_OPERATION_FIELD,
            message => "path field is required",
            path => "/$pos"
        );
    }

    return 1;

}

sub apply {
    my ($class, $ctx, $operation) = @_;
    my $patched_document = JSON::Pointer->move($ctx->{document}, $operation->{from}, $operation->{path});
    $ctx->{document} = $patched_document;

    return 1;
}

1;
