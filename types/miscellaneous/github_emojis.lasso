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
			local(r = curl('https://api.github.com/emojis'))
			.u->size ? #r->set(CURLOPT_USERPWD, .u+':'+.p)
			.objectdata = json_deserialize(#r->result)
			.headers->process(#r->header)
		}
	}
}
]