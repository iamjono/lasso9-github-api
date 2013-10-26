[
/* =======================================================================
	Repository Starring API
	
	Repository Starring is a feature that lets users bookmark repositories. 
	Stars are shown next to repositories to show an approximate level of interest. 
	Stars have no effect on notifications or the activity feed. 
	For that, see Repository Watching.

	We recently changed the way watching works on GitHub. 
	Many 3rd party applications may be using the “watcher” endpoints 
	for accessing these. Starting today, you can start changing these 
	to the new “star” endpoints. See below. 
	Check the Watcher API Change post for more.
	
		List Stargazers
		List repositories being starred
		Check if you are starring a repository
		Star a repository
		Unstar a repository
======================================================================= */
define github_starring => type {
	parent github_parent
	data
		public objectdata::array		= array


	
}
]