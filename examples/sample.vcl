# Sample VCL file

# For the accept-language.vcl "plugin" to work, we
# need these includes here. I couldn't manage to get them
# working in accept-language.vcl

C{
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
}C

# Everything proceeds as normal
sub vcl_recv {

	# ...

    include "/etc/varnish/accept-language.vcl";

	# ...
	# lookup;

    pass;
}

sub vcl_fetch {

	# ...

	# Store different versions of the resource by the
	# content of the Accept-Language header
	set obj.http.Vary = "Accept-Language";

	# ...
	# deliver;

    pass;
}

