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
	trait { import github_common }	
	data
		protected prefix::string	= 'result_',
		protected u::string 		= string,
		protected p::string 		= 'x-oauth-basic',
		public user::string			= '',
		public objectdata::array	= array,
		public headers				= github_header,
		public url::string			= string


	
}
]