[
/* =======================================================================
	GitHub Emojis API
		Lists all the emojis available to use on GitHub.
		GET /emojis
======================================================================= */
define github_emojis => type {
	parent github_parent
	data
		public objectdata::map		= map
		
	// standard get method
	public get() => {
		protect => {
			handle_error => { return error_msg }
			
			// run query
			local(resp = http_request(
				'https://api.github.com/emojis',
				-username=.u,
				-password=.p,
				-basicAuthOnly=true
				)->response
			)
			.objectdata = json_deserialize(#resp->body->asString)
			.headers = #resp->headers

		}
	}
}
]