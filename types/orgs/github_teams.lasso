[
/* =======================================================================
	Organization Teams API

		List teams
		Get team
		Create team
		Edit team
		Delete team
		List team members
		Get team member
		Add team member
		Remove team member
		List team repos
		Get team repo
		Add team repo
		Remove team repo
		List user teams
	All actions against teams require at a minimum an authenticated user who is a member 
	of the Owners team in the :org being managed. Additionally, OAuth users require “user” scope.

======================================================================= */
define github_teams => type {
	data
		public request::http_request    = http_request,
		public objectdata::array		= array

	/* =======================================================
	List teams
		GET /orgs/:org/teams
	======================================================= */
	public list_teams(-org::string) => {
		// assemble url
		// make and return request
		.request->urlPath = '/orgs/'+#org+'/teams'
		return .request
	}



}
]