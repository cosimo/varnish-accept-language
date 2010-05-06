#!/usr/bin/env perl

#
# Accept-Language composite language tests
#

use strict;
require test;

my @tests = (
    [ 'en-US,en-GB;q=0.9,de-AT;q=0.8,de;q=0.7' => 'en', 'Composite language en-US should be treated as "en"' ],
    [ 'de-at' => 'de', 'Composite language de-at that is not supported should fallback to "de"' ],
    [ 'de-AT' => 'de', 'Composite language de-AT that is not supported should fallback to "de"' ],
    [ 'zh-cn' => 'zh-cn', 'Composite language that is supported should be detected correctly' ],
    [ 'zh-CN' => 'zh-cn', 'Composite language that is supported should be detected correctly' ],
);

Test::More::plan(tests => @tests + 1);
test::update_binary();

for (@tests) {
    my ($header, $lang, $message) = @{ $_ };
    test::is_lang($header, $lang, $message);
}

