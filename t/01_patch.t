use strict;
use warnings;
use Test::More;

use JSON::Patch;

sub test_patch {
    my ($desc, %specs) = @_;
    my ($input, $expect) = @specs{qw/input expect/};

    subtest $desc => sub {
        my $patch = JSON::Patch->new(
            operations => $input->{operations},
        );

        my $patched = $patch->patch($input->{document});
        is_deeply(
            $patched->{document},
            $expect->{patched_document},
        );
    };
}

test_patch "patched document" => (
    input => +{
        document   => +{ a => +{ b => { c => "foo"} } },
        operations => [
            { op => "test",    path => "/a/b/c", value => "foo" },
            { op => "remove",  path => "/a/b/c" },
            { op => "add",     path => "/a/b/c", value => ["foo","bar"] },
            { op => "replace", path => "/a/b/c", value => 42 },
            { op => "move",    from => "/a/b/c", path  => "/a/b/d" },
            { op => "copy",    from => "/a/b/d", path  => "/a/b/e" },
        ],
    },
    expect => +{
        patched_document => +{
            a => +{
                b => +{
                    d => 42,
                    e => 42,
                },
            },
        },
    },
);

done_testing;
