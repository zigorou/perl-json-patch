package JSON::Patch::Operator::Test;

use strict;
use warnings;
use parent qw(JSON::Patch::Operator);

use JSON::Patch::Exception qw(:codes);
use JSON::Pointer;

sub name { 'test' }

sub validate {
    my ($class, $operation, $pos) = @_;

    unless (exists $operation->{path}) {
        JSON::Patch::Exception->throw(
            code => ERROR_INVALID_OPERATION_FIELD,
            message => "path field is required",
            path => "/$pos"
        );
    }

    unless (exists $operation->{value}) {
        JSON::Patch::Exception->throw(
            code => ERROR_INVALID_OPERATION_FIELD,
            message => "value field is required",
            path => "/$pos"
        );
    }

    return 1;

}

sub apply {
    my ($class, $ctx, $operation) = @_;
    my $is_success = JSON::Pointer->test($ctx->{document}, $operation->{path}, $operation->{value});
    $ctx->{result} = $is_success;

    return $is_success;
}

1;
