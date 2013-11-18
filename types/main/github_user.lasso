[
define github_user => type {
	data
		protected prefix::string		= 'user_',
		public request::http_request    = http_request,
		public objectdata::map			= map

	// standard get method
	public get(method::string,user::string) => {
	
		// assemble url
		local(urlstring = array)
		#method->size ? #urlstring->insert(#method)
		#user->size ? #urlstring->insert(#user)
		
		// make and return request
		.request->urlPath = '/'+#urlstring->join('/')
		return .request
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
		// make and return request
		.request->postParams = json_serialize(#outmap)
		.request->method='PATCH'
		.request->urlPath = '/user'
		return .request
	}
	
}
]