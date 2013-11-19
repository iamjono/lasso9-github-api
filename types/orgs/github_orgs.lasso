[
/* =======================================================================
	Organizations API
		List User Organizations
		Get an Organization
		Edit an Organization
======================================================================= */
define github_orgs => type {
	data
		public request::http_request    = http_request,
		public objectdata::array		= array
		
	/* =======================================================
	List Organizations
		GET /repos/:owner/:repo/subscribers
	======================================================= */
	public list(-user::string) => {
		// assemble url
		local(urlstring = array)
		#user->size ? #urlstring->insert('users') | #urlstring->insert('user')
		#user->size ? #urlstring->insert(#user)			
		#urlstring->insert('orgs')
		
		// make and return request
		.request->urlPath = '/'+#urlstring->join('/')
		return .request
	}
	/* =======================================================
	Get an Organization
		GET /orgs/:org
	======================================================= */
	public get(-org::string) => {
		// make and return request
		.request->urlPath = '/orgs/'+#org
		return .request
	}
	/* =======================================================
	Edit an Organization
		PATCH /orgs/:org
	======================================================= */
	public edit(
		-name::string='',
		-email::string='',
		-company::string='',
		-location::string='',
		-billing_email::string=''
		) => {
		/* ===========================================================
		Save optional params to a map to be serialized in the post data
		=========================================================== */
		local(outmap = map)
		#name->size ? #outmap->insert('name' = #name)
		#email->size ? #outmap->insert('email' = #email)
		#company->size ? #outmap->insert('company' = #company)
		#location->size ? #outmap->insert('location' = #location)
		#billing_email->size ? #outmap->insert('billing_email' = #billing_email)
		
		/* ===========================================================
		Push the PATCH via JSON and get the new data
		can't use .run because of custom...
		=========================================================== */
		// make and return request
		.request->postParams = json_serialize(#outmap)
		.request->method='PATCH'
		.request->urlPath = '/orgs/'+#org
		return .request
	}
}
]