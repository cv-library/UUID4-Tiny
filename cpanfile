on configure => sub {
    requires 'ExtUtils::MakeMaker', '7.26'; # For os_unsupported
};

on test => sub {
    requires 'Test2::Tools::Tiny';
};
