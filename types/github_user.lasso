[
define github_user => type {
	trait { import github_common }	
	data
		protected prefix::string	= 'result_',
		protected u::string 		= string,
		protected p::string 		= 'x-oauth-basic',
		public user::string			= '',
		public objectdata:: map	= map,
		public headers

	// standard get method
	public get(method::string,user::string) => {
		protect => {
			handle_error => { return error_msg }
			local(urlstring = array)
			#method->size ? #urlstring->insert(#method)
			#user->size ? #urlstring->insert(#user)
			#user->size ? .user = #user
			
			// run query
			local(r = curl('https://api.github.com/'+#urlstring->join('/')))
			.u->size ? #r->set(CURLOPT_USERPWD, .u+':'+.p)
			.objectdata = json_deserialize(#r->result)
			.headers = #r->header->split('\r\n')
		}
	}
	
	public update(
		-name::string='',
		-email::string='',
		-blog::string='',
		-company::string='',
		-location::string='',
		-hireable::string='',
		-bio::string=''
		) => {
		/* ===========================================================
		Save optional params to a map to be serialized in the post data
		=========================================================== */
		local(outmap = map)
		#name->size ? #outmap->insert('name' = #name)
		#email->size ? #outmap->insert('email' = #email)
		#blog->size ? #outmap->insert('blog' = #blog)
		#company->size ? #outmap->insert('company' = #company)
		#location->size ? #outmap->insert('location' = #location)
		#hireable == 'true' ? #outmap->insert('hireable' = true)
		#hireable == 'false' ? #outmap->insert('hireable' = false)
		#bio->size ? #outmap->insert('bio' = #bio)
		
		/* ===========================================================
		Push the PATCH via JSON and get the new data
		can't use .run because of custom...
		=========================================================== */
		local(r = curl('https://api.github.com/user'))
		.u->size ? #r->set(CURLOPT_USERPWD, .u+':'+.p)
		#r->set(CURLOPT_CUSTOMREQUEST, 'PATCH')
		#r->set(CURLOPT_POSTFIELDS, json_serialize(#outmap))
		.objectdata = json_deserialize(#r->result)
		.headers = #r->header->split('\r\n')
	}
	
}
]