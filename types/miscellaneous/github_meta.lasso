[
/* =======================================================================
	GitHub Meta API
		This gives some information about GitHub.com, the service.
		GET /meta
		{
		  "hooks": [
		    "127.0.0.1/32"
		  ],
		  "git": [
		    "127.0.0.1/32"
		  ]
		}
		
		hooks
			An Array of IP addresses in CIDR format specifying the addresses 
			that incoming service hooks will originate from. 
			Subscribe to the API Changes blog or follow @GitHubAPI 
			on Twitter to get updated when this list changes.
		git
			An Array of IP addresses in CIDR format specifying the 
			Git servers at GitHub.
======================================================================= */
define github_meta => type {
	data
		public request::http_request    = http_request,
		public objectdata::map			= map
	
	public get() => {
		.request->urlPath = '/meta'
		return .request

	}
}
]