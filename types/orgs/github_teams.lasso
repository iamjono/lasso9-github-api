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
		returns array of items with url, name and id.
	======================================================= */
	public list_teams(-org::string) => {
		.request->urlPath = '/orgs/'+#org+'/teams'
		return .request
	}
	/* =======================================================
	Get team
		GET /teams/:id
		returns url, name, id, permission, memebrs_count, repos_count, organization (login, id, url, avatar_url).
	======================================================= */
	public get_team(-id::integer) => {
		.request->urlPath = '/orgs/'+#id
		return .request
	}
	/* =======================================================
	Create team
		In order to create a team, the authenticated user must be an owner of :org.
		POST /orgs/:org/teams
		params
			name	string	Required. The name of the team.
			repo_names	array of strings	The repositories to add the team to.
			permission	string	The permission to grant the team. Can be one of:
				* pull - team members can pull, but not push to or administer these repositories.
				* push - team members can pull and push, but not administer these repositories.
				* admin - team members can pull, push and administer these repositories.
				Default: pull
		returns url, name, id, permission, memebrs_count, repos_count, organization (login, id, url, avatar_url).
	======================================================= */
	public create_team(
		-org::string,
		-name::string,
		-repo_names::string = string,
		-repos::array = array,
		-permission::string = 'pull'
	) => {
		fail_if(#repo_names->size == 0 && #repos->size == 0,'Please supply repository names')
		array('pull','push','admin') !>> #permission ? #permission = 'pull'
		
		local(outmap = map)
		#outmap->insert('name' = #name)
		#repos->size ? 
			#outmap->insert('repo_names' = #repos) |
			#outmap->insert('repo_names' = #repo_names->split(','))
		#permission->size ? #outmap->insert('permission' = #permission)

		.request->postParams = json_serialize(#outmap)
		.request->method='POST'
		.request->urlPath = '/orgs/'+#org+'/teams'
		return .request
	}
	/* =======================================================
	Edit team
		In order to edit a team, the authenticated user must be an owner of the org that the team is associated with.
		PATCH /teams/:id
	======================================================= */
	public edit_team(
		-id::integer,
		-name::string,
		-permission::string = 'pull'
	) => {
		fail_if(#repo_names->size == 0 && #repos->size == 0,'Please supply repository names')
		array('pull','push','admin') !>> #permission ? #permission = 'pull'
		
		local(outmap = map)
		#outmap->insert('name' = #name)
		#permission->size ? #outmap->insert('permission' = #permission)

		.request->postParams = json_serialize(#outmap)
		.request->method='PATCH'
		.request->urlPath = '/teams/'+#id
		return .request
	}
	/* =======================================================
	DELETE team
		In order to delete a team, the authenticated user must be an owner of the org that the team is associated with.
		DELETE /teams/:id
	======================================================= */
	public delete_team(-id::integer) => {
		.request->method='DELETE'
		.request->urlPath = '/teams/'+#id
		return .request
	}
	/* =======================================================
	List team members
		In order to list members in a team, the authenticated user must be a member of the team.
		GET /teams/:id/members
	======================================================= */
	public list_team_members(-id::integer) => {
		.request->urlPath = '/teams/'+#id+'/members'
		return .request
	}
	/* =======================================================
	Get team member
		In order to get if a user is a member of a team, the authenticated user must be a member of the team.
		GET /teams/:id/members/:user
	======================================================= */
	public get_team_member(
		-id::integer,
		-user::string
		) => {
		.request->urlPath = '/teams/'+#id+'/members/'+#user
		return (:.request,
			{
				#1->statusCode == 204 ? return true
				return false
			}
		)
	}
	/* =======================================================
	Add team member
		In order to add a user to a team, the authenticated user must have ‘admin’ permissions to the team or be an owner of the org that the team is associated with.
		PUT /teams/:id/members/:user
	======================================================= */
	public add_team_member(
		-id::integer,
		-user::string
		) => {
		.request->method='PUT'
		.request->urlPath = '/teams/'+#id+'/members/'+#user
		return (:.request,
			{
				#1->statusCode == 204 ? return true
				return false
			}
		)
	}
	/* =======================================================
	Remove team member
		In order to remove a user from a team, the authenticated user must have ‘admin’ 
		permissions to the team or be an owner of the org that the team is associated with. 
		NOTE: This does not delete the user, it just remove them from the team.
		DELETE /teams/:id/members/:user
	======================================================= */
	public remove_team_member(
		-id::integer,
		-user::string
		) => {
		.request->method='DELETE'
		.request->urlPath = '/teams/'+#id+'/members/'+#user
		return .request
	}
	/* =======================================================
	List team repos
		GET /teams/:id/repos
	======================================================= */
	public list_team_repos(
		-id::integer
		) => {
		.request->urlPath = '/teams/'+#id+'/repos'
		return .request
	}
	/* =======================================================
	Get team repo
		GET /teams/:id/repos/:owner/:repo
		204 - Response if repo is managed by this team
		404 - Response if repo is not managed by this team
	======================================================= */
	public get_team_repo(
		-id::integer,
		-owner::string,
		-repo::string
		) => {
		.request->urlPath = '/teams/'+#id+'/repos/'+#owner+'/'+#repo
		return (:.request,
			{
				#1->statusCode == 204 ? return true
				return false
			}
		)
	}
	/* =======================================================
	Add team repo
		In order to add a repo to a team, the authenticated user must 
		be an owner of the org that the team is associated with. 
		Also, the repo must be owned by the organization, or a direct 
		fork of a repo owned by the organization.
		PUT /teams/:id/repos/:org/:repo
	======================================================= */
	public add_team_repo(
		-id::integer,
		-org::string,
		-repo::string
		) => {
		.request->method='PUT'
		.request->urlPath = '/teams/'+#id+'/repos/'+#org+'/'+#repo
		return (:.request,
			{
				#1->statusCode == 204 ? return true
				return false
			}
		)
	}
	/* =======================================================
	Remove team repo
		In order to remove a repo from a team, the authenticated user 
		must be an owner of the org that the team is associated with. 
		NOTE: This does not delete the repo, it just removes it from the team.
		DELETE /teams/:id/repos/:owner/:repo
	======================================================= */
	public remove_team_repo(
		-id::integer,
		-owner::string,
		-repo::string
		) => {
		.request->method='DELETE'
		.request->urlPath = '/teams/'+#id+'/repos/'+#owner+'/'+#repo
		return .request
	}
	/* =======================================================
	List user teams
		List all of the teams across all of the organizations to which the authenticated user belongs. 
		This method requires user or repo scope when authenticating via OAuth.
		GET /user/teams
	======================================================= */
	public list_user_teams() => {
		.request->urlPath = '/user/teams'
		return .request
	}


}
]