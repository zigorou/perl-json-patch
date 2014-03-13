use strict;
use warnings;
use Test::More;

use JSON::Patch;

sub test_move {
    my ($desc, %specs) = @_;
    my ($input, $expect) = @specs{qw/input expect/};

    subtest $desc => sub {
        my ($document, $from, $path) = @$input{qw/document from path/};
        my $ctx = JSON::Patch::Context->new(+{
            document => $document,
        });

        JSON::Patch::Operator::Move->apply($ctx, +{
            from     => $from,
            path     => $path,
        });

        my $patched_document = $ctx->{document};
        is_deeply(
            $patched_document,
            $expect->{patched},
        );
    };
}

test_move "Moving a Value" => (
    input => +{
        document  => +{
            "foo" => +{
                "bar" => "baz",
                "waldo" => "fred",
            },
            "qux" => +{
                "corge" => "grault"
            },
        },
        from      => "/foo/waldo",
        path      => "/qux/thud",
    },
    expect => +{
        patched => +{
            "foo" => +{
                "bar" => "baz",
            },
            "qux" => +{
                "corge" => "grault",
                "thud"  => "fred",
            },
        },
    },
);

done_testing;
