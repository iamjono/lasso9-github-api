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
	data
		public request::http_request    = http_request

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
	public list(user::string, -since=void) => {
		.request->urlPath = `/users/` + #user + `/gists`

		#since->isA(::date)
			? .request->getParams = (:#since->format(`yyyy-MM-ddHH:mm:ssZ`))
		return .request
	}
	public list(
		-public ::boolean=false,
		-starred::boolean=false,
		-since=void
	) => {
		#public
			? .request->urlPath = `/gists/public`
		| #starred
			? .request->urlPath = `/gists/starred`
		| .request->urlPath = `/gists`

		#since->isA(::date)
			? .request->getParams = (:#since->format(`yyyy-MM-ddHH:mm:ssZ`))

		return .request
	}

}
]