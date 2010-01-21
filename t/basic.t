#!/usr/bin/env perl

# 
# Basic Accept-Language tests
#

use strict;
require test;

my @langs = qw(bg cs da en fi fy hu it ja no pl ru tr vn);

Test::More::plan(tests => 3 + (@langs * 3));

test::update_binary();
test::is_lang('en', 'en');
test::is_lang('', 'en');

# Basically test for supported languages
for (@langs) {
    my $lang = $_;
    test::is_lang($lang, $lang);
    test::is_lang("$lang,xy-zx;q=0.01", $_);
    test::is_lang("$lang,en;q=0.99", $_);
}

