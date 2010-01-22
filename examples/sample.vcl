# Sample VCL file
# ...

include "/etc/varnish/accept-language.vcl";

# Everything proceeds as normal
sub vcl_recv {

	# ...
C{
    vcl_rewrite_accept_language(sp);
}C

	# ...
	# lookup;

    pass;
}

sub vcl_fetch {

	# ...

	# Store different versions of the resource by the
	# content of the new X-Varnish-Accept-Language header
	set obj.http.Vary = "X-Varnish-Accept-Language";

	# ...
	# deliver;

    pass;
}

