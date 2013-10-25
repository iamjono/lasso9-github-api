[
/* =======================================================================
	GitHub Emojis API
		Lists all the emojis available to use on GitHub.
		GET /emojis
======================================================================= */
define github_emojis => type {
	trait { import github_common }	
	data
		protected prefix::string	= 'result_',
		protected u::string 		= string,
		protected p::string 		= 'x-oauth-basic',
		public user::string			= '',
		public objectdata::map	= map,
		public headers				= github_header,
		public url::string			= string
		
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