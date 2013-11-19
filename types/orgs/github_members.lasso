[
/* =======================================================================
	Organization Members API
		Members list
		Check membership
		Add a member // see teams
		Remove a member
		Public members list
		Check public membership
		Publicize a user’s membership
		Conceal a user’s membership
======================================================================= */
define github_members => type {
	data
		public request::http_request    = http_request,
		public objectdata::array		= array
	/* =======================================================
	Members list
		List all users who are members of an organization. 
		A member is a user that belongs to at least 1 team in the organization. 
		If the authenticated user is also an owner of this organization then 
		both concealed and public members will be returned. If the requester 
		is not an owner of the organization the query will be redirected 
		to the public members list.
		
		GET /orgs/:org/members
	======================================================= */
	public list(-org::string) => {
		// assemble url
		// make and return request
		.request->urlPath = '/orgs/'+#org+'/members'
		return .request
	}

	/* =======================================================
	Check membership
		Check if a user is, publicly or privately, a member of the organization
		GET /orgs/:org/members/:user
		
		status codes determine response:
		204 = Response if requester is an organization member and user is a member
		404 = Response if requester is an organization member and user is not a member
		404 = Response if requester is not an organization member and is inquiring about themselves
		302 = Response if requester is not an organization member
	======================================================= */
	public check(
		-org::string,
		-user::string
		) => {
		.request->urlPath = '/orgs/'+#org+'/members/'+#user
		return .request // need to return 
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
		return .request // need to return 
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
		return .request // need to return 
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
		return .request // need to return 
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
		return .request // need to return 
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
		return .request // need to return 
	}
}
]