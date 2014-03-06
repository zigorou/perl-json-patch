use strict;
use warnings;
use Test::More;

use JSON::Patch;

sub test_replace {
    my ($desc, %specs) = @_;
    my ($input, $expect) = @specs{qw/input expect/};

    subtest $desc => sub {
        my ($document, $path, $value) = @$input{qw/document path value/};
        my $ctx = JSON::Patch::Context->new(+{
            document => $document,
        });

        JSON::Patch::Operator::Replace->apply($ctx, +{
            path     => $path,
            value    => $value,
        });

        my $patched_document = $ctx->{document};
        is_deeply(
            $patched_document,
            $expect->{patched},
        );
    };
}

test_replace "Replacing a Value" => (
    input => +{
        document  => +{
            baz => "qux",
            foo => "bar",
        },
        path      => '/baz',
        value     => "boo",
    },
    expect => +{
        patched => +{
            baz => "boo",
            foo => "bar",
        },
    },
);

done_testing;
