#!perl

use strict;
use warnings;
use utf8;
use Capture::Tiny qw/capture/;
use FindBin;
use File::Spec::Functions qw/catfile/;
use App::pmdeps;

use Test::More;
use Test::MockObject::Extends;

BEGIN {
    $ENV{ANSI_COLORS_DISABLED} = 1;
}

subtest 'remote' => sub {
    my $app = App::pmdeps->new;
    my $app_mock = Test::MockObject::Extends->new($app);
    $app_mock->mock(
        '_fetch_deps_from_metacpan',
        sub {
            my ($self) = @_;
            return [ {module => 'Module::Build'}, {module => 'base'} ];
        }
    );

    subtest 'use perl 5.008001' => sub {
        my ($got) = capture {
            $app->run('-p', '5.008001', 'Foo::Bar');
        };
        is $got, <<EOS;
Target: perl-5.008001
Depends on 1 core module:
\tbase
Depends on 1 non-core module:
\tModule::Build
EOS
        };

    subtest 'use perl 5.010001' => sub {
        my ($got) = capture {
            $app->run('--perl-version', '5.010001', 'Foo::Bar');
        };
        is $got, <<EOS;
Target: perl-5.010001
Depends on 2 core modules:
\tModule::Build
\tbase
Depends on no non-core module.
EOS
    };
};

subtest 'local' => sub {
    my $app = App::pmdeps->new;

    subtest 'use meta_json' => sub {
        my ($got) = capture {
            $app->run('-l', catfile($FindBin::Bin, 'resource'), '-p', '5.008001');
        };
        is $got, <<EOS;
Target: perl-5.008001
Depends on 2 core modules:
\tCarp
\tGetopt::Long
Depends on 3 non-core modules:
\tFurl
\tJSON
\tModule::CoreList
EOS
    };

    subtest 'use mymeta_json' => sub {
        my ($got) = capture {
            $app->run('-p', '5.008001', '--local', catfile($FindBin::Bin, 'resource', 'mymeta_only'));
        };
        is $got, <<EOS;
Target: perl-5.008001
Depends on 1 core module:
\tCarp
Depends on 2 non-core modules:
\tFurl
\tJSON
EOS
    };

    subtest 'not exists META.json or MYMETA.json' => sub {
        eval { $app->run( '-l', catfile($FindBin::Bin) ) };
        ok $@, 'dies ok';
    };
};
done_testing;
