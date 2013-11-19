[
/* =======================================================================
	Repository Watching API
	
	Watching a Repository registers the user to receive notifications on 
	new discussions, as well as events in the user’s activity feed. 
	See Repository Starring for simple repository bookmarks.

	We recently changed the way watching works on GitHub. 
	Until 3rd party applications stop using the “watcher” endpoints for 
	the current Starring API, the Watching API will use the 
	below “subscription” endpoints. 
	Check the Watcher API Change post for more.
	
		List watchers
		List repositories being watched
		Get a Repository Subscription
		Set a Repository Subscription
		Delete a Repository Subscription
======================================================================= */
define github_watching => type {
	data
		public request::http_request    = http_request,
		public objectdata::array		= array


		
	/* =======================================================
	List watchers
	GET /repos/:owner/:repo/subscribers
	======================================================= */
	public list_watchers(
		-owner::string,
		-repo::string
		) => {
		local(urlstring = array, params = array)
		#urlstring->insert('repos')
		#urlstring->insert(#owner)			
		#urlstring->insert(#repo)			
		#urlstring->insert('subscribers')

		.request->urlPath = '/'+#urlstring->join('/')
		return .request
	}
	/* =======================================================
	List repositories being watched
		List repositories being watched by a user.
			GET /users/:user/subscriptions
		List repositories being watched by the authenticated user.
			GET /user/subscriptions
	======================================================= */
	public list_watching(
		-user::string		= ''
		) => {
		local(urlstring = array, params = array)
		#user->size ? #urlstring->insert('users') | #urlstring->insert('user')
		#user->size ? #urlstring->insert(#user)			
		#urlstring->insert('subscriptions')

		.request->urlPath = '/'+#urlstring->join('/')
		return .request
	}
	/* =======================================================
	Get a Repository Subscription
		GET /repos/:owner/:repo/subscription
	======================================================= */
	public get_subscription(
		-owner::string,
		-repo::string
		) => {
		.request->urlPath = '/repos/'+#owner+'/'+#repo+'/subscription'
		return .request
	}
	/* =======================================================
	Set a Repository Subscription
		PUT /repos/:owner/:repo/subscription
		
		Parameters
		subscribed - boolean - Determines if notifications should be received from this repository.
		ignored - boolean - Determines if all notifications should be blocked from this repository.
	======================================================= */
	public set_subscription(
		-owner::string		= '',
		-repo::string		= '',
		-subscribed::boolean = true,
		-ignored::boolean = false
		) => {
		local(outmap = map)
		#outmap->insert('subscribed' = #subscribed)
		#outmap->insert('ignored' = #ignored)
		
		.request->urlPath = '/repos/'+#owner+'/'+#repo+'/subscription'
		.request->postParams = json_serialize(#outmap)
		.request->method='PUT'
		return .request
	}
	/* =======================================================
	Delete a Repository Subscription
		DELETE /repos/:owner/:repo/subscription
	======================================================= */
	public delete_subscription(
		-owner::string		= '',
		-repo::string		= ''
		) => {		
		.request->urlPath = '/repos/'+#owner+'/'+#repo+'/subscription'
		.request->method='DELETE'
		return .request
	}
}
]