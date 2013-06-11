requires 'perl',             '5.008001';
requires 'JSON',             '2.59';
requires 'Module::CoreList', 0;

on 'test' => sub {
    requires 'Test::More', '0.98';
};
