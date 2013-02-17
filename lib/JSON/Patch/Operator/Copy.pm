package JSON::Patch::Operator::Copy;

use strict;
use warnings;
use parent qw(JSON::Patch::Operator);

use JSON::Pointer;

sub name { 'copy' }
sub patch {
    my ($class, $ctx, $args) = @_;

    my $patched_document = JSON::Pointer->copy($ctx->{document}, $args->{from}, $args->{path});
    $ctx->{document} = $patched_document;

    return 1;
}

1;
