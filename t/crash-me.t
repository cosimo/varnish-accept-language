#!/usr/bin/env perl

#
# Accept-Language really long strings
#

use strict;
require test;

#
# These are all test cases from the actual web access logs
#

my @tests = (

    # Try to overflow the max static buffer allocated by accept-language.c
    [ 'fr,en;q=0.9,ja;q=0.8,de;q=0.7,es;q=0.6,it;q=0.5,pt;q=0.4,pt-PT;q=0.3,nl;q=0.2,sv;q=0.1,nb;q=0.1,da;q=0.1,fi;q=0.1,ru;q=0.1,pl;q=0.1,zh-CN;q=0.1,zh-TW;q=0.1,ko;q=0.1' => 'en' ],

    [ 'fr,en;q=0.9,ja;q=0.8,de;q=0.7,es;q=0.6,it;q=0.5,pt;q=0.4,pt-PT;q=0.3,nl;q=0.2,sv;q=0.1,nb;q=0.1,da;q=0.1,fi;q=0.1,ru;q=0.1,pl;q=0.1,zh-CN;q=0.1,zh-TW;q=0.1,ko;q=0.1,fr,en;q=0.9,ja;q=0.8,de;q=0.7,es;q=0.6,it;q=0.5,pt;q=0.4,pt-PT;q=0.3,nl;q=0.2,sv;q=0.1,nb;q=0.1,da;q=0.1,fi;q=0.1,ru;q=0.1,pl;q=0.1,zh-CN;q=0.1,zh-TW;q=0.1,ko;q=0.1' => 'en' ],

    # Malformed string 
    [ 'en-us,en;q=0.5,x-ns1w9Ea$X$dNhK,x-ns2Ef70Nnym7b6' => 'en' ],

    # Strange case of the crashing avatars
    [ 'en-US,en;q=0.9' => 'en' ],

);

Test::More::plan(tests => @tests + 1);
test::update_binary();

for (@tests) {
    my ($header, $lang) = @{ $_ };
    test::is_lang($header, $lang);
}

