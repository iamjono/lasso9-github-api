[
/* =======================================================================
	Gists API
	
		Authentication
			You can read public gists and create them for anonymous users 
			without a token; however, to read or write gists on a user’s 
			behalf the gist OAuth scope is required.
		List gists
		Get a single gist
		Create a gist
		Edit a gist
		Star a gist
		Unstar a gist
		Check if a gist is starred
		Fork a gist
		Delete a gist
======================================================================= */
define github_gists => type {
	parent github_parent
	data
		public objectdata::array		= array

	/* =================================================================================================
	List gists
		List a user’s gists:
			GET /users/:user/gists
			.list(-user='iamjono')
			
		List the authenticated user’s gists or if called anonymously, this will return all public gists:
			GET /gists
			.list()
			or for an authenticated users gists
			.token('mytoken')
			.list()

		List all public gists:
			GET /gists/public
			.list(-public)
		
		List the authenticated user’s starred gists:
			GET /gists/starred
			.list(-starred)
		
	Params:
		since
			Optional string of a timestamp in ISO 8601 format: YYYY-MM-DDTHH:MM:SSZ Only gists updated at 
			or after this time are returned.
	================================================================================================= */
	public list(
		-user::string		= '',
		-since::string		= ''
		) => {
		protect => {
			handle_error => { return error_msg+'<pre>'+error_stack+'</pre>' }
			local(urlstring = array, params = array)
			if(#user->size) => {
				//repos for the specified user
				#urlstring->insert('users')
				#urlstring->insert(#user)
				#urlstring->insert('gists')
				
//			else(#org->size)
//				// repos for the org
//				#urlstring->insert('orgs')
//				#urlstring->insert(#org)
//				#type->size && array('all', 'owner', 'member') >> #type ? #params->insert('type='+#type) 
//				#sort->size && array('created', 'updated', 'pushed', 'full_name') >> #sort ? #params->insert('sort='+#sort) 
//				#direction == 'desc' ? #params->insert('direction=desc') | #params->insert('direction=asc') 
			else
				// repos for the authenticated user or public if anon
				#urlstring->insert('gists')
			}
			// since here 
			//#since->size ? #params->insert('since='+#since+'Z') 
			
			// run query
			local(url = 'https://api.github.com/'+#urlstring->join('/')+(#params->size ? '?'+#params->join('&')))
			.url = #url
			local(r = curl(#url))
			.u->size ? #r->set(CURLOPT_USERPWD, .u+':'+.p)
			local(res = json_deserialize(#r->result))
			#res->isA(::map) ? .objectdata = array(#res) 
			#res->isA(::array) ? .objectdata = #res
			.headers->process(#r->header)
//			return #r->header->split('\r\n')
		}
	}

	
}
]