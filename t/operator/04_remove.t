use strict;
use warnings;
use Test::More;

use JSON::Patch;

sub test_remove {
    my ($desc, %specs) = @_;
    my ($input, $expect) = @specs{qw/input expect/};

    subtest $desc => sub {
        my ($document, $path) = @$input{qw/document path/};
        my $ctx = JSON::Patch::Context->new(+{
            document => $document,
        });

        JSON::Patch::Operator::Remove->apply($ctx, +{
            path     => $path,
        });

        my $patched_document = $ctx->{document};
        is_deeply(
            $patched_document,
            $expect->{patched},
        );
    };
}

test_remove "removing an object member" => (
    input => +{
        document  => +{
            baz => "qux",
            foo => "bar",
        },
        path      => '/baz',
    },
    expect => +{
        patched => +{
            foo => "bar",
        },
    },
);

done_testing;
