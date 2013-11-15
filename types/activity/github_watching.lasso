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
		Check if you are watching a repository (LEGACY)
		Watch a repository (LEGACY)
		Stop watching a repository (LEGACY)
======================================================================= */
define github_watching => type {
	parent github_parent
	data
		protected prefix::string		= 'watching_',
		public objectdata::array		= array


		
	/* =======================================================
	List watchers
	GET /repos/:owner/:repo/subscribers
	======================================================= */
	public list_watchers(
		-owner::string,
		-repo::string
		) => {
		protect => {
			handle_error => { return error_msg+'<pre>'+error_stack+'</pre>' }
			local(urlstring = array, params = array)
			#urlstring->insert('repos')
			#urlstring->insert(#owner)			
			#urlstring->insert(#repo)			
			#urlstring->insert('subscribers')

			// run query
			local(url = 'https://api.github.com/'+#urlstring->join('/'))
			.url = #url
			..simple_get
		}
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
		protect => {
			handle_error => { return error_msg+'<pre>'+error_stack+'</pre>' }
			local(urlstring = array, params = array)
			#user->size ? #urlstring->insert('users') | #urlstring->insert('user')
			#user->size ? #urlstring->insert(#user)			
			#urlstring->insert('subscriptions')

			// run query
			local(url = 'https://api.github.com/'+#urlstring->join('/'))
			.url = #url
			..simple_get
		}
	}
	/* =======================================================
	Get a Repository Subscription
		GET /repos/:owner/:repo/subscription
	======================================================= */
	public get_subscription(
		-owner::string,
		-repo::string
		) => {
		protect => {
			handle_error => { return error_msg+'<pre>'+error_stack+'</pre>' }
			local(urlstring = array, params = array)
			#urlstring->insert('repos')
			#urlstring->insert(#owner)			
			#urlstring->insert(#repo)			
			#urlstring->insert('subscription')

			// run query
			local(url = 'https://api.github.com/'+#urlstring->join('/'))
			.url = #url
			..simple_get
		}
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
		protect => {
			handle_error => { return error_msg+'<pre>'+error_stack+'</pre>' }
			local(urlstring = array, params = array)
			#urlstring->insert('repos')
			#urlstring->insert(#owner)			
			#urlstring->insert(#repo)			
			#urlstring->insert('subscription')

			local(outmap = map)
			#outmap->insert('subscribed' = #subscribed)
			#outmap->insert('ignored' = #ignored)
			.url = 'https://api.github.com/' + #urlstring->join('/')
			// run query
			local(resp = http_request(
				.url,
				-username=.u,
				-password=.p,
				-basicAuthOnly=true,
				-postParams=json_serialize(#outmap),
				-reqMethod='PUT'
				)->response
			)
			local(res = json_deserialize(#resp->body->asString))
			#res->isA(::map) ? .objectdata = array(#res) 
			#res->isA(::array) ? .objectdata = #res
			.headers = #resp->headers

		}
	}
}
]