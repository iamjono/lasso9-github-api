[
/* =======================================================================
	Notifications API
	
		List your notifications
		List your notifications in a repository
		Mark as read
		Mark notifications as read in a repository
		View a single thread
		Mark a thread as read
		Get a Thread Subscription
		Set a Thread Subscription
		Delete a Thread Subscription
	
	GitHub Notifications are powered by watched repositories. Users receive 
	notifications for discussions in repositories they watch including:
		Issues and their comments
		Pull Requests and their comments
		Comments on any commits
	
	Notifications are also sent for discussions in unwatched repositories 
	when the user is involved including:
		@mentions
		Issue assignments
		Commits the user authors or commits
		Any discussion in which the user actively participates
	
	All Notification API calls require the “notifications” or “repo API scopes. 
	Doing this will give read-only access to some Issue/Commit content. 
	You will still need the “repo” scope to access Issues and Commits from 
	their respective endpoints.
	
	Notifications come back as “threads”. A Thread contains information 
	about the current discussion of an Issue/PullRequest/Commit.
	
	Notifications are optimized for polling with the “Last-Modified” header. 
	If there are no new notifications, you will see a “304 Not Modified” response, 
	leaving your current rate limit untouched. There is an “X-Poll-Interval” 
	header that specifies how often (in seconds) you are allowed to poll. 
	In times of high server load, the time may increase. Please obey the header.
======================================================================= */
define github_notifications => type {
	data
		public request::http_request    = http_request,
		public objectdata::array		= array

	/* =======================================================
	List your notifications
		List all notifications for the current user, grouped by repository.
		GET /notifications
		
		Parameters
		Name			Type		Description
		all				boolean		If true, show notifications marked as read. Default: false
		participating	boolean		If true, only shows notifications in which the user is directly participating or mentioned. Default: false
		since			string		Filters out any notifications updated before the given time. This is a timestamp in ISO 8601 format: YYYY-MM-DDTHH:MM:SSZ. Default: Time.now
	======================================================= */
	public list(-user::string, -since=void, -all=void, -participating=void) => {

		local(outmap = array)
		#since->isA(::date)
			? #outmap->insert('since' = #since->format('yyyy-MM-ddHH:mm:ssZ'))
		#all->isA(::boolean)
			? #outmap->insert('all' = #all)
		#participating->isA(::boolean)
			? #outmap->insert('participating' = #participating)
		
		.request->getParams = #outmap->asStaticArray

		.request->urlPath = '/notifications'
		return .request
	}
	/* =======================================================
	List your notifications in a repository
		List all notifications for the current user.
		GET /repos/:owner/:repo/notifications
		
		Parameters		
		Name			Type	Description
		all				boolean	If true, show notifications marked as read. Default: false
		participating	boolean	If true, only shows notifications in which the user is directly participating or mentioned. 
								Default: false
		since			string	Filters out any notifications updated before the given time. 
								This is a timestamp in ISO 8601 format: YYYY-MM-DDTHH:MM:SSZ. 
								Default: Time.now
	======================================================= */
	public user_notifications(
		-owner::string, 
		-repo::string, 
		-since=void, -all=void, -participating=void
	) => {

		local(outmap = array)
		#since->isA(::date)
			? #outmap->insert('since' = #since->format('yyyy-MM-ddHH:mm:ssZ'))
		#all->isA(::boolean)
			? #outmap->insert('all' = #all)
		#participating->isA(::boolean)
			? #outmap->insert('participating' = #participating)
		
		.request->getParams = #outmap->asStaticArray

		.request->urlPath = '/repos/'+#owner+'/'+#repo+'/notifications'
		return .request
	}
	/* =======================================================
	Mark as read
		Marking a notification as “read” removes it from the default view on GitHub.com.
		PUT /notifications
		
		Parameters		
		Name			Type	Description
		last_read_at	string	Describes the last point that notifications were checked. 
								Anything updated since this time will not be updated. 
								This is a timestamp in ISO 8601 format: YYYY-MM-DDTHH:MM:SSZ. 
								Default: Time.now
	======================================================= */
	public mark_as_read(-last_read_at=void) => {
		.request->urlPath = '/notifications'
		.request->method='PUT'

		#last_read_at->isA(::date)
			? .request->getParams = (:#last_read_at->format('yyyy-MM-ddHH:mm:ssZ'))
			
		return .request
	}
	/* =======================================================
	Mark notifications as read in a repository
		Marking all notifications in a repository as “read” removes them from the default view on GitHub.com.
		PUT /repos/:owner/:repo/notifications
		
		Parameters		
		Name			Type	Description
		last_read_at	string	Describes the last point that notifications were checked. 
								Anything updated since this time will not be updated. 
								This is a timestamp in ISO 8601 format: YYYY-MM-DDTHH:MM:SSZ. 
								Default: Time.now
	======================================================= */
	public mark_as_read_in_repo(
		-owner::string, 
		-repo::string, 
		-last_read_at=void
	) => {
		.request->urlPath = '/repos/'+#owner+'/'+#repo+'/notifications'
		.request->method='PUT'

		#last_read_at->isA(::date)
			? .request->getParams = (:#last_read_at->format('yyyy-MM-ddHH:mm:ssZ'))
			
		return .request
	}
	/* =======================================================
	View a single thread
		GET /notifications/threads/:id
	======================================================= */
	public get(-id::integer) => {
		.request->urlPath = '/notifications/threads/'+#id
		return .request
	}
	/* =======================================================
	Mark a thread as read
		PATCH /notifications/threads/:id
		only response is header 205
	======================================================= */
	public thread_mark_as_read(-id::integer) => {
		.request->urlPath = '/notifications/threads/'+#id
		.request->method='PATCH'
		return .request // no need to process return
	}
	/* =======================================================
	Get a Thread Subscription
		This checks to see if the current user is subscribed to a thread. 
		You can also get a Repository subscription.
		GET /notifications/threads/:id/subscription
	======================================================= */
	public get_subscription(-id::integer) => {
		.request->urlPath = '/notifications/threads/'+#id+'/subscription'
		return .request
	}
	/* =======================================================
	Set a Thread Subscription
		This lets you subscribe to a thread, or ignore it. Subscribing to a thread is unnecessary if the user is already subscribed to the repository. Ignoring a thread will mute all future notifications (until you comment or get @mentioned).
		PUT /notifications/threads/:id/subscription
		
		Parameters		
		Name			Type		Description
		subscribed		boolean		Determines if notifications should be received from this thread
		ignored			boolean		Determines if all notifications should be blocked from this thread
	======================================================= */
	public set_subscription(
		-id::integer, 
		-subscribed=void, 
		-ignored=void
	) => {
		.request->urlPath = '/notifications/threads/'+#id+'/subscription'
		.request->method='PUT'

		local(outmap = map)
		#subscribed->isA(::boolean)
			? #outmap->insert('subscribed' = #subscribed)
		#ignored->isA(::boolean)
			? #outmap->insert('ignored' = #ignored)
		
		.request->postParams = json_serialize(#outmap)
			
		return .request
	}
	/* =======================================================
	Delete a Thread Subscription
		DELETE /notifications/threads/:id/subscription
		Response is a 204 header
	======================================================= */
	public delete_subscription(-id::integer) => {
		.request->urlPath = '/notifications/threads/'+#id+'/subscription'
		.request->method='DELETE'
		return .request
	}
	
}
]