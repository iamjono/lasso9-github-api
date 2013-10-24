[
/* =======================================================================
	Gitignore Templates API

		Listing available templates
		Get a single template

	When you create a new GitHub repository via the API, you can specify 
	a .gitignore template to apply to the repository upon creation. 
	The .gitignore Templates API lists and fetches templates from the 
	GitHub .gitignore repository.
======================================================================= */
define github_gitignore => type {
	trait { import github_common }	
	data
		protected prefix::string	= 'result_',
		protected u::string 		= string,
		protected p::string 		= 'x-oauth-basic',
		public user::string			= '',
		public objectdata::map		= map,
		public headers,
		public url::string			= string

	/* ================================================================
	Listing available templates
		List all templates available to pass as an option when creating a repository.
		GET /gitignore/templates
	================================================================ */
	public list() => {
		protect => {
			handle_error => { return error_msg }
			
			// run query
			local(r = curl('https://api.github.com/gitignore/templates'))
			.u->size ? #r->set(CURLOPT_USERPWD, .u+':'+.p)
			.objectdata->insert('templates' = json_deserialize(#r->result))
			.headers = #r->header->split('\r\n')
		}
	}
	/* ================================================================
	Get a single template
		The API also allows fetching the source of a single template.
		GET /gitignore/templates/C
	================================================================ */
	public get(template::string) => {
		protect => {
			handle_error => { return error_msg }
			// run query
			local(r = curl('https://api.github.com/gitignore/templates/'+#template))
			.u->size ? #r->set(CURLOPT_USERPWD, .u+':'+.p)
			.objectdata = json_deserialize(#r->result)
			.headers = #r->header->split('\r\n')
		}
	}
}
]