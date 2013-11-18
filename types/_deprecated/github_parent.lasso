[
/* =======================================================================
	GitHub Client API parent type
	
	Note:
		public objectdata::array	= array,
	... is deliberately left out as it may be a map or an array depending on situation
======================================================================= */
define github_parent => type {
	trait { import github_common }	
	data
		protected prefix::string	= 'result_',
		protected u::string 		= string,
		protected p::string 		= 'x-oauth-basic',
		public user::string			= '',
		public headers				= github_header,
		public url::string			= string

	protected simple_get() => {
		protect => {
			handle_error => { return error_msg+'<pre>'+error_stack+'</pre>' }
//			log_critical(.u + ' | ' + .p)
			// run query
			local(resp = http_request(
				.url,
				-username=.u,
				-password=.p,
				-basicAuthOnly=true
				)->response
			)
			local(res = json_deserialize(#resp->body->asString))
			#res->isA(::map) ? .objectdata = array(#res) 
			#res->isA(::array) ? .objectdata = #res
			.headers = #resp->headers
		}
	}

}

]