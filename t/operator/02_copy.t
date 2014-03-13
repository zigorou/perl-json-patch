use strict;
use warnings;
use Test::More;

use JSON::Patch;

sub test_copy {
    my ($desc, %specs) = @_;
    my ($input, $expect) = @specs{qw/input expect/};

    subtest $desc => sub {
        my ($document, $from, $path) = @$input{qw/document from path/};
        my $ctx = JSON::Patch::Context->new(+{
            document => $document,
        });

        JSON::Patch::Operator::Copy->apply($ctx, +{
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

test_copy "copy to new object field" => (
    input => +{
        document  => +{
            baz => [ +{ qux => "hello"} ],
            bar => 1,
        },
        from      => "/baz/0",
        path      => "/boo",
    },
    expect => +{
        patched => +{
            baz => [ +{ qux => "hello"} ],
            bar => 1,
            boo => +{ qux => "hello"},
        }
    }
);

done_testing;
