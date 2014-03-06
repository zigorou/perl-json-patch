use strict;
use warnings;
use Test::More;

use JSON::Patch;

sub test_add {
    my ($desc, %specs) = @_;
    my ($input, $expect) = @specs{qw/input expect/};

    subtest $desc => sub {
        my ($document, $path, $value) = @$input{qw/document path value/};
        my $ctx = JSON::Patch::Context->new(+{
            document => $document,
        });

        JSON::Patch::Operator::Add->apply($ctx, +{
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

test_add "add with existing object field" => (
    input => +{
        document  => +{ a => +{ foo => 1 } },
        path      => '/a/b',
        value     => "qux",
    },
    expect => +{
        patched => +{
            a => +{ foo => 1, b => "qux" }
        }
    }
);

done_testing;
