use strict;
use warnings;
use Test::More;

use JSON::Patch;

sub test_test {
    my ($desc, %specs) = @_;
    my ($input, $expect) = @specs{qw/input expect/};

    subtest $desc => sub {
        my ($document, $path, $value) = @$input{qw/document path value/};
        my $ctx = JSON::Patch::Context->new(+{
            document => $document,
        });

        my $actual = JSON::Patch::Operator::Test->apply($ctx, +{
            path     => $path,
            value    => $value,
        });

        is(
            $actual,
            $expect,
        );
    };
}

test_test "Testing a Value: Success (/0)" => (
    input => +{
        document  => +{
            baz => "qux",
            foo => ["a",2,"c"],
        },
        path      => '/baz',
        value     => "qux",
    },
    expect => 1,
);

test_test "Testing a Value: Success (/1)" => (
    input => +{
        document  => +{
            baz => "qux",
            foo => ["a",2,"c"],
        },
        path      => '/foo/1',
        value     => 2,
    },
    expect => 1,
);

test_test "Testing a Value: Failure (/1)" => (
    input => +{
        document  => +{
            baz => "qux",
            foo => ["a",2,"c"],
        },
        path      => '/foo/1',
        value     => 3,
    },
    expect => 0,
);

done_testing;
