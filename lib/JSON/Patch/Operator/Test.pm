package JSON::Patch::Operator::Test;

use strict;
use warnings;
use parent qw(JSON::Patch::Operator);

use JSON::Pointer;

sub name { 'test' }
sub patch {
    my ($class, $ctx, $args) = @_;

    my $is_success = JSON::Pointer->test($ctx->{document}, $args->{path}, $args->{value});
    return $is_success;
}

1;
