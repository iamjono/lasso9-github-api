[
/* =======================================================================
	Repository Contents API
		Get the README
		Get contents
		Create a file
		Update a file
		Delete a file
		Get archive link
		Custom media types
		
		These API methods let you retrieve the contents of files within a repository as 
		Base64 encoded content. See media types for requesting raw format.
======================================================================= */
define github_contents => type {
	data
		public request::http_request    = http_request,
		public objectdata::array		= array
	/* =======================================================
	Get the README
		This method returns the preferred README for a repository.
		GET /repos/:owner/:repo/readme
		READMEs support a custom media type for getting the raw content.
		
		Parameters
			Name	Type	Description
			ref		string	The name of the commit/branch/tag. Default: the repository’s default branch (usually master)
		
		Response	
		{
		  "type": "file",
		  "encoding": "base64",
		  "size": 5362,
		  "name": "README.md",
		  "path": "README.md",
		  "content": "encoded content ...",
		  "sha": "3d21ec53a331a6f037a91c368710b99387d012c1",
		  "url": "https://api.github.com/repos/pengwynn/octokit/contents/README.md",
		  "git_url": "https://api.github.com/repos/pengwynn/octokit/git/blobs/3d21ec53a331a6f037a91c368710b99387d012c1",
		  "html_url": "https://github.com/pengwynn/octokit/blob/master/README.md",
		  "_links": {
		    "git": "https://api.github.com/repos/pengwynn/octokit/git/blobs/3d21ec53a331a6f037a91c368710b99387d012c1",
		    "self": "https://api.github.com/repos/pengwynn/octokit/contents/README.md",
		    "html": "https://github.com/pengwynn/octokit/blob/master/README.md"
		  }
		}
	======================================================= */
	public readme(-owner::string,-repo::string) => {
		.request->urlPath = '/repos/'+#owner+'/'+#repo+'/readme'
		return .request
	}

	/* =======================================================
	Get contents
		This method returns the contents of a file or directory in a repository.
		
		GET /repos/:owner/:repo/contents/:path
		Files and symlinks support a custom media type for getting the raw content. Directories and submodules do not support custom media types.
		
		Notes:
		
		To get a repository’s contents recursively, you can recursively get the tree.
		This API supports files up to 1 megabyte in size.
		Parameters
		
		Name	Type	Description
		path	string	The content path.
		ref		string	The name of the commit/branch/tag. Default: the repository’s default branch (usually master)
	======================================================= */
	public get(
		-owner::string,
		-repo::string,
		-path::string
		) => {
		.request->urlPath = '/repos/'+#owner+'/'+#repo+'/readme/'+#path
		return (:.request,
			{
				#1->statusCode == 204 ? return true
				return false
			}
		)
	}
	/* =======================================================
	Remove a member
		Removing a user from this list will remove them from all teams 
		and they will no longer have any access to the organization’s repositories
		DELETE /orgs/:org/members/:user
	======================================================= */
	public delete(
		-org::string,
		-user::string
		) => {
		.request->urlPath = '/orgs/'+#org+'/members/'+#user
		.request->method='DELETE'
		return (:.request,
			{
				return true
			}
		)
	}
	/* =======================================================
	Public members list
		Members of an organization can choose to have their membership publicized or not
		GET /orgs/:org/public_members
	======================================================= */
	public list_publicmembers(
		-org::string
		) => {
		.request->urlPath = '/orgs/'+#org+'/public_members'
		return .request
	}
	/* =======================================================
	Check public membership
		GET /orgs/:org/public_members/:user
		
		status codes determine response:
		204 = Response if user is a public member
		404 = Response if user is not a public member
	======================================================= */
	public check_public(
		-org::string,
		-user::string
		) => {
		.request->urlPath = '/orgs/'+#org+'/public_members/'+#user
		return (:.request,
			{
				#1->statusCode == 204 ? return true
				return false
			}
		)
	}
	/* =======================================================
	Publicize a user’s membership
		The user can publicize their own membership. (A user cannot publicize the membership for another user.)
		PUT /orgs/:org/public_members/:user
	======================================================= */
	public publicize(
		-org::string,
		-user::string
		) => {
		.request->urlPath = '/orgs/'+#org+'/public_members/'+#user
		.request->method='PUT'
		return .request
	}
	/* =======================================================
	Conceal a user’s membership
		DELETE /orgs/:org/public_members/:user
	======================================================= */
	public conceal(
		-org::string,
		-user::string
		) => {
		.request->urlPath = '/orgs/'+#org+'/public_members/'+#user
		.request->method='DELETE'
		return .request
	}
}
]