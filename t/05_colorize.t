#!perl

use strict;
use warnings;
use utf8;
use Capture::Tiny qw/capture/;
use FindBin;
use File::Spec::Functions qw/catfile/;
use App::pmdeps;

use Test::More;

plan skip_all => "Test::Vars required for testing variables" if $^O eq 'MSWin32';

subtest 'colorize ok' => sub {
    my $app = App::pmdeps->new;

    my ($got) = capture {
        $app->run('-p', '5.008001', '-l', catfile($FindBin::Bin, 'resource'));
    };
    is $got, <<EOS;
Target: perl-5.008001
\033[32mDepends on 2 core modules:
\033[0m\tCarp
\tGetopt::Long
\033[33mDepends on 3 non-core modules:
\033[0m\tFurl
\tJSON
\tModule::CoreList
EOS
};

done_testing;
