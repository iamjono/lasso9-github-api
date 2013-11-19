[
/* =======================================================================
	This is a read-only API to the GitHub events. 
	
	NOTE: need to implement pollinterval and etag, and pagination
	
	These events power the various activity streams on the site.
		List public events
		List repository events
		List issue events for a repository
		List public events for a network of repositories
		List public events for an organization
		List events that a user has received
		List public events that a user has received
		List events performed by a user
		List public events performed by a user
		List events for an organization
		
		Events are optimized for polling with the “ETag” header. 
		If no new events have been triggered, you will see a “304 Not Modified” response, 
		and your current rate limit will be untouched. There is also an “X-Poll-Interval” header 
		that specifies how often (in seconds) you are allowed to poll. In times of high server 
		load, the time may increase. Please obey the header.
======================================================================= */
define github_events => type {
	data
		public request::http_request    = http_request,
		public objectdata::array		= array

	/* =======================================================
	List public events
		GET /events
	======================================================= */
	public list() => {
		.request->urlPath = '/events'
		return .request
	}
	/* =======================================================
	List repository events
		GET /repos/:owner/:repo/events
	======================================================= */
	public list_repo_events(
		-owner::string,
		-repo::string
		) => {
		.request->urlPath = '/repos/'+#owner+'/'+#repo+'/events'
		return .request
	}
	/* =======================================================
	List issue events for a repository
		Repository issue events have a different format than other events, as documented in the Issue Events API.
		GET /repos/:owner/:repo/issues/events
	======================================================= */
	public list_issue_events(
		-owner::string,
		-repo::string
		) => {
		.request->urlPath = '/repos/'+#owner+'/'+#repo+'/issues/events'
		return .request
	}
	/* =======================================================
	List public events for a network of repositories
		GET /networks/:owner/:repo/events
	======================================================= */
	public public_events(
		-owner::string,
		-repo::string
		) => {
		.request->urlPath = '/networks/'+#owner+'/'+#repo+'/events'
		return .request
	}
	/* =======================================================
	List public events for an organization
		GET /orgs/:org/events
	======================================================= */
	public org_public_events(
		-org::string
		) => {
		.request->urlPath = '/orgs/'+#org+'/events'
		return .request
	}
	/* =======================================================
	List events that a user has received
		These are events that you’ve received by watching repos and following users. 
		If you are authenticated as the given user, you will see private events. 
		Otherwise, you’ll only see public events.
		GET /users/:user/received_events
	======================================================= */
	public user_events(-user::string) => {
		.request->urlPath = '/users/'+#user+'/received_events'
		return .request
	}
	/* =======================================================
	List public events that a user has received
		GET /users/:user/received_events/public
	======================================================= */
	public user_public_events(-user::string) => {
		.request->urlPath = '/users/'+#user+'/received_events/public'
		return .request
	}
	/* =======================================================
	List events performed by a user
		If you are authenticated as the given user, you will see your private events. 
		Otherwise, you’ll only see public events.
		GET /users/:user/events
	======================================================= */
	public user_events_performed(-user::string) => {
		.request->urlPath = '/users/'+#user+'/events'
		return .request
	}
	/* =======================================================
	List public events performed by a user
		GET /users/:user/events/public
	======================================================= */
	public user_public_events_performed(-user::string) => {
		.request->urlPath = '/users/'+#user+'/events/public'
		return .request
	}
	/* =======================================================
	List events for an organization
		This is the user’s organization dashboard. You must be authenticated as the user to view this.
		GET /users/:user/events/orgs/:org
	======================================================= */
	public user_org_events(-user::string,-org::string) => {
		.request->urlPath = '/users/'+#user+'/events/orgs/'+#org
		return .request
	}
}
]