[
/* =======================================================================
	Repository Starring API
	
	Repository Starring is a feature that lets users bookmark repositories. 
	Stars are shown next to repositories to show an approximate level of interest. 
	Stars have no effect on notifications or the activity feed. 
	For that, see Repository Watching.

	We recently changed the way watching works on GitHub. 
	Many 3rd party applications may be using the “watcher” endpoints 
	for accessing these. Starting today, you can start changing these 
	to the new “star” endpoints. See below. 
	Check the Watcher API Change post for more.
	
		List Stargazers
		List repositories being starred
		Check if you are starring a repository
		Star a repository
		Unstar a repository
======================================================================= */
define github_starring => type {
	data
		public request::http_request    = http_request,
		public objectdata::array		= array


		
	/* =======================================================
	List Stargazers
		GET /repos/:owner/:repo/stargazers
			# Legacy, using github.beta media type.
			GET /repos/:owner/:repo/watchers
	======================================================= */
	public stargazers(
		-owner::string,
		-repo::string
		) => {
		local(urlstring = array, params = array)
		#urlstring->insert('repos')
		#urlstring->insert(#owner)			
		#urlstring->insert(#repo)			
		#urlstring->insert('stargazers')

		.request->urlPath = '/'+#urlstring->join('/')
		return .request
	}
	/* =======================================================
	List repositories being starred
		List repositories being starred by a user.
		GET /users/:user/starred
			# Legacy, using github.beta media type.
			GET /users/:user/watched
	======================================================= */
	public starred(
		-user::string		= '',
		-sort::string		= '',
		-direction::string	= ''
		) => {
		local(urlstring = array, params = array)
		#user->size ? #urlstring->insert('users') | #urlstring->insert('user')
		#user->size ? #urlstring->insert(#user)			
		#urlstring->insert('starred')

		array('created', 'updated') >> #sort ? #params->insert('sort='+#sort) 
		#direction == 'desc' ? #params->insert('direction=desc') | #params->insert('direction=asc') 

		.request->urlPath = '/'+#urlstring->join('/')+(#params->size ? '?'+#params->join('&'))
		return .request
	}
	private getstar(url::string,method::string='') => {
		.request->urlPath = #url
		#method->size ? .request->method=#method
		return .request
	}
	/* =======================================================
	Check if you are starring a repository
		Requires for the user to be authenticated.
	======================================================= */
	public check(
		-owner::string,
		-repo::string
		) => {
		.request->urlPath = '/user/starred/'+#owner+'/'+#repo
		return (:.request,
			{
				#1->statusCode == 204 || #1->statusCode == 204 ? return true
				return false
			}
		)
	}
	
	/* =======================================================
	Star a repository
		Requires for the user to be authenticated.
	======================================================= */
	public star(
		-owner::string,
		-repo::string
		) => {
		.request->urlPath = '/user/starred/'+#owner+'/'+#repo
		.request->method='PUT'
		return (:.request,
			{
				return true
			}
		)
	}
	/* =======================================================
	UNStar a repository
		Requires for the user to be authenticated.
	======================================================= */
	public unstar(
		-owner::string		= '',
		-repo::string		= ''
		) => {		
		.request->urlPath = '/user/starred/'+#owner+'/'+#repo
		.request->method='DELETE'
		return (:.request,
			{
				return false
			}
		)
	}
}
]