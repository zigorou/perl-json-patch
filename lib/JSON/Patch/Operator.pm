package JSON::Patch::Operator;

use strict;
use warnings;

sub name { '' }
sub validate { 0; }
sub apply {
    my ($class, $ctx, $opration) = @_;
}

1;
