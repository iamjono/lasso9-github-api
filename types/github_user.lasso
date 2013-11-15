[
define github_user => type {
	parent github_parent
	data
		public objectdata::map		= map

	// standard get method
	public get(method::string,user::string) => {
		protect => {
			handle_error => { return error_msg }
			local(urlstring = array)
			#method->size ? #urlstring->insert(#method)
			#user->size ? #urlstring->insert(#user)
			#user->size ? .user = #user
			
			// run query
			local(resp = http_request(
				'https://api.github.com/'+#urlstring->join('/'),
				-username=.u,
				-password=.p,
				-basicAuthOnly=true
				)->response
			)
			.objectdata = json_deserialize(#resp->body->asString)
			.headers = #resp->headers

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
		
		// run query
		local(resp = http_request(
			'https://api.github.com/user',
			-username=.u,
			-password=.p,
			-basicAuthOnly=true,
			-postParams=json_serialize(#outmap),
			-reqMethod='PATCH'
			)->response
		)
		.objectdata = json_deserialize(#resp->body->asString)
		.headers = #resp->headers

		
	}
	
}
]