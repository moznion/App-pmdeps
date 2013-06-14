requires 'perl',             '5.008001';
requires 'JSON',             '2.59';
requires 'Furl',             '2.16';
requires 'Module::CoreList', 0;
requires 'Carp',             0;
requires 'Getopt::Long',     0;

on 'test' => sub {
    requires 'Test::More',                '0.98';
    requires 'Test::MockObject::Extends', '1.20120301';
    requires 'Capture::Tiny',             '0.22';
};
