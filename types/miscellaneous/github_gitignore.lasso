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
	data
		public request::http_request    = http_request,
		public objectdata::map			= map

	/* ================================================================
	Listing available templates
		List all templates available to pass as an option when creating a repository.
		GET /gitignore/templates
	================================================================ */
	public list() => {
		.request->urlPath = '/gitignore/templates'
		return .request
	}
	/* ================================================================
	Get a single template
		The API also allows fetching the source of a single template.
		GET /gitignore/templates/C
	================================================================ */
	public get(template::string) => {
		.request->urlPath = '/gitignore/templates/'+#template
		return .request
	}
}
]