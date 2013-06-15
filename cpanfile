requires 'perl',             '5.008001';
requires 'JSON',             '2.59';
requires 'Furl',             '2.16';
requires 'Getopt::Long',     '2.39';
requires 'Module::CoreList', '2.91';
requires 'Carp',             0;

on 'test' => sub {
    requires 'Test::More',                '0.98';
    requires 'Test::MockObject::Extends', '1.20120301';
    requires 'Capture::Tiny',             '0.22';
};
