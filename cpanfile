requires 'Class::Accessor::Lite';
requires 'JSON::Pointer';
requires 'Module::Load';
requires 'Module::Loaded';
requires 'parent';
requires 'perl', '5.008_001';

on configure => sub {
    requires 'Module::Build::Tiny', '0.035';
};

on test => sub {
    requires 'Test::More';
};
