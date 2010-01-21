#
# Accept-Language VCL binary tests
# Test helper functions
#
# $Id: test.pm 16778 2010-01-21 16:33:09Z cosimo $

package test;

use strict;
use Test::More;

sub update_binary {
    my $status = system('make');
    $status >>= 8;
    return ok(0 == $status, 'C binary updated correctly');
}

sub run_binary {
    my @args = @_;
    my $exec = './accept-language';
    my $cmd = $exec;
    $cmd .= ' ';
    $cmd .= join(' ', map { q(') . $_ . q(') } @args);
    my $output = `$cmd`;
    return $output; 
}

sub is_language {
    my ($header_value, $expected_language, $message) = @_;
    my $selected_language = run_binary($header_value);
    chomp $selected_language;

    $message ||= qq(parsing header '$header_value' should hold language '$expected_language');

    return is($selected_language, $expected_language, $message);
}

*is_lang = *is_language;

1;

=pod

=head1 NAME

Accept-Language test functions

=head1 DESCRIPTION

Helper test functions for the Accept-Language varnish C code extension.

=head1 FUNCTIONS

=head2 C<update_binary()>

Runs the C<make> stage and updates the C<accept-language> binary for testing.

=head2 C<run_binary($accept_lang_header)>

Runs the C<accept-language> binary with the contents of the accept language
header passed as argument. Returns the output of the binary, which should
be a supported language code.

=head2 C<is_language($accept_lang_header, $lang)>

=head2 C<is_language($accept_lang_header, $lang, $message)>

Test assertion.

Parses the C<$accept_lang_header> as coming in from a client, and asserts that
the resulting language as output by the C<accept-language> binary is equal
to C<$lang>.

Optionally with a test message (C<$message>).

=head1 AUTHOR

Cosimo Streppone, E<lt>cosimo@opera.comE<gt>

=head1 LICENSE AND COPYRIGHT

Copyright (c), 2010 Opera Software ASA.
All rights reserved.

=end

