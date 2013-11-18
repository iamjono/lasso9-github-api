[
/* =======================================================================
	Notifications API
	
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

	
}
]