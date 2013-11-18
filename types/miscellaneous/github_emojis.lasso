[
/* =======================================================================
	GitHub Emojis API
		Lists all the emojis available to use on GitHub.
		GET /emojis
======================================================================= */
define github_emojis => type {
	data
		public request::http_request    = http_request,
		public objectdata::map			= map
		
	// standard get method
	public get() => {
		.request->urlPath = '/emojis'
		return .request
	}
}
]