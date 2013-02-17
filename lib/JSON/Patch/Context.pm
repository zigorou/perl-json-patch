package JSON::Patch::Context;

use strict;
use warnings;

use Class::Accessor::Lite (
    new => 0,
    rw  => [qw/document pos result/],
);

sub new {
    my $class = shift;
    my $args = ref $_[0] ? $_[0] : { @_ };
    %$args = (
        result => 1,
        pos    => 0,
        %$args
    );
    bless $args => $class;
}

1;
