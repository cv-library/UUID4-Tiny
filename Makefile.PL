use ExtUtils::MakeMaker;

os_unsupported unless $^O eq 'linux';

WriteMakefile(
    NAME => 'UUID4::Tiny',
    VERSION_FROM => 'lib/UUID4/Tiny.pm',
    TEST_REQUIRES => {
        'Test2::Tools::Tiny' => 0,
    },
);
