#!perl

use strict;
use warnings;
use utf8;
use Capture::Tiny qw/capture/;
use App::pmdeps;

use Test::More;
use Test::MockObject::Extends;

subtest 'some deps' => sub {
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
done_testing;
